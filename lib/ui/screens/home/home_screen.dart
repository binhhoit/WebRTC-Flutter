import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webrtc_flutter/injection.dart';
import 'package:webrtc_flutter/ui/screens/home/bloc/home_event.dart';

import 'bloc/home_bloc.dart';
import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (_) => injector.get<HomeBloc>()..add(const HomeEvent.fetchProfile()),
      child: Scaffold(
        body: HomeBody(),
      ),
    );
  }
}
