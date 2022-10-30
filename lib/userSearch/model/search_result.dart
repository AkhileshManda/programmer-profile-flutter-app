class SearchResult {
  String email;
  String name;
  String? photoUrl;

  SearchResult({
    required this.email,
    required this.name,
    this.photoUrl
  });

}