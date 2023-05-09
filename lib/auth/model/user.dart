import 'dart:core';

class User {
  String? id;
  String? username;
  String? email;
  String? profilePicture;
  String? description;
  String? codeforcesUsername;
  String? githubUsername;
  String? leetcodeUsername;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<String>? followedByIds;
  List<String>? followingIds;
  String? githubToken;

  User({
    this.id,
    this.email,
    this.username,
    this.profilePicture,
    this.description,
    this.codeforcesUsername,
    this.githubUsername,
    this.leetcodeUsername,
    this.createdAt,
    this.updatedAt,
    this.followedByIds,
    this.followingIds,
    this.githubToken,
  });
}
