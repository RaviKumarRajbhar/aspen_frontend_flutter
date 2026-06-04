import 'post.dart';

class FeedResponse {

  final List<Post> posts;

  FeedResponse({required this.posts});

  factory FeedResponse.fromJson(Map<String , dynamic> json) {
    return FeedResponse(posts: (json["posts"] as List).map((e) => Post.fromJson(e)).toList());

  }


}
