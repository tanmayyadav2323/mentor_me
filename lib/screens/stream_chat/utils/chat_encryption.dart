// import 'dart:convert';
// import 'dart:typed_data';

// // import 'package:webcrypto/webcrypto.dart';

// // / Model class for storing keys
// class JsonWebKeyPair {
//   const JsonWebKeyPair({
//     required this.privateKey,
//     required this.publicKey,
//   });

//   final String privateKey;
//   final String publicKey;
// }

// Future<JsonWebKeyPair> generateKeys() async {
//   // final keyPair = await EcdhPrivateKey.generateKey(EllipticCurve.p256);
//   // final publicKeyJwk = await keyPair.publicKey.exportJsonWebKey();
//   // final privateKeyJwk = await keyPair.privateKey.exportJsonWebKey();

//   return JsonWebKeyPair(
//     privateKey: json.encode(privateKeyJwk),
//     publicKey: json.encode(publicKeyJwk),
//   );
// }

// // SendersJwk -> sender.privateKey
// // ReceiverJwk -> receiver.publicKey
// Future<List<int>> deriveKey(String senderJwk, String receiverJwk) async {
//   // Sender's key
//   final senderPrivateKey = json.decode(senderJwk);
//   final senderEcdhKey = await EcdhPrivateKey.importJsonWebKey(
//     senderPrivateKey,
//     EllipticCurve.p256,
//   );

//   // Receiver's key
//   final receiverPublicKey = json.decode(receiverJwk);
//   final receiverEcdhKey = await EcdhPublicKey.importJsonWebKey(
//     receiverPublicKey,
//     EllipticCurve.p256,
//   );

//   // Generating CryptoKey
//   final derivedBits = await senderEcdhKey.deriveBits(256, receiverEcdhKey);
//   return derivedBits;
// }

// // The "iv" stands for initialization vector (IV). To ensure the encryption’s strength,
// // each encryption process must use a random and distinct IV.
// // It’s included in the message so that the decryption procedure can use it.
// final Uint8List iv = Uint8List.fromList('Initialization Vector'.codeUnits);

// Future<String> encryptMessage(String message, List<int> deriveKey) async {
//   // Importing cryptoKey
//   final aesGcmSecretKey = await AesGcmSecretKey.importRawKey(deriveKey);

//   // Converting message into bytes
//   final messageBytes = Uint8List.fromList(message.codeUnits);

//   // Encrypting the message
//   final encryptedMessageBytes =
//       await aesGcmSecretKey.encryptBytes(messageBytes, iv);

//   // Converting encrypted message into String
//   final encryptedMessage = String.fromCharCodes(encryptedMessageBytes);
//   return encryptedMessage;
// }

// Future<String> decryptMessage(
//     String encryptedMessage, List<int> deriveKey) async {
//   // Importing cryptoKey
//   final aesGcmSecretKey = await AesGcmSecretKey.importRawKey(deriveKey);

//   // Converting message into bytes
//   final messageBytes = Uint8List.fromList(encryptedMessage.codeUnits);

//   // Decrypting the message
//   final decryptedMessageBytes =
//       await aesGcmSecretKey.decryptBytes(messageBytes, iv);

//   // Converting decrypted message into String
//   final decryptedMessage = String.fromCharCodes(decryptedMessageBytes);
//   return decryptedMessage;
// }
