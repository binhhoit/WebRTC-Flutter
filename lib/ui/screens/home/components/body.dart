import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webrtc_flutter/domain/entities/user/user.dart';
import 'package:webrtc_flutter/ui/screens/home/bloc/home_bloc.dart';
import 'package:webrtc_flutter/ui/screens/home/bloc/home_event.dart';
import 'package:webrtc_flutter/ui/screens/home/bloc/home_state.dart';

class HomeBody extends StatelessWidget {
  HomeBody({Key? key}) : super(key: key);

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
        builder: (context, HomeState state) {
          User? user = (state as HomeIdle).data;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Name: ${user?.name ?? ''}',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 30,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    MaterialButton(
                      color: Colors.blue,
                      onPressed: () {
                        BlocProvider.of<HomeBloc>(context)
                            .add(const FetchProfile());
                      },
                      child: const Text('Get Profile'),
                    ),
                    ValueListenableBuilder<bool>(
                        valueListenable: isLoading,
                        builder: (context, bool value, _) {
                          if (value) {
                            return const CircularProgressIndicator(color: Colors.green,);
                          }
                          return Container();
                        })
                  ],
                )
              ],
            ),
          );
        },
        listener: (context, state) {
          isLoading.value = state is HomeLoading;
          if(state is HomeError) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('error')));
          }
        },
        buildWhen: (prev, cur) {
          return cur is HomeIdle;
        });
  }
}
