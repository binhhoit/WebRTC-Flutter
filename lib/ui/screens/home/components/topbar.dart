import 'package:flutter/material.dart';
import 'package:webrtc_flutter/resources/fonts.gen.dart';

PreferredSizeWidget topBar() {
  return AppBar(
    title: Row(
      children: const [
        Expanded(
          child: Text(
            'Contact',
            style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontFamily: FontFamily.sansSerif,
                fontWeight: FontWeight.w300),
          ),
        ),
        SizedBox(width: 40.0),
// Add some space between the title and other widgets in the app bar
      ],
    ),
    actions: const [
      Padding(
        padding: EdgeInsets.all(10.0),
        child: Icon(Icons.group_add),
      )
    ],
    backgroundColor: Colors.white,
    shadowColor: Colors.white,
    iconTheme: const IconThemeData(color: Colors.black),
  );
}
