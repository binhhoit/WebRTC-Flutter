import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webrtc_flutter/domain/entities/user/user.dart';
import 'package:webrtc_flutter/injection.dart';
import 'package:webrtc_flutter/platform/local/preferences/preference_manager.dart';
import 'package:webrtc_flutter/resources/fonts.gen.dart';
import 'package:webrtc_flutter/ui/screens/home/bloc/home_bloc.dart';

import '../call_group/call_group_screen.dart';
import '../home/bloc/home_state.dart';

class MyListItem {
  final String title;
  bool isSelected;

  MyListItem({required this.title, this.isSelected = false});
}

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  _CreateGroupScreen createState() => _CreateGroupScreen();
}

class _CreateGroupScreen extends State<CreateGroupScreen> {
  late HomeBloc homeBloc;
  List<User> _users = [];

  @override
  initState() {
    homeBloc = injector.get<HomeBloc>();
    super.initState();
  }

  _createGroupCall() {
    var users = _users.where((user) => user.isSelected == true).toList();
    var currentUser = PreferenceManager.instance.currentUser;
    users.add(currentUser);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
            builder: (_) => CallGroupScreen(
                host: homeBloc.getBaseUrlServer(),
                to: users,
                session: null,
                offer: null,
                isRequestCall: true)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
            ],
          ),
          backgroundColor: Colors.white,
          shadowColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: BlocProvider<HomeBloc>(
            create: (context) => homeBloc,
            child: BlocConsumer<HomeBloc, HomeState>(
              builder: (context, state) {
                return _users.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Flexible(
                            child: ListView.separated(
                              itemCount: _users.length,
                              itemBuilder: (BuildContext context, int index) {
                                return CheckboxListTile(
                                  visualDensity: const VisualDensity(vertical: 4),
                                  title: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0), // Set the corner radius
                                        child: Image.network(
                                          _users[index].avatar,
                                          width: 60.0,
                                          height: 60.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text(_users[index].name),
                                    ],
                                  ),
                                  value: _users[index].isSelected,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _users[index].isSelected = value!;
                                    });
                                  },
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) {
                                return const Divider(
                                  color: Colors.lightBlueAccent,
                                  height: 0.2,
                                );
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                            child: MaterialButton(
                              minWidth: double.infinity,
                              height: 50,
                              color: Colors.black,
                              onPressed: _createGroupCall,
                              child: const Text(
                                'Start Call',
                                style: TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.w300, fontSize: 18),
                              ),
                            ),
                          )
                        ],
                      );
              },
              listener: (_, state) {
                if (state is UserData) {
                  setState(() {
                    _users = state.users;
                  });
                }
              },
            )));
  }
}
