import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webrtc_flutter/domain/entities/user/user.dart';
import 'package:webrtc_flutter/injection.dart';
import 'package:webrtc_flutter/ui/route_item.dart';
import 'package:webrtc_flutter/ui/screens/call_group/call_group_screen.dart';
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

  List<User> _listUser() {
    var users = <User>[];
    users.add(User(
        id: "qBQ63lA5neZPpqP0QLeMKEdK6N82",
        avatar: "https://hoala.vn/upload/img/images/hoa_thanh_luong_11.jpg",
        email: "email",
        name: "Omar Levin"));
    users.add(User(
        id: "dQw6jgPNeshh8AEKsOr9yPpTOpp1",
        avatar: "https://hoala.vn/upload/img/images/hoa_thanh_luong_11.jpg",
        email: "email",
        name: "Emerson Herwitz"));
    users.add(User(
        id: "Hbx4MrsV7haempcr7JRVbeQh1lD3",
        avatar: "https://hoala.vn/upload/img/images/hoa_thanh_luong_11.jpg",
        email: "email",
        name: "Alexandrine Xander"));
    users.add(User(
        id: "LG2LzJMv2NaE43lb1vlsfJgYA1s1",
        avatar: "https://hoala.vn/upload/img/images/hoa_thanh_luong_11.jpg",
        email: "email",
        name: "Stephen"));
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: topBar(() {
              Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (_) => CallGroupScreen(
                          host: homeBloc.getBaseUrlServer(),
                          to: _listUser(),
                          session: null,
                          offer: null,
                          isRequestCall: true)));
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
