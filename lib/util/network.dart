import 'dart:convert';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pointycastle/export.dart' as pc;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '/util/global.dart';
import '/util/crypto.dart';

/// `_encrypter` is used to encrypt data before sending it to the backend.
/// `_responseDecrypter` is used to decrypt responses from the backend.
/// `_responseKeyEncrypted` is the key sent to the backend that the backend uses to encrypt its responses.
/// The backend uses its private key to decrypt the response key first.
/// `_signer` is used to validate response data from the backend.
late final encrypt.Encrypter _encrypter, _responseDecrypter;
late final String _responseKeyEncrypted;
late final encrypt.Signer _signer;

Future<bool> loadKeys() async {
  try {    
    var response = await http.get(Uri.parse(API.initBaseUrl).resolve(API.publicKey));
    if (response.statusCode == 200) {
      var publicKey = encrypt.RSAKeyParser().parse(response.body) as pc.RSAPublicKey;
      // debugPrint('public key: ${response.body}');
      _encrypter = encrypt.Encrypter(
        encrypt.RSA(
          publicKey: publicKey, 
          encoding: encrypt.RSAEncoding.OAEP, 
          digest: encrypt.RSADigest.SHA256
        )
      );
      _signer = encrypt.Signer(encrypt.RSASigner(encrypt.RSASignDigest.SHA256, publicKey: publicKey));
      
      var responseKey = encrypt.SecureRandom(0x10).base64;
      _responseKeyEncrypted = _encrypter.encrypt(responseKey).base64;
      _responseDecrypter = encrypt.Encrypter(encrypt.AES(
          encrypt.Key.fromBase64(responseKey),
          mode: encrypt.AESMode.gcm // Must use an authenticated mode like GCM!
      ));
      return true;
    }
    debugPrint('HTTP response code: ${response.statusCode}');
  } catch (e) {
    debugPrint('Exception: $e');
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

Future<T> httpPostSecure<T>(
  String path,
  Object data,
  T Function(Map<String, dynamic>) onHttpOK,
  T Function(int) onError,
) async {
  int statusCode = -1;
  
  try {
    var cipherText = _encrypter.encrypt(jsonEncode(data));
    var response = await http.post(
      Uri.parse(API.baseUrl!).resolve(path),
      headers: {
        // 'Cache-Control': 'no-cache',
        'X-Custom-Response-Key': _responseKeyEncrypted,
      },
      body: cipherText.bytes,
    );
    if (response.statusCode == 200) {
      var body = verifyData(symmetricDecrypt(response.body, _responseDecrypter));
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
        'X-Custom-Response-Key': _responseKeyEncrypted,
      }
    );
    if (response.statusCode == 200) {
      var body = verifyData(symmetricDecrypt(response.body, _responseDecrypter));
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
