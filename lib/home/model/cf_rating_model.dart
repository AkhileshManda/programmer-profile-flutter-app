class CFRatingModel {
  int contestId;
  String contestName;
  DateTime date;
  String handle;
  int rank;
  int oldRating;
  int newRating;

  CFRatingModel({
    required this.contestId,
    required this.contestName,
    required this.date,
    required this.handle,
    required this.rank,
    required this.oldRating,
    required this.newRating,
  });
}
