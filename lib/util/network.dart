import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '/util/global.dart';

late final Encrypter _encrypter;
late final Signer _signer;

Future<bool> loadKeys() async {
  try {
    var response = await http.get(Uri.parse(API.initBaseUrl).resolve(API.publicKey));
    if (response.statusCode == 200) {
      var publicKey = RSAKeyParser().parse(response.body) as RSAPublicKey;
      // debugPrint('public key: ${response.body}');
      _encrypter = Encrypter(RSA(publicKey: publicKey, encoding: RSAEncoding.OAEP, digest: RSADigest.SHA256));
      _signer = Signer(RSASigner(RSASignDigest.SHA256, publicKey: publicKey));
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

Object includeToken(String token, Map<String, dynamic> data) {
  data['token'] = token;
  return data;
}

Future<T> httpPostSecure<T>(
  String path,
  Object data,
  T Function(Map<String, dynamic>) onHttpOK,
  T Function() onError,
) async {
  try {
    var cipherText = _encrypter.encrypt(jsonEncode(data));
    var response = await http.post(
      Uri.parse(API.baseUrl!).resolve(path),
      body: cipherText.bytes,
    );
    if (response.statusCode == 200) {
      var body = verifyData(response.body);
      var json = jsonDecode(body) as Map<String, dynamic>;
      return onHttpOK(json);
    }
    debugPrint('HTTP response code: ${response.statusCode}');
  } catch (e) {
    debugPrint('Request exception: $e');
  }
  return onError();
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
      }
    );
    if (response.statusCode == 200) {
      var body = verifyData(response.body);
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
