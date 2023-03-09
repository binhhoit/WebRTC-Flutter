import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:webrtc_flutter/domain/entities/user/user.dart';
import 'package:webrtc_flutter/ui/screens/call_sample/Constants.dart';

import '../../widgets/screen_select_dialog.dart';
import 'signaling.dart';

class CallScreen extends StatefulWidget {
  static String tag = 'call_sample';
  final String host;
  final List<User> to;
  final bool isRequestCall;

  CallScreen({required this.host, required this.to, required this.isRequestCall});

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> with SingleTickerProviderStateMixin {
  Signaling? _signaling;
  List<dynamic> _peers = [];
  String? _selfId;
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool _inCalling = false;
  Session? _session;
  DesktopCapturerSource? selected_source_;
  bool _waitAccept = false;
  var _enabledCall = false;
  late AnimationController _animationController;

  // ignore: unused_element
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
  }

  void _connect(BuildContext context) async {
    _signaling ??= Signaling(widget.host, context)..connect();
    _signaling?.onSignalingStateChange = (SignalingState state) {
      switch (state) {
        case SignalingState.ConnectionClosed:
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

    _signaling?.onWebRTCSessionState = (WebRTCSessionState state) {
      setState(() {
        switch (state) {
          case WebRTCSessionState.Active:
            print(state);
            _enabledCall = false;
            break;
          case WebRTCSessionState.Ready:
            print(state);
            _enabledCall = true;
            break;
          case WebRTCSessionState.Creating:
            print(state);
            _enabledCall = true;
            break;
          case WebRTCSessionState.Impossible:
            print(state);
            _enabledCall = false;
            break;
          case WebRTCSessionState.Offline:
            print(state);
            _enabledCall = false;
            break;
        }
      });
    };

    _signaling?.onCallStateChange = (Session session, CallState state) async {
      switch (state) {
        case CallState.CallStateNew:
          setState(() {
            _session = session;
          });
          break;
        case CallState.CallStateRinging:
          bool? accept = await _showAcceptDialog();
          if (accept!) {
            _accept();
            setState(() {
              _inCalling = true;
            });
          } else {
            _reject();
          }
          break;
        case CallState.CallStateBye:
          if (_waitAccept) {
            print('peer reject');
            _waitAccept = false;
            Navigator.of(context).pop(false);
          }
          setState(() {
            _localRenderer.srcObject = null;
            _remoteRenderer.srcObject = null;
            _inCalling = false;
            _session = null;
          });
          break;
        case CallState.CallStateInvite:
          _waitAccept = true;
          _showInvateDialog();
          break;
        case CallState.CallStateConnected:
          if (_waitAccept) {
            _waitAccept = false;
            Navigator.of(context).pop(false);
          }
          setState(() {
            _inCalling = true;
          });

          break;
        case CallState.CallStateRinging:
      }
    };

    _signaling?.onPeersUpdate = ((event) {
      setState(() {
        _selfId = event['self'];
        _peers = event['peers'];
      });
    });

    _signaling?.onLocalStream = ((stream) {
      _localRenderer.srcObject = stream;
      setState(() {});
    });

    _signaling?.onAddRemoteStream = ((_, stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });

    _signaling?.onRemoveRemoteStream = ((_, stream) {
      _remoteRenderer.srcObject = null;
    });
  }

  Future<bool?> _showAcceptDialog() {
    return showDialog<bool?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("title"),
          content: Text("accept?"),
          actions: <Widget>[
            MaterialButton(
              child: Text(
                'Reject',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            MaterialButton(
              child: Text(
                'Accept',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showInvateDialog() {
    return showDialog<bool?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("title"),
          content: Text("waiting"),
          actions: <Widget>[
            TextButton(
              child: Text("cancel"),
              onPressed: () {
                Navigator.of(context).pop(false);
                _hangUp();
              },
            ),
          ],
        );
      },
    );
  }

  _invitePeer(BuildContext context, bool useScreen) async {
    if (_signaling != null) {
      _signaling?.invite('video', useScreen, [], "");
    }
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

  _buildRow(context, peer) {
    var self = (peer['id'] == _selfId);
    return ListBody(children: <Widget>[
      ListTile(
        title: Text(self
            ? peer['name'] + ', ID: ${peer['id']} ' + ' [Your self]'
            : peer['name'] + ', ID: ${peer['id']} '),
        onTap: null,
        trailing: SizedBox(
            width: 100.0,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
              IconButton(
                icon: Icon(self ? Icons.close : Icons.videocam,
                    color: self ? Colors.grey : Colors.black),
                onPressed: () => _invitePeer(context, false),
                tooltip: 'Video calling',
              ),
              IconButton(
                icon: Icon(self ? Icons.close : Icons.screen_share,
                    color: self ? Colors.grey : Colors.black),
                onPressed: () => _invitePeer(context, true),
                tooltip: 'Screen sharing',
              )
            ])),
        subtitle: Text('[' + peer['user_agent'] + ']'),
      ),
      Divider()
    ]);
  }

  _waitingCall() {
    var callUser = widget.to.first;

    return Expanded(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/bg_call.png",
              gaplessPlayback: true,
              alignment: Alignment.center,
              scale: 1.2,
            ),
          ),
          Column(
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
                  Navigator.pop(context);
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
        ],
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
                    child: const Icon(Icons.switch_camera),
                    tooltip: 'Camera',
                    onPressed: _switchCamera,
                  ),
                  FloatingActionButton(
                    child: const Icon(Icons.desktop_mac),
                    tooltip: 'Screen Sharing',
                    onPressed: () => selectScreenSourceDialog(context),
                  ),
                  FloatingActionButton(
                    onPressed: _hangUp,
                    tooltip: 'Hangup',
                    child: Icon(Icons.call_end),
                    backgroundColor: Colors.pink,
                  ),
                  FloatingActionButton(
                    child: const Icon(Icons.mic_off),
                    tooltip: 'Mute Mic',
                    onPressed: _muteMic,
                  )
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
                children: [
                  if (widget.isRequestCall) _waitingCall(),
                ],
              ));
  }
}
