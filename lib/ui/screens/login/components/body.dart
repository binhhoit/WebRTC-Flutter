import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webrtc_flutter/ui/screens/login/bloc/login_bloc.dart';
import 'package:webrtc_flutter/ui/screens/login/bloc/login_event.dart';
import 'package:webrtc_flutter/ui/screens/login/bloc/login_state.dart';

class LoginBody extends StatelessWidget {
  LoginBody({Key? key}) : super(key: key);

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (_, state) => isLoading.value = state is LoginLoading,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  BlocProvider.of<LoginBloc>(context)
                      .add(const LoginEvent.requestLogin("", ""));
                },
                child: const Text("Login", style: TextStyle(fontSize: 20)),
              ),
              ValueListenableBuilder<bool>(
                  valueListenable: isLoading,
                  builder: (context, bool value, _) {
                    return Visibility(
                      visible: value,
                      child: const CircularProgressIndicator(
                        color: Colors.green,
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
