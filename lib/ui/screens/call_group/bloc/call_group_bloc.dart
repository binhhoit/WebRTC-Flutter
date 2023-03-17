import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fireAuth;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:webrtc_flutter/domain/entities/room/room.dart';
import 'package:webrtc_flutter/platform/config/build_config.dart';
import 'package:webrtc_flutter/ui/screens/call_group/bloc/call_group_state.dart';
import 'package:webrtc_flutter/ui/screens/call_sample/Constants.dart';
import 'package:webrtc_flutter/ui/screens/call_sample/signaling.dart';

@injectable
class CallGroupBloc extends Cubit<CallGroupState> {
  BuildConfig buildConfig;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  var idCurrent = fireAuth.FirebaseAuth.instance.currentUser?.uid ?? "";
  late Signaling signaling;
  late Room room;

  var duplicate = <String>[];
  CallGroupBloc(this.buildConfig) : super(const CallGroupState.init()) {
    getRooms('dQw6jgPNeshh8AEKsOr9yPpTOpp1-426658330133');
    getOfferOrAnswer('dQw6jgPNeshh8AEKsOr9yPpTOpp1-426658330133');
    getIce('dQw6jgPNeshh8AEKsOr9yPpTOpp1-426658330133');
  }

  final databaseReference = FirebaseFirestore.instance;

  String getBaseUrlServer() => buildConfig.baseUrl;

  void setSignaling(Signaling signaling) {
    this.signaling = signaling;
  }

  Future<void> sentData(String sessionId, String to, String data) async {
    duplicate.add(data);
    if (data.toLowerCase().startsWith(SignalingCommand.OFFER.name.toLowerCase())) {
      await sendOfferUser(sessionId, to, data);
    } else if (data.toLowerCase().startsWith(SignalingCommand.ANSWER.name.toLowerCase())) {
      await sendAnswerUser(sessionId, to, data);
    } else if (data.toLowerCase().startsWith(SignalingCommand.ICE.name.toLowerCase())) {
      await sendICEUser(sessionId, to, data);
    }
  }

  Future<void> createRoom(String idRoom, List<String> idUsers) async {
    try {
      await _database
          .child('rooms/$idRoom')
          .update({'id': idRoom, 'idUsers': idUsers, 'from': idCurrent});
      getRooms(idRoom);
      getOfferOrAnswer(idRoom);
      getIce(idRoom);
    } catch (e) {
      emit(CallGroupState.error(e.toString()));
    }
  }

  Future<void> sendOfferUser(String idRoom, String to, String offer) async {
    try {
      await _database.child('rooms/$idRoom/offer-answer/$to-$idCurrent').set({'offer': offer});
    } catch (e) {
      emit(CallGroupState.error(e.toString()));
    }
  }

  Future<void> sendICEUser(String idRoom, String to, String offer) async {
    try {
      await _database.child('rooms/$idRoom/ice/$to-$idCurrent').push().update({'ice': offer});
    } catch (e) {
      emit(CallGroupState.error(e.toString()));
    }
  }

  Future<void> sendAnswerUser(String idRoom, String to, String answer) async {
    try {
      await _database.child('rooms/$idRoom/offer-answer/$idCurrent-$to').update({'answer': answer});
    } catch (e) {
      emit(CallGroupState.error(e.toString()));
    }
  }

  Future<void> getOfferOrAnswer(String idRoom) async {
    print('getOfferOrAnswer');
    try {
      _database.child('rooms/$idRoom/offer-answer').onValue.listen((event) async {
        for (var offerOrAnswer in event.snapshot.children) {
          if (offerOrAnswer.key?.contains(idCurrent) == true) {
            var slipStringId = offerOrAnswer.key?.split('-');
            var offerOfId = "";
            slipStringId?.forEach((element) {
              if (!element.contains(idCurrent)) {
                offerOfId = element;
              }
            });
            var offer = jsonDecode(jsonEncode(offerOrAnswer.value))['offer'];
            var answer = jsonDecode(jsonEncode(offerOrAnswer.value))['answer'];
            var ice = jsonDecode(jsonEncode(offerOrAnswer.value))['ice'];
            if (idCurrent != slipStringId?.last && offer != null && !duplicate.contains(offer)) {
              await signaling.handleSignalingCommand(SignalingCommand.OFFER, offer,
                  sessionId: idRoom, to: room.idUsers, offerOfId: offerOfId);
              signaling.accept(idRoom, answerForId: offerOfId);
              duplicate.add(offer);
            } else if (answer != null && !duplicate.contains(answer)) {
              await signaling.handleSignalingCommand(SignalingCommand.ANSWER, answer,
                  sessionId: idRoom, to: room.idUsers, offerOfId: offerOfId);
              duplicate.add(answer);
            }
          }
        }
      }, onError: (e) {
        print(e);
        emit(CallGroupState.error(e.toString()));
      });
    } catch (e) {
      emit(CallGroupState.error(e.toString()));
    }
  }

  Future<void> getIce(String idRoom) async {
    print('getIce');
    try {
      _database.child('rooms/$idRoom/ice').onValue.listen((event) async {
        for (var child in event.snapshot.children) {
          if (child.key?.contains(idCurrent) == true) {
            var slipStringId = child.key?.split('-');
            var iceOfId = "";
            slipStringId?.forEach((element) {
              if (!element.contains(idCurrent)) {
                iceOfId = element;
              }
            });

            for (var iceData in child.children) {
              var ice = jsonDecode(jsonEncode(iceData.value))['ice'];
              if (idCurrent != slipStringId?.last && ice != null && !duplicate.contains(ice)) {
                await signaling.handleSignalingCommand(SignalingCommand.ICE, ice,
                    sessionId: idRoom, to: room.idUsers, offerOfId: iceOfId);
              }
            }
          }
        }
      }, onError: (e) {
        print(e);
        emit(CallGroupState.error(e.toString()));
      });
    } catch (e) {
      emit(CallGroupState.error(e.toString()));
    }
  }

  Future<void> getRooms(String idRoom) async {
    try {
      _database.child('rooms/$idRoom').onValue.listen((event) {
        if (jsonDecode(jsonEncode(event.snapshot.value)) != null) {
          room = Room.fromJson(jsonDecode(jsonEncode(event.snapshot.value)));
        }
      }, onError: (e) {
        print(e);
        emit(CallGroupState.error(e.toString()));
      });
    } catch (e) {
      emit(CallGroupState.error(e.toString()));
    }
  }
}
