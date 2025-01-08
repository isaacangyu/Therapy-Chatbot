import 'dart:convert';

import 'package:encrypt/encrypt.dart';
// ignore: depend_on_referenced_packages
import 'package:pointycastle/asymmetric/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '/util/global.dart';

Encrypter? encrypter;
Signer? signer;

Future<bool> loadKeys() async {
  try {
    var response = await http.get(Uri.parse(Global.publicKeyUrl));
    if (response.statusCode == 200) {
      var publicKey = RSAKeyParser().parse(response.body) as RSAPublicKey;
      // debugPrint('public key: ${response.body}');
      encrypter = Encrypter(RSA(publicKey: publicKey, encoding: RSAEncoding.OAEP, digest: RSADigest.SHA256));
      signer = Signer(RSASigner(RSASignDigest.SHA256, publicKey: publicKey));
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
  var signature = split[1];
  if (!signer!.verify64(bodyBase64, signature)) {
    throw Exception('Failed to verify signature.');
  }
  return utf8.decode(base64Decode(bodyBase64));
}

Future<T> httpPostSecure<T>(
  String? url,
  Object data,
  T Function(Map<String, dynamic>) onHttpOK,
  T Function() onError,
) async {
  try {
    var cipherText = encrypter!.encrypt(data.toString());
    var response = await http.post(
      Uri.parse(url!),
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
  String? url,
  T Function(Map<String, dynamic>) onHttpOK,
  T Function() onError,
) async {
  try {
    var response = await http.get(
      Uri.parse(url!),
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
  String? url,
  T Function(Map<String, dynamic>) onHttpOK,
  T Function() onError,
) async {
  try {
    var response = await http.get(
      Uri.parse(url!),
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
