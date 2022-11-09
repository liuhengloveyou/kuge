import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';

String generateMd5(String data) {
  var content = Utf8Encoder().convert(data);
  var digest = md5.convert(content);
  return hex.encode(digest.bytes);
}
