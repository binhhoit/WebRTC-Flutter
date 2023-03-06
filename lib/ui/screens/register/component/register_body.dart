import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webrtc_flutter/translations/locale_keys.g.dart';

import '../bloc/register_bloc.dart';
import '../bloc/register_state.dart';

class BodyRegister extends StatefulWidget {
  BodyRegister({Key? key}) : super(key: key);

  @override
  State<BodyRegister> createState() => _BodyRegister();
}

class _BodyRegister extends State<BodyRegister> {
  RegisterBloc? _bloc;
  final userName = TextEditingController();
  final password = TextEditingController();
  final passwordConfirm = TextEditingController();

  @override
  void initState() {
    _bloc = context.read<RegisterBloc>();
    super.initState();
  }

  @override
  void dispose() {
    userName.dispose();
    password.dispose();
    passwordConfirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(builder: (context, state) {
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
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: passwordConfirm,
                obscureText: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: LocaleKeys.password_confirm.tr(),
                  hintText: LocaleKeys.enter_password_confirm.tr(),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            if (state is RegisterError)
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
                  _bloc?.registerAccount(
                      email: userName.text, pass: password.text, passConfirm: passwordConfirm.text);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 16,
                    ),
                    Text(
                      LocaleKeys.sign_up.tr(),
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
                  Navigator.pop(context);
                },
                child: Text(
                  LocaleKeys.sign_in.tr(),
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                )),
            const Spacer(
              flex: 1,
            ),
          ]),
          if (state is RegisterLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      );
    }, listener: (context, state) {
      if (state is RegisterInputValidated) Navigator.pop(context);
    });
  }
}
