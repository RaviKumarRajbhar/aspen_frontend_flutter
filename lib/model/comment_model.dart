class CommentModel {

  final String id;
  final String content;
  final String username;

  CommentModel({
    required this.id,
    required this.content,
    required this.username
});
  factory CommentModel.fromJson (Map<String , dynamic> json) {
    return CommentModel(id: json["id"],
  content: json["content"],
  username: json["username"]);
  }
}