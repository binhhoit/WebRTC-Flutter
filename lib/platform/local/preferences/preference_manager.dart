import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class PreferenceManager {
  static const String _accessTokenKey = 'ACCESS_TOKEN';
  static const String _refreshTokenKey = 'REFRESH_TOKEN';

  static const String _boxName = 'app_preference';

  static PreferenceManager get _instance =>
      PreferenceManager._privateConstructor();

  PreferenceManager._privateConstructor();

  static PreferenceManager get instance {
    return _instance;
  }

  @factoryMethod
  static PreferenceManager create() => _instance;


  Box get _box => Hive.box(_boxName);

  static Future<void> init() async {
      Hive.openBox(_boxName);
  }

  String get accessToken {
    return _box.get(_accessTokenKey, defaultValue: "") as String;
  }

  set accessToken(String? value) {
    _box.put(_accessTokenKey, value);
  }

  bool get isLoggedIn => accessToken.isNotEmpty;

  Future<void> clear() async {
    await _box.clear();
  }
}
