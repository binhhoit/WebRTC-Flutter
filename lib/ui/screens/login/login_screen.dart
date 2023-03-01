import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webrtc_flutter/injection.dart';
import 'package:webrtc_flutter/ui/screens/login/bloc/login_bloc.dart';
import 'package:webrtc_flutter/ui/screens/login/components/body.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (_) => injector.get(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: BlocProvider<LoginBloc>(
            create: (context) => injector.get(),
            child: LoginBody(),
          ),
        ),
      ),
    );
  }
}