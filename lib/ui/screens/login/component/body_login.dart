import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webrtc_flutter/ui/screens/home/home_screen.dart';
import 'package:webrtc_flutter/ui/screens/register/register_screen.dart';

import '../../../../translations/locale_keys.g.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_state.dart';

class BodyLogin extends StatefulWidget {
  BodyLogin({Key? key}) : super(key: key);

  @override
  State<BodyLogin> createState() => _BodyLogin();
}

class _BodyLogin extends State<BodyLogin> {
  LoginBloc? _bloc;
  final userName = TextEditingController();
  final password = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _bloc = context.read<LoginBloc>();
    userName.text = "binh1@gmail.com";
    password.text = "123456";
    super.initState();
  }

  @override
  void dispose() {
    userName.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(builder: (context, state) {
      return Stack(
        children: [
          Column(children: [
            const Spacer(
              flex: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: userName,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: LocaleKeys.user_name.tr(),
                  hintText: LocaleKeys.enter_your_name.tr(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: LocaleKeys.password.tr(),
                  hintText: LocaleKeys.enter_pass.tr(),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            if (state is LoginError)
              Text(
                state.message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: MaterialButton(
                color: Colors.white,
                height: 50,
                onPressed: () {
                  _bloc?.loginAction(email: userName.text, pass: password.text);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 16,
                    ),
                    Text(
                      LocaleKeys.sign_in.tr(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(
              flex: 1,
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(builder: (BuildContext context) => RegisterScreen()),
                  );
                },
                child: Text(
                  LocaleKeys.do_you_have_account.tr(),
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                )),
            const Spacer(
              flex: 1,
            ),
          ]),
          if (state is LoginLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      );
    }, listener: (context, state) {
      if (state is LoginInputValidated) {
        Navigator.push(
            context, MaterialPageRoute<void>(builder: (BuildContext context) => HomeScreen()));
      }
    });
  }
}
