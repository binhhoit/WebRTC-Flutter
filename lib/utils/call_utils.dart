import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:fluttertoast/fluttertoast.dart';

void callEventHandle(CallEvent? event) {
  switch (event!.event) {
    case Event.ACTION_CALL_INCOMING:
// TODO: received an incoming call
      break;
    case Event.ACTION_CALL_START:
// TODO: started an outgoing call
// TODO: show screen calling in Flutter
      break;
    case Event.ACTION_CALL_ACCEPT:
      Fluttertoast.showToast(
          msg: 'Accept Call}',
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16);
      print(event.body.toString());
      break;
    case Event.ACTION_CALL_DECLINE:
// TODO: declined an incoming call
      break;
    case Event.ACTION_CALL_ENDED:
// TODO: ended an incoming/outgoing call
      break;
    case Event.ACTION_CALL_TIMEOUT:
// TODO: missed an incoming call
      break;
    case Event.ACTION_CALL_CALLBACK:
// TODO: only Android - click action `Call back` from missed call notification
      break;
    case Event.ACTION_CALL_TOGGLE_HOLD:
// TODO: only iOS
      break;
    case Event.ACTION_CALL_TOGGLE_MUTE:
// TODO: only iOS
      break;
    case Event.ACTION_CALL_TOGGLE_DMTF:
// TODO: only iOS
      break;
    case Event.ACTION_CALL_TOGGLE_GROUP:
// TODO: only iOS
      break;
    case Event.ACTION_CALL_TOGGLE_AUDIO_SESSION:
// TODO: only iOS
      break;
    case Event.ACTION_DID_UPDATE_DEVICE_PUSH_TOKEN_VOIP:
// TODO: only iOS
      break;
  }
}
