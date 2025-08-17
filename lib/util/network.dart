import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pointycastle/export.dart' as pc;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart' as ws;
// import 'package:web_socket_channel/status.dart' as wsStatus;

import '/util/global.dart';
import '/util/crypto.dart';

/// `_cipher` and `_publicKeyParams` are used to encrypt data before sending it to the backend.
/// `_responseDecrypter` is used to decrypt responses from the backend.
/// `_responseKeyEncrypted` is the key sent to the backend that the backend uses to encrypt its responses.
/// The backend uses its private key to decrypt the response key first.
/// `_signer` is used to validate response data from the backend.
late final pc.PublicKeyParameter<pc.RSAPublicKey> _publicKeyParams;
late final pc.AsymmetricBlockCipher _cipher;
late final encrypt.Encrypter responseDecrypter;
late final String responseKeyEncrypted;
late final encrypt.Signer _signer;

// Formula for RSA max message size (bytes): max_size = key_size - 2 * hash_size - 2
const rsaMaxMessageSize = Global.rsaKeySizeBytes - 2 * 32 - 2;

/// RSA can only process so many bytes in one operation.
/// This method encrypts an arbitrary amount of data incrementally.
encrypt.Encrypted _incrementalEncrypt(String data) {
  // Reset the cipher before beginning operations.
  _cipher..reset()..init(true, _publicKeyParams);
  
  var bytes = utf8.encode(data);
  var size = (bytes.length / rsaMaxMessageSize).ceil() * Global.rsaKeySizeBytes;
  
  var out = Uint8List(size);
  var inpOff = 0, outOff = 0;
  while (inpOff < bytes.length) {
    var chunkSize = min(bytes.length - inpOff, rsaMaxMessageSize);
    _cipher.processBlock(bytes, inpOff, chunkSize, out, outOff);
    inpOff += chunkSize;
    outOff += Global.rsaKeySizeBytes;
  }
  
  return encrypt.Encrypted(out);
}

Future<bool> loadKeys() async {
  try {    
    var response = await http.get(Uri.parse(API.initBaseUrl).resolve(API.publicKey));
    if (response.statusCode == 200) {
      var publicKey = encrypt.RSAKeyParser().parse(response.body) as pc.RSAPublicKey;
      // debugPrint('public key: ${response.body}');
      var encoding = encrypt.RSAEncoding.OAEP;
      var digest = encrypt.RSADigest.SHA256;
      
      // Forked from: https://github.com/leocavalcante/encrypt/blob/v5.0.3/lib/src/algorithms/rsa.dart
      _cipher = encoding == encrypt.RSAEncoding.OAEP
        ? digest == encrypt.RSADigest.SHA1
            ? pc.OAEPEncoding(pc.RSAEngine())
            : pc.OAEPEncoding.withSHA256(pc.RSAEngine())
        : pc.PKCS1Encoding(pc.RSAEngine());
      
      _publicKeyParams = pc.PublicKeyParameter(publicKey);
      // End fork.
      
      _signer = encrypt.Signer(
        encrypt.RSASigner(encrypt.RSASignDigest.SHA256, publicKey: publicKey)
      );
      
      var responseKey = encrypt.SecureRandom(0x10).base64;
      responseKeyEncrypted = _incrementalEncrypt(responseKey).base64;
      responseDecrypter = encrypt.Encrypter(encrypt.AES(
          encrypt.Key.fromBase64(responseKey),
          mode: encrypt.AESMode.gcm // Must use an authenticated mode like GCM!
      ));
      return true;
    }
    debugPrint('HTTP response code: ${response.statusCode}');
  } catch (e) {
    debugPrint('Load keys exception: $e');
  }
  return false;
}

String verifyData(String data) {
  var split = data.split(':');
  if (split.length != 2) {
    throw const FormatException('Invalid data.');
  }
  var bodyBase64 = split[0];
  var body = utf8.decode(base64.decode(bodyBase64));
  var signatureBase64 = split[1];
  if (!_signer.verify64(body, signatureBase64)) {
    throw Exception('Failed to verify signature.');
  }
  return body;
}

Object includeToken(String email, String token, Map<String, dynamic> data) {
  data['_email'] = email;
  data['_token'] = token;
  return data;
}

enum HttpRequestType {post, delete}

Future<T> httpDataSecure<T>(
  HttpRequestType type,
  String path,
  Object data,
  T Function(Map<String, dynamic>) onHttpOK,
  T Function(int) onError,
) async {
  int statusCode = -1;
  
  try {
    var cipherText = _incrementalEncrypt(jsonEncode(data));
    
    var httpFunc = switch (type) {
      HttpRequestType.post => http.post,
      HttpRequestType.delete => http.delete
    };
    
    var response = await httpFunc(
      Uri.parse(API.baseUrl!).resolve(path),
      headers: {
        // 'Cache-Control': 'no-cache',
        'X-Custom-Response-Key': responseKeyEncrypted,
      },
      body: cipherText.bytes,
    );
    if (response.statusCode == 200) {
      var body = verifyData(symmetricDecrypt(response.body, responseDecrypter));
      var json = jsonDecode(body) as Map<String, dynamic>;
      return onHttpOK(json);
    }
    statusCode = response.statusCode;
    debugPrint('HTTP response code: ${response.statusCode}');
  } catch (e) {
    debugPrint('Request exception: $e');
  }
  return onError(statusCode);
}

Future<T> httpPostSecure<T>(
  String path,
  Object data,
  T Function(Map<String, dynamic>) onHttpOK,
  T Function(int) onError,
) async {
  return httpDataSecure(HttpRequestType.post, path, data, onHttpOK, onError);
}

Future<T> httpDeleteSecure<T>(
  String path,
  Object data,
  T Function(Map<String, dynamic>) onHttpOK,
  T Function(int) onError,
) async {
  return httpDataSecure(HttpRequestType.delete, path, data, onHttpOK, onError);
}

Future<T> httpGetSecure<T>(
  String path,
  T Function(Map<String, dynamic>) onHttpOK,
  T Function() onError,
) async {
  try {
    var response = await http.get(
      Uri.parse(API.baseUrl!).resolve(path),
      headers: {
        'Cache-Control': 'no-cache',
        'X-Custom-Response-Key': responseKeyEncrypted,
      }
    );
    if (response.statusCode == 200) {
      var body = verifyData(symmetricDecrypt(response.body, responseDecrypter));
      var json = jsonDecode(body) as Map<String, dynamic>;
      return onHttpOK(json);
    }
    debugPrint('HTTP response code: ${response.statusCode}');
  } catch (e) {
    debugPrint('Request exception: $e');
  }
  return onError();
}

Future<T> httpGetApi<T>(
  String path,
  T Function(Map<String, dynamic>) onHttpOK,
  T Function() onError,
) async {
  try {
    var response = await http.get(
      Uri.parse(API.initBaseUrl).resolve(path),
      headers: {
        'Cache-Control': 'no-cache',
      }
    );
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as Map<String, dynamic>;
      return onHttpOK(json);
    }
    debugPrint('HTTP response code: ${response.statusCode}');
  } catch (e) {
    debugPrint('Request exception: $e');
  }
  return onError();
}

class WebSocketStatus {
  const WebSocketStatus(this.ok, {this.channel, this.broadcast});
  
  final bool ok;
  final ws.WebSocketChannel? channel;
  final Stream<dynamic>? broadcast;
}

Future<WebSocketStatus> websocketConnect(String path, Object initialData) async {
  try {
    var channel = ws.WebSocketChannel.connect(Uri.parse(API.wsBaseUrl!).resolve(path));
    var cipherText = _incrementalEncrypt(jsonEncode(initialData));
    
    await channel.ready;
    channel.sink.add(cipherText.bytes);
    
    var broadcast = channel.stream.asBroadcastStream();
    
    // Wait for the first piece of data. We cannot simply await `channel.stream.first`.
    var completer = Completer<dynamic>();
    var subscription = broadcast.listen(
      (value) {
        if (!completer.isCompleted) {
          completer.complete(value);
        }
      },
      onError: (error) {
        if (!completer.isCompleted) {
          completer.completeError(error);
        }
      },
      cancelOnError: true
    );
    var firstData = await completer.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () async {
        await subscription.cancel();
        throw TimeoutException('WebSocket initial connection timed out.');
      }
    );
    await subscription.cancel();
    
    var body = verifyData(symmetricDecrypt(firstData, responseDecrypter));
    var json = jsonDecode(body) as Map<String, dynamic>;
    var authorized = json['status'] == 0;
    return WebSocketStatus(authorized, channel: channel, broadcast: broadcast);
  } catch (e) {
    debugPrint('WebSocket exception: $e');
    return const WebSocketStatus(false);
  }
}

void websocketAddFrame(ws.WebSocketChannel channel, Object data) {
  try {
    var cipherText = _incrementalEncrypt(jsonEncode(data));
    channel.sink.add(cipherText.bytes);
  } catch (e) {
    debugPrint('WebSocket exception: $e');
  }
}

Future<void> websocketClose(
  ws.WebSocketChannel channel, 
  [int? closeCode, String? closeReason]
) async {
  try {
    await channel.sink.close(closeCode, closeReason);
  } catch (e) {
    debugPrint('WebSocket exception: $e');
  }
}
