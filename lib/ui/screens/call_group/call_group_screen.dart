import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webrtc_flutter/injection.dart';
import 'package:webrtc_flutter/ui/screens/call_group/bloc/call_group_bloc.dart';
import 'package:webrtc_flutter/ui/screens/call_group/components/call_group_body.dart';

class CallGroupScreen extends StatefulWidget {
  static String tag = 'call_group';
  final to;
  final bool isRequestCall;
  final String? session;
  final String? offer;
  final String? roomId;

  const CallGroupScreen(
      {super.key,
      required this.to,
      required this.session,
      required this.offer,
      required this.isRequestCall,
      this.roomId});

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
      create: (context) => injector.get(),
      child: BodyCallBody(
          to: widget.to,
          session: widget.session,
          offer: widget.offer,
          isRequestCall: widget.isRequestCall,
          roomId: widget.roomId),
    );
  }
}
