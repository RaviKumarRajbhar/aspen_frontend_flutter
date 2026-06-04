class User {

  final String name;
  final String email;
  final String bio;
  final int postCount;
  final int followerCount;
  final int followingCount;
  String profileImageURL = "";


  User({required this.name, required this.email, required this.bio, required this.postCount, required this.followerCount, required this.followingCount});


  factory User.fromJson(Map<String,dynamic> json) {
    return User(
      name: json["username"],
      email: json["email"],
      bio : json["bio"],
      postCount: json["postCount"],
      followerCount: json["followers"],
      followingCount: json["following"],
    );
  }




}