import 'package:rxdart/rxdart.dart';
import 'package:webrtc_flutter/domain/entities/enums.dart';

BehaviorSubject<AuthenticationStatus> reactiveAuthStatus = BehaviorSubject<AuthenticationStatus>(sync: true)..add(AuthenticationStatus.unknown);