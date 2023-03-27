import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webrtc_flutter/domain/entities/room/room.dart';
import 'package:webrtc_flutter/domain/entities/user/user.dart';
import 'package:webrtc_flutter/platform/local/preferences/preference_manager.dart';
import 'package:webrtc_flutter/ui/screens/call_group/call_group_screen.dart';
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
  var rooms = <Room>[];
  late User currentUser;

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
              itemCount: users.length + rooms.length,
              itemBuilder: (context, i) {
                var lastIndexRoom = rooms.length - 1;
                if (lastIndexRoom - i >= 0) {
                  return _buildRoomRow(context, rooms[i]);
                } else {
                  return _buildRow(context, users[i - rooms.length]);
                }
              });
    }, listener: (context, state) {
      if (state is UserData) {
        setState(() {
          users = state.users;
        });
      } else if (state is CurrentUser) {
        currentUser = state.user;
        widget.getCurrentUser(state.user);
      } else if (state is RoomData) {
        setState(() {
          rooms = state.rooms;
        });
      } else if (state is HomeError) {
        Fluttertoast.showToast(msg: state.message);
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
                  builder: (_) => CallGroupScreen(
                        to: [item, currentUser],
                        session: null,
                        offer: null,
                        isRequestCall: true,
                      )));
        },
        trailing: const Icon(Icons.video_call_outlined),
      ),
      const Divider()
    ]);
  }

  _buildRoomRow(context, item) {
    return ListBody(children: <Widget>[
      ListTile(
        leading: const Icon(Icons.video_call),
        title: Text("Room: ${item.id}"),
        subtitle: const Text("Join now"),
        onTap: () {
          var currentId = PreferenceManager.instance.currentUser.id;
          if (!item.idUsers.contains(currentId)) {
            Fluttertoast.showToast(msg: 'User is not in room');
            return;
          }
          var users = item.idUsers.map((id) => User(id: id, avatar: '', email: '', name: ''));
          Navigator.push(
              context,
              MaterialPageRoute<void>(
                  builder: (_) => CallGroupScreen(
                        to: users.toList(),
                        session: null,
                        offer: null,
                        isRequestCall: false,
                        roomId: item.id,
                      )));
        },
        trailing: const Icon(Icons.arrow_right),
      ),
      const Divider()
    ]);
  }
}
