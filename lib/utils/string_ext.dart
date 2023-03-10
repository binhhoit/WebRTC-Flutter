import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

String decompress(String input) {
  var raw = latin1.encode(input);
  var byteArray = Uint8List.fromList(raw);
  final gzip = GZipCodec();
  final decompressed = gzip.decode(byteArray);
  return latin1.decode(decompressed);
}
