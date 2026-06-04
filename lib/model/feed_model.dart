class FeedModel {

  final String id;
  final String caption;
  final String imageUrl;

  final String username;
  final String userId;

  final int likeCount;
  final int commentCount;
  final String createdAt;
  final bool landscape;
  final bool likedByCurrentUser;

  FeedModel({
    required this.id,
    required this.caption,
    required this.imageUrl,
    required this.username,
    required this.userId,
    required this.likeCount,
    required this.commentCount,
    required this.createdAt,
    required this.landscape,
    required this.likedByCurrentUser
  });

  factory FeedModel.fromJson(
      Map<String, dynamic> json,
      ) {

    return FeedModel(
      id: json["id"],
      caption: json["caption"],
      imageUrl: json["imageUrl"],
      username: json["username"],
      userId: json["userId"],
      likeCount: json["likeCount"],
      commentCount: json["commentCount"],
      createdAt: json["createdAt"],
      landscape: json["landscape"] ?? false,
      likedByCurrentUser: json["likedByCurrentUser"] ?? false
    );
  }

  FeedModel copyWith({

    String? id,
    String? caption,
    String? imageUrl,

    String? username,
    String? userId,

    int? likeCount,
    int? commentCount,

    String? createdAt,

    bool? landscape,
    bool? likedByCurrentUser,

  }) {

    return FeedModel(

      id: id ?? this.id,

      caption: caption ?? this.caption,

      imageUrl: imageUrl ?? this.imageUrl,

      username: username ?? this.username,

      userId: userId ?? this.userId,

      likeCount:
      likeCount ?? this.likeCount,

      commentCount:
      commentCount ?? this.commentCount,

      createdAt:
      createdAt ?? this.createdAt,

      landscape:
      landscape ?? this.landscape,

      likedByCurrentUser:
      likedByCurrentUser ??
          this.likedByCurrentUser,
    );
  }
}