import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webrtc_flutter/domain/entities/user/user.dart';
import 'package:webrtc_flutter/ui/screens/call_sample/call_screen.dart';
import 'package:webrtc_flutter/ui/screens/home/bloc/home_bloc.dart';
import 'package:webrtc_flutter/ui/screens/home/bloc/home_state.dart';

class BodyHome extends StatefulWidget {
  BodyHome({Key? key, required this.getCurrentUser}) : super(key: key);

  Function(User user) getCurrentUser;

  @override
  State<BodyHome> createState() => _BodyHome();
}

class _BodyHome extends State<BodyHome> {
  var users = <User>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(builder: (context, state) {
      return state is HomeLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(0.0),
              itemCount: users.length,
              itemBuilder: (context, i) {
                return _buildRow(context, users[i]);
              });
    }, listener: (context, state) {
      if (state is UserData) {
        setState(() {
          users = state.users;
        });
      } else if (state is CurrentUser) {
        widget.getCurrentUser(state.user);
      }
    });
  }

  _buildRow(context, item) {
    return ListBody(children: <Widget>[
      ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(20.0), // Set the corner radius
          child: Image.network(
            item.avatar,
            width: 60.0,
            height: 60.0,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(item.name),
        subtitle: const Text("Online"),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute<void>(
                  builder: (_) => CallScreen(host: "web-rtc-ktor.herokuapp.com")));
        },
        trailing: const Icon(Icons.video_call_outlined),
      ),
      const Divider()
    ]);
  }
}
