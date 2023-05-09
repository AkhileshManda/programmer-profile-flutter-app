class SearchResult {
  String id;
  String email;
  String name;
  String? photoUrl;
  String? description;
  bool isFollowing;

  SearchResult({
    required this.id,
    required this.email,
    required this.name,
    required this.isFollowing,
    this.photoUrl,
    this.description,
  });
}
