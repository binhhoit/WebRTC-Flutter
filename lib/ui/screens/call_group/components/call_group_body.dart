import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webrtc_flutter/platform/local/preferences/preference_manager.dart';
import 'package:webrtc_flutter/ui/screens/call_group/bloc/call_group_bloc.dart';
import 'package:webrtc_flutter/ui/screens/call_group/bloc/call_group_state.dart';
import 'package:webrtc_flutter/ui/screens/call_sample/Constants.dart';
import 'package:webrtc_flutter/ui/screens/call_sample/signaling.dart';
import 'package:webrtc_flutter/utils/screen_select_dialog.dart';

class BodyCallBody extends StatefulWidget {
  static String tag = 'call_group';
  final String host;
  final to;
  final bool isRequestCall;
  final String? session;
  final String? offer;
  final String? roomId;

  const BodyCallBody(
      {super.key,
      required this.host,
      required this.to,
      required this.session,
      required this.offer,
      required this.isRequestCall,
      this.roomId});

  @override
  _BodyCallBody createState() => _BodyCallBody();
}

class _BodyCallBody extends State<BodyCallBody> with SingleTickerProviderStateMixin {
  Signaling? _signaling;
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final Map<String, RTCVideoRenderer> _remoteRenderers = {};
  final Map<String, RTCPeerConnectionState> _statePeerConnect = {};
  bool _inCalling = false;
  Session? _session;
  DesktopCapturerSource? selected_source_;
  late AnimationController _animationController;
  late CallGroupBloc _bloc;

  Timer? _timer;
  int _seconds = 0;
  late List<dynamic> userIds = widget.to.map((user) => user.id).toList();

  _BodyCallBody();

  @override
  initState() {
    super.initState();
    _bloc = context.read<CallGroupBloc>();
    if (widget.roomId != null) {
      _bloc.getRooms(widget.roomId!);
    }
    if (widget.to.isNotEmpty) {
      _createRemoteRenderers();
    }
    initRenderers();
    _connect(context);
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat(reverse: true);
  }

  _createRemoteRenderers() {
    for (var id in userIds) {
      _remoteRenderers[id] = RTCVideoRenderer();
      _statePeerConnect[id] = RTCPeerConnectionState.RTCPeerConnectionStateNew;
    }
  }

  initRenderers() async {
    await _localRenderer.initialize();
    _remoteRenderers.forEach((key, value) async {
      await value.initialize();
    });
  }

  @override
  deactivate() {
    super.deactivate();
    _signaling?.close();
    _animationController.dispose();
    _localRenderer.dispose();
    _remoteRenderers.forEach((key, value) async {
      await value.dispose();
    });
    _timer?.cancel();
  }

  void _connect(BuildContext context) async {
    _signaling ??= Signaling(widget.host, context)..connect();
    _bloc.setSignaling(_signaling!);
    _signaling?.onSignalingStateChange = (SignalingState state) {
      switch (state) {
        case SignalingState.ConnectionClosed:
          if (mounted) {
            // Navigator.pop(context);
          }
          print(state);
          break;
        case SignalingState.ConnectionError:
          print(state);
          break;
        case SignalingState.ConnectionOpen:
          print(state);
          break;
      }
    };

    _signaling?.onWebRTCSessionState = (WebRTCSessionState state) async {
      switch (state) {
        case WebRTCSessionState.Active:
          print(state);
          setState(() {
            _inCalling = true;
          });
          _startTimer();
          break;
        case WebRTCSessionState.Ready:
          print(state);
          //auto sent offer
          if (widget.isRequestCall) {
            List<String> ids =
                (widget.to as List<dynamic>).map((e) => e.id).cast<String>().toList();
            var userCall = PreferenceManager.instance.currentUser;
            _signaling?.onSessionScreenReady(ids,
                nameCaller: userCall.name, avatar: userCall.avatar);
          } else {
            /* await _signaling?.handleSignalingCommand(SignalingCommand.OFFER, widget.offer ?? '',
                sessionId: widget.session);
            _accept();*/
          }
          break;
        case WebRTCSessionState.Creating:
          print(state);
          /*if (!widget.isRequestCall) {
            await _signaling?.handleSignalingCommand(SignalingCommand.OFFER, widget.offer ?? '',
                sessionId: widget.session);
            _accept();
          }*/
          break;
        case WebRTCSessionState.Impossible:
          print(state);
          break;
        case WebRTCSessionState.Offline:
          print(state);
          break;
        case WebRTCSessionState.Close:
          // TODO: Handle this case.
          break;
      }
    };

    _signaling?.onCallStateChange = (Session session, CallState state) async {
      switch (state) {
        case CallState.CallStateNew:
          setState(() {
            _session = session;
          });
          break;
        case CallState.CallStateRinging:
          _showAcceptDialog();
          setState(() {
            _inCalling = true;
          });
          break;
        case CallState.CallStateBye:
          setState(() {
            _localRenderer.srcObject = null;
            _remoteRenderers.forEach((key, value) async {
              value.srcObject = null;
            });
            _inCalling = false;
            _session = null;
          });
          Navigator.pop(context);
          break;
        case CallState.CallStateInvite:
          var ids = widget.to.map((e) => e.id).cast<String>().toList();
          await _bloc.createRoom(session.sid, ids);
          _showInviteDialog();
          break;
        case CallState.CallStateConnected:
          if (!_inCalling) {
            setState(() {
              _inCalling = true;
            });
          }

          break;
        case CallState.CallStateRinging:
      }
    };

    _signaling?.sendData = (sessionId, to, data) async {
      await _bloc.sentData(sessionId, to, data);
    };

    _signaling?.onLocalStream = ((stream) {
      _localRenderer.srcObject = stream;
      setState(() {});
    });

    _signaling?.onAddRemoteStream = ((_, stream, userId) {
      print('[Stream Data]:' + '${userId.toString()} - ' + stream.id.toString());
      if (mounted) {
        setState(() {
          _remoteRenderers[userId]?.srcObject = stream;
        });
      }
    });

    _signaling?.onRemoveRemoteStream = ((_, stream, userId) {
      _remoteRenderers[userId]?.srcObject = null;
    });

    _signaling?.onConnectionState = (userId, state) {
      if (mounted) {
        setState(() {
          _statePeerConnect[userId] = state;
        });
      }
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateFailed) {
        //_bloc.deleteOfferOrAnswerFailed(userId);
      }
    };
  }

  _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  _showAcceptDialog() {
    Fluttertoast.showToast(
        msg: 'Accept Dialog', backgroundColor: Colors.green, textColor: Colors.white, fontSize: 16);
  }

  _showInviteDialog() {
    Fluttertoast.showToast(
        msg: 'Waiting Connect',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16);
  }

  _accept() {
    if (_session != null) {
      _signaling?.accept(_session!.sid);
    }
  }

  _reject() {
    if (_session != null) {
      _signaling?.reject(_session!.sid);
    }
  }

  _hangUp() {
    if (_session != null) {
      _signaling?.bye(_session!.sid, [], '');
    }
    _bloc.deleteRoom(_session!.sid);
  }

  _switchCamera() {
    _signaling?.switchCamera();
  }

  Future<void> selectScreenSourceDialog(BuildContext context) async {
    MediaStream? screenStream;
    if (WebRTC.platformIsDesktop) {
      final source = await showDialog<DesktopCapturerSource>(
        context: context,
        builder: (context) => ScreenSelectDialog(),
      );
      if (source != null) {
        try {
          var stream = await navigator.mediaDevices.getDisplayMedia(<String, dynamic>{
            'video': {
              'deviceId': {'exact': source.id},
              'mandatory': {'frameRate': 30.0}
            }
          });
          stream.getVideoTracks()[0].onEnded = () {
            print('By adding a listener on onEnded you can: 1) catch stop video sharing on Web');
          };
          screenStream = stream;
        } catch (e) {
          print(e);
        }
      }
    } else if (WebRTC.platformIsWeb) {
      screenStream = await navigator.mediaDevices.getDisplayMedia(<String, dynamic>{
        'audio': false,
        'video': true,
      });
    }
    if (screenStream != null) _signaling?.switchToScreenSharing(screenStream);
  }

  _muteMic() {
    _signaling?.muteMic();
  }

  _waitingCall() {
    var callUser = widget.to;
    var name = "";
    var avatarWidget = <Widget>[];

    for (var element in callUser) {
      name = "$name - ${element.name}";
      avatarWidget.add(SizedBox(
        height: 50,
        width: 50,
        child: CircleAvatar(
            backgroundImage: NetworkImage(
          element.avatar,
        )),
      ));
    }

    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_call.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 150),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: avatarWidget),
            const SizedBox(height: 30),
            Column(
              children: [
                Text(
                  name.toUpperCase(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
                ),
                const SizedBox(height: 10),
                FadeTransition(
                  opacity: _animationController,
                  child: const Text("CALLING",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300, fontSize: 20)),
                )
              ],
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                _hangUp();
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  'assets/images/end_call.png',
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  List<Widget> _videoRenderCall(BuildContext context, width, height) {
    List<Widget> viewRender = [
      Container(
        child: Text('empty'),
      )
    ];
    for (var user in widget.to) {
      if (user.id != PreferenceManager.instance.currentUser.id) {
        var container = Container(
          margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          width: width,
          height: height,
          decoration: const BoxDecoration(color: Colors.black54),
          child: Stack(
            children: [
              RTCVideoView(_remoteRenderers[user.id]!),
              Text(
                "${user.name}\n${user.id}\n state:${_statePeerConnect[user.id]}",
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
        viewRender.add(container);
      }
    }

    return viewRender;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CallGroupBloc, CallGroupState>(builder: (context, state) {
      var width = MediaQuery.of(context).size.width / 2;
      var height = MediaQuery.of(context).size.height;
      return Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: _inCalling
              ? SizedBox(
                  width: 240.0,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                    FloatingActionButton(
                      tooltip: 'Camera',
                      onPressed: null,
                      backgroundColor: Colors.transparent,
                      child: Text(
                        _formatDuration(Duration(seconds: _seconds)),
                        style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                      ),
                    ),
                    FloatingActionButton(
                      child: const Icon(Icons.switch_camera),
                      tooltip: 'Camera',
                      onPressed: _switchCamera,
                    ),
                    FloatingActionButton(
                      tooltip: 'Mute Mic',
                      onPressed: _muteMic,
                      child: const Icon(Icons.mic_off),
                    ),
                    FloatingActionButton(
                      onPressed: _hangUp,
                      tooltip: 'Hangup',
                      child: Icon(Icons.call_end),
                      backgroundColor: Colors.pink,
                    ),
                  ]))
              : null,
          body: _inCalling
              ? OrientationBuilder(builder: (context, orientation) {
                  return Stack(children: <Widget>[
                    GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 2 / 3,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                        children: _videoRenderCall(context, width, height)),
                    Positioned(
                      left: 20.0,
                      top: 20.0,
                      child: Container(
                        width: orientation == Orientation.portrait ? 90.0 : 120.0,
                        height: orientation == Orientation.portrait ? 120.0 : 90.0,
                        child: RTCVideoView(_localRenderer, mirror: true),
                        decoration: BoxDecoration(color: Colors.black54),
                      ),
                    ),
                  ]);
                })
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.isRequestCall) _waitingCall(),
                    if (!widget.isRequestCall)
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                  ],
                ));
    }, listener: (context, state) {
      if (state is CallGroupRoom) {
        userIds = state.room.idUsers;
      } else if (state is InviteOtherConnect) {
        Fluttertoast.showToast(msg: '[invite more]: ${state.userIds.length.toString()}');
      } else if (state is CloseRoom) {
        //Remove later
        _hangUp();
        Navigator.pop(context);
      }
    });
  }
}
