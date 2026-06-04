import 'package:aspen_app/model/comment_model.dart';

class CommentState {
  final bool loading ;

  final List<CommentModel> comments;

  CommentState({
    this.loading = false,
    this.comments = const[]
});

  CommentState copyWith ({
    bool? loading,
    List<CommentModel>? comments
}) {
    return CommentState(
      loading: loading ?? this.loading,
      comments: comments ?? this.comments
    );
  }



}