abstract class DataRepository {
  Future<void> sentFCMToken(Map<String, dynamic> queryParams);
  Future<void> declinedCall(Map<String, dynamic> sessionIdParams);
}
