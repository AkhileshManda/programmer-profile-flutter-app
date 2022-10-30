class CFRatingModel{
  int contestId;
  String contestName;
  String handle;
  int rank;
  int oldRating;
  int newRating;

  CFRatingModel({
    required this.contestId,
    required this.contestName,
    required this.handle,
    required this.rank,
    required this.oldRating,
    required this.newRating
  });
}