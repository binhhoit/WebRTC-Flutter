import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../utils/device_info.dart' if (dart.library.js) '../utils/device_info_web.dart';
import '../../../utils/screen_select_dialog.dart';
import '../../../utils/websocket.dart' if (dart.library.js) '../utils/websocket_web.dart';
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
  Session({required this.sid, required this.pid, required this.to});
  String pid;
  String sid;
  List<String>? to;
  Map<String, RTCPeerConnection>? pcs;
  Map<String, List<RTCIceCandidate>> remoteCandidates = {};
}

class Signaling {
  Signaling(this._host, this._context);

  final JsonEncoder _encoder = JsonEncoder();
  final JsonDecoder _decoder = JsonDecoder();
  final String _selfId = FirebaseAuth.instance.currentUser?.uid ?? randomNumeric(6);
  SimpleWebSocket? _socket;
  BuildContext? _context;
  var _host;
  Map<String, Session> _sessions = {};
  MediaStream? _localStream;

  List<RTCRtpSender> _senders = <RTCRtpSender>[];
  VideoSource _videoSource = VideoSource.Camera;

  Function(SignalingState state)? onSignalingStateChange;
  Function(WebRTCSessionState state)? onWebRTCSessionState;
  Function(Session session, CallState state)? onCallStateChange;
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
    _socket?.close();
  }

  void switchCamera() {
    if (_localStream != null) {
      if (_videoSource != VideoSource.Camera) {
        _senders.forEach((sender) {
          if (sender.track!.kind == 'video') {
            sender.replaceTrack(_localStream!.getVideoTracks()[0]);
          }
        });
        _videoSource = VideoSource.Camera;
        onLocalStream?.call(_localStream!);
      } else {
        Helper.switchCamera(_localStream!.getVideoTracks()[0]);
      }
    }
  }

  void switchToScreenSharing(MediaStream stream) {
    if (_localStream != null && _videoSource != VideoSource.Screen) {
      _senders.forEach((sender) {
        if (sender.track!.kind == 'video') {
          sender.replaceTrack(stream.getVideoTracks()[0]);
        }
      });
      onLocalStream?.call(stream);
      _videoSource = VideoSource.Screen;
    }
  }

  void muteMic() {
    if (_localStream != null) {
      bool enabled = _localStream!.getAudioTracks()[0].enabled;
      _localStream!.getAudioTracks()[0].enabled = !enabled;
    }
  }

  void invite(
      String media, bool useScreen, List<String> to, String from, nameCaller, avatar) async {
    var peerId = randomNumeric(12);
    var sessionId = /*'$_selfId-$peerId';*/ 'dQw6jgPNeshh8AEKsOr9yPpTOpp1-426658330133';
    Session session = await _createSession(null,
        peerId: peerId, sessionId: sessionId, media: media, screenSharing: useScreen, userIds: to);
    _sessions[sessionId] = session;
    _createOffer(session, media, to, from, nameCaller, avatar);
    onCallStateChange?.call(session, CallState.CallStateNew);
    onCallStateChange?.call(session, CallState.CallStateInvite);
  }

  void bye(String sessionId, List<String> to, String from) {
    _send(
        'bye',
        {
          'session_id': sessionId,
          'from': _selfId,
        },
        to,
        from,
        sessionId);
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
    _createAnswer(session, 'video', answerForId: answerForId);
  }

  void reject(String sessionId) {
    var session = _sessions[sessionId];
    if (session == null) {
      return;
    }
    bye(session.sid, [], '');
  }

  //TODO: handle state connect server
  Future<void> handleStateMessage(rawData, {sessionId}) async {
    var data = rawData['data'];
    var state = _getSeparatedMessage(data);
    if (state == WebRTCSessionState.Active.name) {
      onWebRTCSessionState?.call(WebRTCSessionState.Active);
    } else if (state == WebRTCSessionState.Creating.name) {
      onWebRTCSessionState?.call(WebRTCSessionState.Creating);
    } else if (state == WebRTCSessionState.Ready.name) {
      onWebRTCSessionState?.call(WebRTCSessionState.Ready);
    } else if (state == WebRTCSessionState.Impossible.name) {
      onWebRTCSessionState?.call(WebRTCSessionState.Impossible);
    } else if (state == WebRTCSessionState.Offline.name) {
      onWebRTCSessionState?.call(WebRTCSessionState.Offline);
    } else if (state == WebRTCSessionState.Close.name) {
      _handelBye(sessionId);
      onWebRTCSessionState?.call(WebRTCSessionState.Close);
    }
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

  void onMessage(message) async {
    var status = message['data'];
    var sessionId = message['sessionId'];
    if (status.toLowerCase().startsWith(SignalingCommand.STATE.name.toLowerCase())) {
      handleStateMessage(message, sessionId: sessionId);
    } else if (status.toLowerCase().startsWith(SignalingCommand.OFFER.name.toLowerCase())) {
      handleSignalingCommand(SignalingCommand.OFFER, status);
    } else if (status.toLowerCase().startsWith(SignalingCommand.ANSWER.name.toLowerCase())) {
      handleSignalingCommand(SignalingCommand.ANSWER, status, sessionId: sessionId);
    } else if (status.toLowerCase().startsWith(SignalingCommand.ICE.name.toLowerCase())) {
      handleSignalingCommand(SignalingCommand.ICE, status, sessionId: sessionId);
    }
  }

  Future<void> handleOffer(String value, String sessionId, {to, offerOfId}) async {
    print("[SDP] handle offer: $value");
    offer = value;
    var session = _sessions[sessionId];
    var newSession = await _createSession(session,
        peerId: randomNumeric(12),
        sessionId: sessionId,
        media: 'video',
        screenSharing: false,
        userIds: to);
    _sessions[sessionId] = newSession;
    await newSession.pcs?[offerOfId]
        ?.setRemoteDescription(RTCSessionDescription(value.mungeCodecs(), Type.OFFER.name));

    if (newSession.remoteCandidates.isNotEmpty) {
      var candidates = newSession.remoteCandidates[offerOfId];
      candidates?.forEach((candidate) async {
        await newSession.pcs?[offerOfId]?.addCandidate(candidate);
      });
      newSession.remoteCandidates.clear();
    }
    onCallStateChange?.call(newSession, CallState.CallStateNew);
    onCallStateChange?.call(newSession, CallState.CallStateRinging);
  }

  void handleAnswer(String sdp, String sessionId, {answerOfId}) {
    print("[SDP] handle answer: $sdp");
    //Note Get Map Data [sessonID sdp]
    var session = _sessions[sessionId];
    session?.pcs?[answerOfId]?.setRemoteDescription(
        RTCSessionDescription(sdp.mungeCodecs(), Type.ANSWER.name.toLowerCase()));
    onCallStateChange?.call(session!, CallState.CallStateConnected);
  }

  Future<void> handleIce(String iceMessage, String sessionId, iceOfId) async {
    try {
      var session = _sessions[sessionId];
      var iceArray = iceMessage.split(ICE_SEPARATOR);
      RTCIceCandidate candidate = RTCIceCandidate(iceArray[2], iceArray[0], int.parse(iceArray[1]));
      if (session != null) {
        if (session.pcs?[iceOfId] != null) {
          await session.pcs?[iceOfId]?.addCandidate(candidate);
        } else {
          (session.remoteCandidates[iceOfId] as List<RTCIceCandidate>).add(candidate);
        }
      } else {
        var session = _sessions[sessionId] = Session(pid: _selfId, sid: sessionId, to: []);
        (session.remoteCandidates[iceOfId] as List<RTCIceCandidate>).add(candidate);
      }
    } catch (e) {
      print("error handleIce $e");
    }
  }

  _handelBye(sessionId) {
    print('bye: ' + sessionId);
    var session = _sessions.remove(sessionId);
    if (session != null) {
      onCallStateChange?.call(session, CallState.CallStateBye);
      _closeSession(session);
    }
  }

  Future<void> connect() async {
    var url = '$_host/rtc?uid=$_selfId';
    _socket = SimpleWebSocket(url);

    print('connect to $url');

    /*if (_turnCredential == null) {
      try {
        _turnCredential = await getTurnCredential(_host, _port);
        */ /*{
            "username": "1584195784:mbzrxpgjys",
            "password": "isyl6FF6nqMTB9/ig5MrMRUXqZg",
            "ttl": 86400,
            "uris": ["turn:127.0.0.1:19302?transport=udp"]
          }
        */ /*
        _iceServers = {
          'iceServers': [
            {
              'urls': _turnCredential['uris'][0],
              'username': _turnCredential['username'],
              'credential': _turnCredential['password']
            },
          ]
        };
      } catch (e) {}
    }
*/
    _socket?.onOpen = () {
      print('onOpen');
      onSignalingStateChange?.call(SignalingState.ConnectionOpen);
      _send('new', {'name': DeviceInfo.label, 'id': _selfId, 'user_agent': DeviceInfo.userAgent},
          null, null, null);
    };

    _socket?.onMessage = (message) {
      print('Received data: ' + message);
      onMessage(_decoder.convert(message));
    };

    _socket?.onClose = (int? code, String? reason) {
      print('Closed by server [$code => $reason]!');
      onSignalingStateChange?.call(SignalingState.ConnectionClosed);
    };

    await _socket?.connect();
  }

  Future<MediaStream> createStream(String media, bool userScreen, {BuildContext? context}) async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': userScreen ? false : true,
      'video': userScreen
          ? true
          : {
              'mandatory': {
                'minWidth': '640', // Provide your own width, height and frame rate here
                'minHeight': '480',
                'minFrameRate': '30',
              },
              'facingMode': 'user',
              'optional': [],
            }
    };
    late MediaStream stream;
    if (userScreen) {
      if (WebRTC.platformIsDesktop) {
        final source = await showDialog<DesktopCapturerSource>(
          context: context!,
          builder: (context) => ScreenSelectDialog(),
        );
        stream = await navigator.mediaDevices.getDisplayMedia(<String, dynamic>{
          'video': source == null
              ? true
              : {
                  'deviceId': {'exact': source.id},
                  'mandatory': {'frameRate': 30.0}
                }
        });
      } else {
        stream = await navigator.mediaDevices.getDisplayMedia(mediaConstraints);
      }
    } else {
      stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    }

    onLocalStream?.call(stream);
    return stream;
  }

  Future<Session> _createSession(
    Session? session, {
    required String peerId,
    required String sessionId,
    required String media,
    required bool screenSharing,
    required List<String> userIds,
  }) async {
    var newSession = session ?? Session(sid: sessionId, pid: peerId, to: userIds);
    var pcs = <String, RTCPeerConnection>{};
    if (media != 'data') {
      _localStream = await createStream(media, screenSharing, context: _context);
    }
    for (var userId in userIds) {
      if (userId != _selfId) {
        List<MediaStream> _remoteStreams = <MediaStream>[];
        print(_iceServers);
        RTCPeerConnection pc = await createPeerConnection({
          ..._iceServers,
          ...{'sdpSemantics': sdpSemantics}
        }, _config);
        if (media != 'data') {
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
                if (event.track.kind == 'video') {
                  onAddRemoteStream?.call(newSession, event.streams[0], userId);
                }
              };
              _localStream!.getTracks().forEach((track) async {
                _senders.add(await pc.addTrack(track, _localStream!));
              });
              break;
          }
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
          Fluttertoast.showToast(msg: '[pc connect state] ${state.name.toString()}');
          print('[pc connect state] ${state.name.toString()}');
        };

        pc.onRemoveStream = (stream) {
          onRemoveRemoteStream?.call(newSession, stream, userId);
          _remoteStreams.removeWhere((it) {
            return (it.id == stream.id);
          });
        };
        pcs[userId] = pc;
      }
    }
    newSession.pcs = pcs;
    return newSession;
  }

  Future<void> _createOffer(
      Session session, String media, List<String> to, String from, nameCaller, avatar) async {
    session.pcs?.forEach((userId, pc) async {
      if (userId != from) {
        try {
          RTCSessionDescription s = await pc.createOffer(media == 'data' ? _dcConstraints : {});
          await pc.setLocalDescription(_fixSdp(s));
          _send(SignalingCommand.OFFER.name, s.sdp, userId, from, session.sid,
              nameCaller: nameCaller, avatar: avatar);
        } catch (e) {
          print(e.toString());
        }
      }
    });
  }

  RTCSessionDescription _fixSdp(RTCSessionDescription s) {
    var sdp = s.sdp;
    s.sdp = sdp!.replaceAll('profile-level-id=640c1f', 'profile-level-id=42e032');
    return s;
  }

  Future<void> _createAnswer(Session session, String media, {answerForId}) async {
    try {
      var pc = session.pcs?[answerForId];
      if (pc != null) {
        RTCSessionDescription s = await pc.createAnswer(media == 'data' ? _dcConstraints : {});
        await pc.setLocalDescription(_fixSdp(s));
        _send(SignalingCommand.ANSWER.name, s.sdp, answerForId, '', session.sid);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  _send(event, data, to, from, sessionId, {nameCaller, avatar}) {
    var request = {};
    request["sessionId"] = sessionId;
    request["data"] = "$event $data";
    request["to"] = to;
    request["from"] = from;
    request["nameCaller"] = nameCaller;
    request["avatar"] = avatar;

    print("[sendCommand] -->${_encoder.convert(request)}");
    if ([SignalingCommand.OFFER.name, SignalingCommand.ANSWER.name, SignalingCommand.ICE.name]
        .contains(event.toUpperCase())) {
      sendData?.call(sessionId, to, "$event $data");
    }
    //_socket?.send(_encoder.convert(request));
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

  void _closeSessionByPeerId(String peerId) {
    var session;
    _sessions.removeWhere((String key, Session sess) {
      var ids = key.split('-');
      session = sess;
      return peerId == ids[0] || peerId == ids[1];
    });
    if (session != null) {
      _closeSession(session);
      onCallStateChange?.call(session, CallState.CallStateBye);
    }
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

  Future<void> onSessionScreenReady(List<String> to, {nameCaller, avatar}) async {
    if (offer != null) {
      var peerId = '1';
      var sessionId = _selfId + '-' + peerId;
      accept(sessionId);
      print("--------accept--------");
    } else {
      invite('video', false, to, _selfId, nameCaller, avatar);
      print("--------invite--------");
    }
  }
}
