import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webrtc_flutter/domain/entities/user/user.dart';
import 'package:webrtc_flutter/platform/local/preferences/preference_manager.dart';
import 'package:webrtc_flutter/ui/screens/call_sample/Constants.dart';

import '../../widgets/screen_select_dialog.dart';
import 'signaling.dart';

class CallScreen extends StatefulWidget {
  static String tag = 'call_sample';
  final String host;
  final List<User> to;
  final bool isRequestCall;
  final String? session;
  final String? offer;

  const CallScreen(
      {required this.host,
      required this.to,
      required this.session,
      required this.offer,
      required this.isRequestCall});

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> with SingleTickerProviderStateMixin {
  Signaling? _signaling;
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool _inCalling = false;
  Session? _session;
  DesktopCapturerSource? selected_source_;
  late AnimationController _animationController;

  Timer? _timer;
  int _seconds = 0;

  _CallScreenState();

  @override
  initState() {
    super.initState();
    initRenderers();
    _connect(context);
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat(reverse: true);
  }

  initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  @override
  deactivate() {
    super.deactivate();
    _signaling?.close();
    _animationController.dispose();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _timer?.cancel();
  }

  void _connect(BuildContext context) async {
    _signaling ??= Signaling(widget.host, context)..connect();
    _signaling?.onSignalingStateChange = (SignalingState state) {
      switch (state) {
        case SignalingState.ConnectionClosed:
          if (mounted) {
            Navigator.pop(context);
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
            var id = widget.to.map((e) => e.id);
            var userCall = PreferenceManager.instance.currentUser;
            _signaling?.onSessionScreenReady(id.toList(),
                nameCaller: userCall.name, avatar: userCall.avatar);
          } else {
            await _signaling?.handleSignalingCommand(SignalingCommand.OFFER, widget.offer ?? '',
                sessionId: widget.session);
            _accept();
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
            _remoteRenderer.srcObject = null;
            _inCalling = false;
            _session = null;
          });
          Navigator.pop(context);
          break;
        case CallState.CallStateInvite:
          _showInviteDialog();
          break;
        case CallState.CallStateConnected:
          setState(() {
            _inCalling = true;
          });

          break;
        case CallState.CallStateRinging:
      }
    };

    _signaling?.onLocalStream = ((stream) {
      _localRenderer.srcObject = stream;
      setState(() {});
    });

    _signaling?.onAddRemoteStream = ((_, stream, __) {
      _remoteRenderer.srcObject = stream;
      if (mounted) setState(() {});
    });

    _signaling?.onRemoveRemoteStream = ((_, stream, __) {
      _remoteRenderer.srcObject = null;
    });
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
    var callUser = widget.to.first;
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
            SizedBox(
              height: 150,
              width: 150,
              child: CircleAvatar(
                  backgroundImage: NetworkImage(
                callUser.avatar,
              )),
            ),
            const SizedBox(height: 30),
            Column(
              children: [
                Text(
                  callUser.name.toUpperCase(),
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

  @override
  Widget build(BuildContext context) {
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
                return Container(
                  child: Stack(children: <Widget>[
                    Positioned(
                        left: 0.0,
                        right: 0.0,
                        top: 0.0,
                        bottom: 0.0,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: RTCVideoView(_remoteRenderer),
                          decoration: BoxDecoration(color: Colors.black54),
                        )),
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
                  ]),
                );
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
  }
}
