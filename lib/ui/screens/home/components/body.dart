import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
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
  late HomeBloc _bloc;

  @override
  void initState() {
    _bloc = context.read();
    FlutterCallkitIncoming.onEvent.listen((event) {
      _callEventHandle(event, () {
        var users = (event?.body['extra']['idUsers'] as List<dynamic>)
            .map((e) => User(id: e, avatar: '', email: '', name: ''));
        Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (_) => CallGroupScreen(
                  to: users,
                  roomId: event?.body['extra']['roomId'],
                  isRequestCall: false,
                )));
      }, () {
        _bloc.sendByeUser(event?.body['extra']['roomId']);
      });
    });
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

_callEventHandle(CallEvent? event, Function callback, Function bye) {
  print(event);

  switch (event!.event) {
    case Event.ACTION_CALL_INCOMING:
// TODO: received an incoming call
      break;
    case Event.ACTION_CALL_START:
// TODO: started an outgoing call
// TODO: show screen calling in Flutter
      break;
    case Event.ACTION_CALL_ACCEPT:
      callback.call();
      Fluttertoast.showToast(
          msg: 'Accept Call}',
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16);
      print(event.body.toString());
      break;
    case Event.ACTION_CALL_DECLINE:
      bye.call();
      break;
    case Event.ACTION_CALL_ENDED:
// TODO: ended an incoming/outgoing call
      break;
    case Event.ACTION_CALL_TIMEOUT:
      bye.call();
      break;
    case Event.ACTION_CALL_CALLBACK:
// TODO: only Android - click action `Call back` from missed call notification
      break;
    case Event.ACTION_CALL_TOGGLE_HOLD:
// TODO: only iOS
      break;
    case Event.ACTION_CALL_TOGGLE_MUTE:
// TODO: only iOS
      break;
    case Event.ACTION_CALL_TOGGLE_DMTF:
// TODO: only iOS
      break;
    case Event.ACTION_CALL_TOGGLE_GROUP:
// TODO: only iOS
      break;
    case Event.ACTION_CALL_TOGGLE_AUDIO_SESSION:
// TODO: only iOS
      break;
    case Event.ACTION_DID_UPDATE_DEVICE_PUSH_TOKEN_VOIP:
// TODO: only iOS
      break;
  }
}
