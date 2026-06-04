import 'package:aspen_app/states/comment_state.dart';
import 'package:aspen_app/repository/comment_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentViewModel extends StateNotifier<CommentState> {

  final CommentRepository repo;

  CommentViewModel(this.repo) : super (CommentState());


  Future<void> loadComments(String postId) async {
    state = state.copyWith(loading: true);

    final comments = await repo.getComments(postId);

    state = state.copyWith(loading: false , comments: comments);
  }

  Future<void> addComment(String postId , String content) async {

    final success = await repo.addComment(postId, content);

    if (!success) {
      return;
    }
    await loadComments(postId);

  }
}

final commentViewModelProvider = StateNotifierProvider<CommentViewModel , CommentState > ((ref) {
  final repo = ref.read(commentRepoProvider);
  return CommentViewModel(repo);
});