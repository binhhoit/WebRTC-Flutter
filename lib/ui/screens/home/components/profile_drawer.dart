import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:webrtc_flutter/domain/entities/user/user.dart' as userCustom;
import 'package:webrtc_flutter/ui/screens/login/login_screen.dart';

import '../../../../resources/fonts.gen.dart';

Widget profileDrawer(BuildContext context, userCustom.User user) {
  return Drawer(
    child: ListView(
      children: [
        DrawerHeader(
          child: CircleAvatar(
              backgroundImage: NetworkImage(
            user.avatar,
          )),
        ),
        ListTile(
          title: Text(user.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  fontFamily: FontFamily.sansSerif,
                  fontWeight: FontWeight.w300)),
          onTap: () {},
        ),
        ListTile(
          title: const Text("Logout",
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: FontFamily.sansSerif,
                  fontWeight: FontWeight.w300)),
          trailing: IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute<void>(builder: (_) => LoginScreen()), (route) => false);
            },
            icon: const Icon(Icons.logout),
          ),
        )
      ],
    ),
  );
}
