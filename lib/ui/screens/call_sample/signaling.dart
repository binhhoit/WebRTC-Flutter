import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'Constants.dart';
import 'random_string.dart';

enum SignalingState {
  ConnectionOpen,
  ConnectionClosed,
  ConnectionError,
}

enum CallState {
  CallStateNew,
  CallStateRinging,
  CallStateInvite,
  CallStateConnected,
  CallStateBye,
}

enum VideoSource {
  Camera,
  Screen,
}

class Session {
  Session({required this.sid, required this.to});
  String sid;
  List<String>? to;
  Map<String, RTCPeerConnection>? pcs;
  Map<String, List<RTCIceCandidate>> remoteCandidates = {};
  Map<String, bool> isConnectSuccess = {};
}

class Signaling {
  final String _selfId = FirebaseAuth.instance.currentUser?.uid ?? randomNumeric(6);
  final Map<String, Session> _sessions = {};
  MediaStream? _localStream;

  List<RTCRtpSender> _senders = <RTCRtpSender>[];
  VideoSource _videoSource = VideoSource.Camera;

  Function(WebRTCSessionState state)? onWebRTCSessionState;
  Function(Session session, CallState state)? onCallStateChange;
  Function(String userId, RTCPeerConnectionState state)? onConnectionState;
  Function(MediaStream stream)? onLocalStream;
  Function(Session session, MediaStream stream, String userId)? onAddRemoteStream;
  Function(Session session, MediaStream stream, String userId)? onRemoveRemoteStream;
  Function(String, String, String)? sendData;

  String get sdpSemantics => 'unified-plan';
  String? offer;

  final Map<String, dynamic> _iceServers = {
    'iceServers': [
      {'url': 'stun:stun.l.google.com:19302'},
    ]
  };

  final Map<String, dynamic> _config = {
    'mandatory': {},
    'optional': [
      {'DtlsSrtpKeyAgreement': true},
    ]
  };

  final Map<String, dynamic> _dcConstraints = {
    'mandatory': {
      'OfferToReceiveAudio': false,
      'OfferToReceiveVideo': false,
    },
    'optional': [],
  };

  close() async {
    await _cleanSessions();
  }

  void switchCamera() {
    if (_localStream != null) {
      if (_videoSource != VideoSource.Camera) {
        for (var sender in _senders) {
          if (sender.track!.kind == 'video') {
            sender.replaceTrack(_localStream!.getVideoTracks()[0]);
          }
        }
        _videoSource = VideoSource.Camera;
        onLocalStream?.call(_localStream!);
      } else {
        Helper.switchCamera(_localStream!.getVideoTracks()[0]);
      }
    }
  }

  void muteMic() {
    if (_localStream != null) {
      bool enabled = _localStream!.getAudioTracks()[0].enabled;
      _localStream!.getAudioTracks()[0].enabled = !enabled;
      Helper.setMicrophoneMute(!enabled, _localStream!.getAudioTracks()[0]);
    }
  }

  void invite(List<String> to) async {
    var sessionId = '$_selfId-${randomNumeric(12)}';
    Session session = await _createSession(null, sessionId: sessionId, userIds: to);
    _sessions[sessionId] = session;
    _createOffer(session, to, _selfId);
    onCallStateChange?.call(session, CallState.CallStateNew);
    onCallStateChange?.call(session, CallState.CallStateInvite);
  }

  // TODO: for case other use pair connection.
  void inviteOtherUser(List<String> to, String sessionId) async {
    var session = _sessions[sessionId];
    if (session != null) {
      _createOffer(session, to, _selfId);
    }
  }

  void bye(String sessionId) {
    var sess = _sessions[sessionId];
    if (sess != null) {
      _closeSession(sess);
    }
  }

  void accept(String sessionId, {answerForId}) {
    var session = _sessions[sessionId];
    if (session == null) {
      return;
    }
    _createAnswer(session, answerForId: answerForId);
  }

  void reject(String sessionId) {
    var session = _sessions[sessionId];
    if (session == null) {
      return;
    }
    bye(session.sid);
  }

  //TODO: handle sent event to server
  Future<void> handleSignalingCommand(SignalingCommand command, String text,
      {sessionId, to, offerOfId, answerOfId, iceOfId}) async {
    var value = _getSeparatedMessage(text);
    print("received signaling: $command $value");
    switch (command) {
      case SignalingCommand.OFFER:
        {
          await handleOffer(value, sessionId, to: to, offerOfId: offerOfId);
        }
        break;
      case SignalingCommand.ANSWER:
        {
          handleAnswer(value, sessionId, answerOfId: answerOfId);
        }
        break;
      case SignalingCommand.ICE:
        {
          handleIce(value, sessionId, iceOfId);
        }
        break;
      default:
        break;
    }
  }

  Future<void> handleOffer(String value, String sessionId, {to, offerOfId}) async {
    print("[SDP] handle offer: $value");
    try {
      offer = value;
      var session = _sessions[sessionId];
      var newSession = await _createSession(session, sessionId: sessionId, userIds: to);
      _sessions[sessionId] = newSession;
      if (newSession.isConnectSuccess[offerOfId] == null) {
        await newSession.pcs![offerOfId]!
            .setRemoteDescription(RTCSessionDescription(value.mungeCodecs(), Type.OFFER.name));
        if (newSession.pcs?[offerOfId] == null) {
          print('[error handleOffer]: $offerOfId pc null');
        }
        setIceDelay(newSession, offerOfId);
        onCallStateChange?.call(newSession, CallState.CallStateNew);
        onCallStateChange?.call(newSession, CallState.CallStateRinging);
      }
    } catch (e) {
      print('[error handleOffer]: $e');
    }
  }

  void handleAnswer(String sdp, String sessionId, {answerOfId}) {
    print("[SDP] handle answer: $sdp");
    //Note Get Map Data [sessonID sdp]
    try {
      var session = _sessions[sessionId];
      if (session?.isConnectSuccess[answerOfId] == null) {
        session?.pcs?[answerOfId]?.setRemoteDescription(
            RTCSessionDescription(sdp.mungeCodecs(), Type.ANSWER.name.toLowerCase()));
        if (session?.pcs?[answerOfId] == null) {
          print('[error handleAnswer]: $answerOfId pc null');
        }
        setIceDelay(session, answerOfId);
        onCallStateChange?.call(session!, CallState.CallStateConnected);
      }
    } catch (e) {
      print('[error handleAnswer]: $e');
    }
  }

  Future<void> setIceDelay(Session? session, idOfIce) async {
    if (session?.remoteCandidates[idOfIce]?.isNotEmpty == true) {
      print("[setIceDelay]: $idOfIce");
      var candidates = session?.remoteCandidates[idOfIce];
      try {
        candidates?.forEach((candidate) async {
          await session?.pcs?[idOfIce]?.addCandidate(candidate);
        });
      } catch (e) {
        print(e);
        print("[error setIceDelay]: $e");
      }
      session?.remoteCandidates[idOfIce]?.clear();
    }
  }

  Future<void> handleIce(String iceMessage, String sessionId, iceOfId) async {
    try {
      var session = _sessions[sessionId];
      if (session?.isConnectSuccess[iceOfId] == null) {
        var iceArray = iceMessage.split(ICE_SEPARATOR);
        RTCIceCandidate candidate =
            RTCIceCandidate(iceArray[2], iceArray[0], int.parse(iceArray[1]));
        if (session != null) {
          var pc = session.pcs?[iceOfId];
          var des = await pc?.getRemoteDescription();
          if (pc != null && des != null) {
            await session.pcs?[iceOfId]?.addCandidate(candidate);
            print("[handleIce]: $iceOfId");
          } else {
            print("[save handleIce]: $iceOfId pc: ${pc.toString()} des: ${des.toString()}");
            if (session.remoteCandidates[iceOfId] == null) {
              session.remoteCandidates[iceOfId] = <RTCIceCandidate>[];
            }
            session.remoteCandidates[iceOfId]?.add(candidate);
          }
        } else {
          var session = _sessions[sessionId] = Session(sid: sessionId, to: []);
          session.remoteCandidates[iceOfId]?.add(candidate);
        }
      }
    } catch (e) {
      print("error handleIce $e");
    }
  }

  connect() async {
    await Future.delayed(const Duration(seconds: 1));
    onWebRTCSessionState?.call(WebRTCSessionState.Ready);
  }

  Future<MediaStream> createStream() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'mandatory': {
          'minWidth': '640', // Provide your own width, height and frame rate here
          'minHeight': '480',
          'minFrameRate': '30',
        },
        'facingMode': 'user',
        'optional': [],
      }
    };
    MediaStream stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);

    onLocalStream?.call(stream);
    return stream;
  }

  Future<Session> _createSession(
    Session? session, {
    required String sessionId,
    required List<String> userIds,
  }) async {
    var newSession = session ?? Session(sid: sessionId, to: userIds);
    var pcs = <String, RTCPeerConnection>{};
    _localStream = await createStream();
    for (var userId in userIds) {
      if (userId != _selfId) {
        List<MediaStream> _remoteStreams = <MediaStream>[];
        print(_iceServers);
        RTCPeerConnection pc = await createPeerConnection({
          ..._iceServers,
          ...{'sdpSemantics': sdpSemantics}
        }, _config);

        switch (sdpSemantics) {
          case 'plan-b':
            pc.onAddStream = (MediaStream stream) {
              onAddRemoteStream?.call(newSession, stream, userId);
              _remoteStreams.add(stream);
            };
            await pc.addStream(_localStream!);
            break;
          case 'unified-plan':
            // Unified-Plan
            pc.onTrack = (event) {
              onAddRemoteStream?.call(newSession, event.streams[0], userId);
            };
            _localStream!.getTracks().forEach((track) async {
              _senders.add(await pc.addTrack(track, _localStream!));
            });
            break;
        }

        pc.onIceCandidate = (candidate) async {
          if (candidate == null) {
            print('onIceCandidate: complete!');
            return;
          }
          // This delay is needed to allow enough time to try an ICE candidate
          // before skipping to the next one. 1 second is just an heuristic value
          // and should be thoroughly tested in your own environment.

          await Future.delayed(
              const Duration(seconds: 1),
              () => _send(
                  SignalingCommand.ICE.name.toLowerCase(),
                  "${candidate.sdpMid}$ICE_SEPARATOR${candidate.sdpMLineIndex}$ICE_SEPARATOR${candidate.candidate}",
                  userId,
                  _selfId,
                  sessionId));
        };

        pc.onIceConnectionState = (state) {
          print('[pc ice connect state] ${state.name}');
        };
        pc.onConnectionState = (state) {
          onConnectionState?.call(userId, state);
          print('[pc connect state] ${state.name.toString()}');
          if (state == RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
            newSession.isConnectSuccess[userId] = true;
          } else if (state == RTCPeerConnectionState.RTCPeerConnectionStateFailed) {
            print('[reconnect]: ${userId.toString()}');
            inviteOtherUser([userId], sessionId);
          }
        };

        pc.onRemoveStream = (stream) {
          onRemoveRemoteStream?.call(newSession, stream, userId);
          _remoteStreams.removeWhere((it) {
            return (it.id == stream.id);
          });
        };
        pcs[userId] = pc;
        newSession.remoteCandidates[userId] = [];
      }
    }
    newSession.pcs = pcs;
    return newSession;
  }

  Future<void> _createOffer(Session session, List<String> to, String from) async {
    for (var userId in to) {
      if (userId != from) {
        try {
          var pc = session.pcs?[userId];
          if (pc != null && session.isConnectSuccess[userId] == null) {
            RTCSessionDescription s = await pc.createOffer({});
            await pc.setLocalDescription(_fixSdp(s));
            _send(SignalingCommand.OFFER.name, s.sdp, userId, from, session.sid);
          } else {
            throw NullThrownError();
          }
        } catch (e) {
          print(e.toString());
        }
      }
    }
  }

  RTCSessionDescription _fixSdp(RTCSessionDescription s) {
    var sdp = s.sdp;
    s.sdp = sdp!.replaceAll('profile-level-id=640c1f', 'profile-level-id=42e032');
    return s;
  }

  Future<void> _createAnswer(Session session, {answerForId}) async {
    try {
      if (session.isConnectSuccess[answerForId] == null) {
        var pc = session.pcs?[answerForId];
        if (pc != null) {
          RTCSessionDescription s = await pc.createAnswer({});
          await pc.setLocalDescription(_fixSdp(s));
          _send(SignalingCommand.ANSWER.name, s.sdp, answerForId, '', session.sid);
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  _send(event, data, to, from, sessionId) {
    print("[sendCommand] -->${"$event $data"}");
    if ([SignalingCommand.OFFER.name, SignalingCommand.ANSWER.name, SignalingCommand.ICE.name]
        .contains(event.toUpperCase())) {
      sendData?.call(sessionId, to, "$event $data");
    }
  }

  Future<void> _cleanSessions() async {
    if (_localStream != null) {
      _localStream!.getTracks().forEach((element) async {
        await element.stop();
      });
      await _localStream!.dispose();
      _localStream = null;
    }
    _sessions.forEach((key, sess) async {
      sess.pcs?.forEach((key, pc) async {
        await pc.close();
      });
    });
    _sessions.clear();
  }

  Future<void> _closeSession(Session session) async {
    _localStream?.getTracks().forEach((element) async {
      await element.stop();
    });
    await _localStream?.dispose();
    _localStream = null;

    session.pcs?.forEach((key, pc) async {
      await pc.close();
    });
    _senders.clear();
    _videoSource = VideoSource.Camera;
  }

  String _getSeparatedMessage(String text) {
    return text.split(' ').skip(1).join(' ');
  }
}
