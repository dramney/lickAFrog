import '../entities/frog.dart';

abstract class FrogRepository {
  Future<FrogData> getFrogData(String userId);
  Future<void> updateLicks(String userId, {required int dayLicks, required int allLicks});

}