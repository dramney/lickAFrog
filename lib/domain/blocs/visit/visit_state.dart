abstract class VisitState {}

class VisitInitial extends VisitState {}

class VisitLoading extends VisitState {}

class VisitLoaded extends VisitState {
  final String currentUserId;
  final String currentUserName;
  final String friendId;
  final String friendName;
  final int visitCount;
  final int friendLicksCount;
  final bool wasLicked;

  VisitLoaded({
    required this.currentUserId,
    required this.currentUserName,
    required this.friendId,
    required this.friendName,
    required this.visitCount,
    required this.friendLicksCount,
    this.wasLicked = false,
  });

  VisitLoaded copyWith({
    String? currentUserId,
    String? currentUserName,
    String? friendId,
    String? friendName,
    int? visitCount,
    int? friendLicksCount,
    bool? wasLicked,
  }) {
    return VisitLoaded(
      currentUserId: currentUserId ?? this.currentUserId,
      currentUserName: currentUserName ?? this.currentUserName,
      friendId: friendId ?? this.friendId,
      friendName: friendName ?? this.friendName,
      visitCount: visitCount ?? this.visitCount,
      friendLicksCount: friendLicksCount ?? this.friendLicksCount,
      wasLicked: wasLicked ?? this.wasLicked,
    );
  }
}

class VisitError extends VisitState {
  final String message;

  VisitError(this.message);
}
