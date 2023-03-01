
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

extension TextControllerExt on TextEditingController {
  Stream<String> toStream() {
    BehaviorSubject<String> stream = BehaviorSubject();
    addListener(() {
      stream.value = text;
    });
    return stream;
  }
}
