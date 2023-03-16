import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webrtc_flutter/domain/entities/user/user.dart';
import 'package:webrtc_flutter/injection.dart';
import 'package:webrtc_flutter/ui/screens/call_group/bloc/call_group_bloc.dart';
import 'package:webrtc_flutter/ui/screens/call_group/components/call_group_body.dart';

class CallGroupScreen extends StatefulWidget {
  static String tag = 'call_group';
  final String host;
  final List<User> to;
  final bool isRequestCall;
  final String? session;
  final String? offer;

  const CallGroupScreen(
      {required this.host,
      required this.to,
      required this.session,
      required this.offer,
      required this.isRequestCall});

  @override
  _CallGroupScreenState createState() => _CallGroupScreenState();
}

class _CallGroupScreenState extends State<CallGroupScreen> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CallGroupBloc>(
      create: injector.get(),
      child: BodyCallBody(
          host: widget.host,
          to: widget.to,
          session: widget.session,
          offer: widget.offer,
          isRequestCall: widget.isRequestCall),
    );
  }
}
