class ProfileUser {
  final String id;
  final String username;
  final String bio;
  final String profileImage;
  final int followers;
  final int following;
  final List<String> posts;

  ProfileUser({
    required this.id,
    required this.username,
    required this.bio,
    required this.profileImage,
    required this.followers,
    required this.following,
    required this.posts,
  });
}