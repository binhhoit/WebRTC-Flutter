import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webrtc_flutter/domain/entities/user/user.dart';
import 'package:webrtc_flutter/injection.dart';
import 'package:webrtc_flutter/ui/route_item.dart';
import 'package:webrtc_flutter/ui/screens/create_group/create_group_screen.dart';
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
  late HomeBloc homeBloc;

  @override
  initState() {
    homeBloc = injector.get<HomeBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: topBar(() {
              Navigator.push(
                  context, MaterialPageRoute<void>(builder: (_) => const CreateGroupScreen()));
            }),
            drawer: profileDrawer(context, currentUser),
            body: BlocProvider<HomeBloc>(
                create: (context) => homeBloc,
                child: BodyHome(getCurrentUser: (user) {
                  setState(() {
                    currentUser = user;
                  });
                }))));
  }
}
