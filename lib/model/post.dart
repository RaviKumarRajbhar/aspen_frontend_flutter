class Post {

  final String id;
  final String caption;
  final String createdAt;
  final int likeCount;
  final int commentCount;
  final String imageUrl;
  final String userId;
  final String username;
  final bool landscape;

  Post({required this.id, required this.caption, required this.createdAt, required this.likeCount, required this.commentCount, required this.imageUrl, required this.userId, required this.username, required this.landscape});


  factory Post.fromJson(Map<String , dynamic> json) {
    return Post(
        id: json["id"],
        caption: json["caption"],
        createdAt: json["createdAt"],
        likeCount: json["likeCount"],
        commentCount: json["commentCount"],
        imageUrl: json["imageUrl"],
        userId: json["userId"],
        username: json["username"],
        landscape: json["landscape"]
    );
  }
}