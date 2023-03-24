import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fireAuth;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:webrtc_flutter/domain/entities/room/room.dart';
import 'package:webrtc_flutter/platform/config/build_config.dart';
import 'package:webrtc_flutter/ui/screens/call_group/bloc/call_group_state.dart';
import 'package:webrtc_flutter/ui/screens/call_sample/Constants.dart';
import 'package:webrtc_flutter/ui/screens/call_sample/signaling.dart';

@injectable
class CallGroupBloc extends Cubit<CallGroupState> {
  BuildConfig buildConfig;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final _idCurrent = fireAuth.FirebaseAuth.instance.currentUser?.uid ?? "";
  final _connectSuccessWithUsers = <String, bool>{};
  late Signaling signaling;
  late Room room;
  final BehaviorSubject<bool> _checkOffer = BehaviorSubject();

  var duplicate = <String>[];
  CallGroupBloc(this.buildConfig) : super(const CallGroupState.init());

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
          .update({'id': idRoom, 'idUsers': idUsers, 'from': _idCurrent});
      getRooms(idRoom);
      getIce(idRoom);
    } catch (e) {
      emit(CallGroupState.error(e.toString()));
    }
  }

  Future<void> deleteRoom(String idRoom) async {
    try {
      await sendByeUser(idRoom);
      await _database.child('rooms/$idRoom').remove();
    } catch (e) {
      emit(CallGroupState.error(e.toString()));
    }
  }

  Future<void> sendOfferUser(String idRoom, String to, String offer) async {
    try {
      await _database.child('rooms/$idRoom/offer-answer/$to-$_idCurrent').set({'offer': offer});
    } catch (e) {
      emit(CallGroupState.error(e.toString()));
    }
    _connectSuccessWithUsers[to] = true;
    _checkOffer.value = true;
  }

  Future<void> sendICEUser(String idRoom, String to, String offer) async {
    try {
      await _database.child('rooms/$idRoom/ice/$to-$_idCurrent').push().update({'ice': offer});
    } catch (e) {
      emit(CallGroupState.error(e.toString()));
    }
  }

  Future<void> sendAnswerUser(String idRoom, String to, String answer) async {
    try {
      await _database
          .child('rooms/$idRoom/offer-answer/$_idCurrent-$to')
          .update({'answer': answer});
    } catch (e) {
      emit(CallGroupState.error(e.toString()));
    }
    getIce(idRoom);
    _connectSuccessWithUsers[to] = true;
    _checkOffer.value = true;
  }

  Future<void> getOfferOrAnswer(String idRoom) async {
    print('getOfferOrAnswer');
    try {
      _database.child('rooms/$idRoom/offer-answer').onValue.listen((event) async {
        for (var offerOrAnswer in event.snapshot.children) {
          if (offerOrAnswer.key != null && offerOrAnswer.key?.contains(_idCurrent) == true) {
            var slipStringId = offerOrAnswer.key?.split('-');
            var idUserHandle = "";
            slipStringId?.forEach((element) {
              if (!element.contains(_idCurrent)) {
                idUserHandle = element;
              }
            });
            var offer = jsonDecode(jsonEncode(offerOrAnswer.value))['offer'];
            var answer = jsonDecode(jsonEncode(offerOrAnswer.value))['answer'];
            if (_idCurrent != slipStringId?.last &&
                offer != null &&
                answer == null &&
                !duplicate.contains(offer) &&
                !duplicate.contains('offer ${offerOrAnswer.key}')) {
              duplicate.add('offer ${offerOrAnswer.key}');
              await signaling.handleSignalingCommand(SignalingCommand.OFFER, offer,
                  sessionId: idRoom, to: room.idUsers, offerOfId: idUserHandle);
              signaling.accept(idRoom, answerForId: idUserHandle);
              print('[offer key]: ' + 'offer ${offerOrAnswer.key.toString()}');
              await Future.delayed(const Duration(seconds: 1));
              duplicate.add(offer);
            } else if (_idCurrent == slipStringId?.last &&
                answer != null &&
                !duplicate.contains('answer ${offerOrAnswer.key}') &&
                !duplicate.contains(answer)) {
              duplicate.add('answer ${offerOrAnswer.key}');
              await signaling.handleSignalingCommand(SignalingCommand.ANSWER, answer,
                  sessionId: idRoom, to: room.idUsers, answerOfId: idUserHandle);
              await Future.delayed(const Duration(seconds: 1));
              duplicate.add(answer);
            } else {
              duplicate.clear();
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
          if (child.key?.contains(_idCurrent) == true) {
            var slipStringId = child.key?.split('-');
            var iceOfId = "";
            slipStringId?.forEach((element) {
              if (!element.contains(_idCurrent)) {
                iceOfId = element;
              }
            });

            if (_idCurrent == slipStringId?.first &&
                /*!duplicate.contains('ice ${child.key}') &&*/
                child.children.length >= 6) {
              for (var iceData in child.children) {
                var ice = jsonDecode(jsonEncode(iceData.value))['ice'];
                if (_idCurrent == slipStringId?.first && ice != null) {
                  await signaling.handleSignalingCommand(SignalingCommand.ICE, ice,
                      sessionId: idRoom, iceOfId: iceOfId);
                }
              }
              await Future.delayed(const Duration(seconds: 1));
              duplicate.add('ice ${child.key}');
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
      _database.child('rooms/$idRoom').once().then((event) {
        if (jsonDecode(jsonEncode(event.snapshot.value)) != null) {
          room = Room.fromJson(jsonDecode(jsonEncode(event.snapshot.value)));
          _checkConnectWithOtherUser(room.idUsers);
          getOfferOrAnswer(room.id);
          listenBye(room.id);
          emit(CallGroupState.room(room));
        }
      }, onError: (e) {
        print(e);
        emit(CallGroupState.error(e.toString()));
      });
    } catch (e) {
      emit(CallGroupState.error(e.toString()));
    }
  }

  Future<void> sendByeUser(String idRoom) async {
    try {
      await _database.child('rooms/$idRoom/bye').set({'bye': true});
    } catch (e) {
      emit(CallGroupState.error(e.toString()));
    }
  }

  Future<void> listenBye(String idRoom) async {
    try {
      _database.child('rooms/$idRoom/bye').onValue.listen((event) {
        if (jsonDecode(jsonEncode(event.snapshot.value)) != null) {
          if (!isClosed) emit(const CallGroupState.closeRoom());
        }
      }, onError: (e) {
        print(e);
        emit(CallGroupState.error(e.toString()));
      });
    } catch (e) {
      emit(CallGroupState.error(e.toString()));
    }
  }

  _checkConnectWithOtherUser(List<String> userIds) {
    for (var id in userIds) {
      _connectSuccessWithUsers[id] = false;
    }
    _createOfferOtherUser();
  }

  _createOfferOtherUser() async {
    _checkOffer.debounceTime(const Duration(seconds: 5)).listen((value) {
      var inviteUser = <String>[];
      _connectSuccessWithUsers.forEach((key, value) {
        if (!value && key != _idCurrent) {
          inviteUser.add(key);
        }
      });
      print('[invite more]: invite ${inviteUser.length.toString()}');
      if (inviteUser.isNotEmpty) {
        print(inviteUser);
        signaling.inviteOtherUser(inviteUser, room.id);
        emit(CallGroupState.inviteOtherConnect(inviteUser));
      }
    });
  }

  @override
  Future<void> close() {
    print('call bloc is close');
    return super.close();
  }
}
