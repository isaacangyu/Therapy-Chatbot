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
