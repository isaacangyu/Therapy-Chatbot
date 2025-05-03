import 'dart:convert';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pointycastle/export.dart' as pc;

KeyDetails kdfKeyDerivation({required String initialKey, String? salt}) {
  var kdf = pc.Argon2BytesGenerator();
  var kdfSalt = (salt != null ? base64.decode(salt) : encrypt.SecureRandom(0x10).bytes);
  var kdfParams = pc.Argon2Parameters(
    pc.Argon2Parameters.ARGON2_id,
    kdfSalt,
    desiredKeyLength: 0x20
  );
  kdf.init(kdfParams);
  var stretchedKey = kdf.process(utf8.encode(initialKey));
  return KeyDetails(base64.encode(stretchedKey), base64.encode(kdfSalt));
}

class KeyDetails {
  const KeyDetails(this.key, this.salt);
  
  final String key;
  final String salt;
}

String sha256Digest(String value) {
  var sha256 = pc.SHA256Digest();
  var digest = sha256.process(utf8.encode(value));
  return base64.encode(digest);
}

encrypt.Encrypter? clientEncrypter;

void initClientSideEncrypter(String encryptionKeyBase64) {
  clientEncrypter = encrypt.Encrypter(encrypt.AES(
    encrypt.Key.fromBase64(encryptionKeyBase64),
    mode: encrypt.AESMode.gcm // Must use an authenticated mode like GCM!
  ));
}

String symmetricEncrypt(String plainText) {
  // A minimum initalization vector of 96 bits is recommended for GCM mode.
  // Here, we're using 128 bits.
  var initializationVector = encrypt.IV.fromLength(0x10);
  var cipherText = clientEncrypter!.encrypt(plainText, iv: initializationVector);
  return '${cipherText.base64}:${initializationVector.base64}';
}

String symmetricDecrypt(String cipherTextIvBase64, encrypt.Encrypter decrypter) {
  var split = cipherTextIvBase64.split(':');
  if (split.length != 2) {
    throw const FormatException('Invalid data.');
  }
  var cipherTextBase64 = split[0];
  var initializationVectorBase64 = split[1];
  var initializationVector = encrypt.IV.fromBase64(initializationVectorBase64);
  var cipherText = encrypt.Encrypted.fromBase64(cipherTextBase64);
  return decrypter.decrypt(cipherText, iv: initializationVector);
}
