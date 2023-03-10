import 'package:injectable/injectable.dart';

abstract class BuildConfig {
  abstract String baseUrl;
}

@Injectable(as: BuildConfig, env: [Environment.dev])
class DevBuildConfig extends BuildConfig {
  @override
  String baseUrl = "https://web-rtc-ktor.herokuapp.com/";
}

@Injectable(as: BuildConfig, env: [Environment.test])
class StagingBuildConfig extends BuildConfig {
  @override
  String baseUrl = "https://web-rtc-ktor.herokuapp.com/";
}

@Injectable(as: BuildConfig, env: [Environment.prod])
class ProdBuildConfig extends BuildConfig {
  @override
  String baseUrl = "https://web-rtc-ktor.herokuapp.com/";
}
