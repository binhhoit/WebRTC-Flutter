import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webrtc_flutter/domain/entities/user/user.dart';
import 'package:webrtc_flutter/injection.dart';
import 'package:webrtc_flutter/ui/route_item.dart';
import 'package:webrtc_flutter/ui/screens/home/bloc/home_bloc.dart';
import 'package:webrtc_flutter/ui/screens/home/components/body.dart';
import 'package:webrtc_flutter/ui/screens/home/components/profile_drawer.dart';
import 'package:webrtc_flutter/ui/screens/home/components/topbar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  List<RouteItem> items = [];
  User currentUser = User(id: "id", avatar: "avatar", email: "email", name: "name");

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: topBar(),
            drawer: profileDrawer(context, currentUser),
            body: BlocProvider<HomeBloc>(
                create: (context) => injector.get(),
                child: BodyHome(getCurrentUser: (user) {
                  setState(() {
                    currentUser = user;
                  });
                }))));
  }
}
