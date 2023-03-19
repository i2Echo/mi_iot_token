import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

// This function converts a string to a hash
String convertToHash(String str) {
  return md5.convert(const Utf8Encoder().convert(str)).toString().toUpperCase();
}

/// Generates an array of [length] random bytes.
Uint8List randomBytes(int length, {bool secure = false}) {
  assert(length > 0);
  final random = secure ? Random.secure() : Random();
  final Uint8List list = Uint8List(length);
  for (var i = 0; i < length; i++) {
    list[i] = random.nextInt(256);
  }
  return list;
}
