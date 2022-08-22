import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt_io.dart';
import 'package:pointycastle/asymmetric/api.dart';

class AESEncryption {
  static final key = encrypt.Key.fromLength(32);
  static final iv = encrypt.IV.fromLength(16);
  static final encrypter = encrypt.Encrypter(encrypt.AES(key));
  var publicKey ;
  var privKey ;

  rsaEncrypt()async {
     publicKey = await parseKeyFromFile<RSAPublicKey>('test/public.pem');
     privKey = await parseKeyFromFile<RSAPrivateKey>('test/private.pem');
  }
  encryptRsaMSg(String txt   ){
    rsaEncrypt();
    final encrypter = encrypt.Encrypter(RSA(publicKey: publicKey, privateKey: privKey));
    encrypter.encrypt (txt) ;
  }
   encryptMsg(String text) => encrypter.encrypt(text, iv: iv);

  decryptMsg(encrypt.Encrypted text) => encrypter.decrypt(text, iv: iv);

  getCode(String encoded) => encrypt.Encrypted.fromBase64(encoded);
}