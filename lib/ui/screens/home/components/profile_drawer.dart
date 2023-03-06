import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:webrtc_flutter/ui/screens/login/login_screen.dart';

import '../../../../resources/fonts.gen.dart';

Widget profileDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      children: [
        const DrawerHeader(
          child: CircleAvatar(
              backgroundImage: NetworkImage(
            "https://hoala.vn/upload/img/images/hoa_thanh_luong_11.jpg",
          )),
        ),
        ListTile(
          title: const Text("Alex xander",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: FontFamily.sansSerif,
                  fontWeight: FontWeight.w300)),
          onTap: () {},
        ),
        ListTile(
          title: const Text("Logout",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 1,
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
