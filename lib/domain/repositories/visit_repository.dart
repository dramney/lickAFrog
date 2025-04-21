abstract class VisitRepository {
  Future<int> getVisitCount(String userId, String friendId);
  Future<int> getFriendLicksCount(String friendId);
  Future<void> recordVisit(String userId, String friendId);
  Future<void> recordLick(String userId, String friendId);
}