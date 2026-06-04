import 'package:aspen_app/repository/feed_repository.dart';
import 'package:aspen_app/states/feed_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/feed_model.dart';


class FeedViewModel extends StateNotifier<FeedState> {

  final FeedRepository repo;

  FeedViewModel(this.repo) :super(FeedState(status: FeedStatus.initial));

  Future<void> loadFeed() async {

    state = state.copyWith(status: FeedStatus.loading);

    final result = await repo.getFeed();

    if(result.success){
      state = state.copyWith(status: FeedStatus.success , posts: result.data! , error : null);
    } else {
      state = state.copyWith(status: FeedStatus.error , error: result.error);
    }
  }

  Future<void> toggleLike (FeedModel post) async {
    final success = await repo.toggleLike(post.id);

    if(!success) {
      return;
    }
    final updatedPosts = state.posts.map((p) {
      if (p.id != post.id) {
        return p;
      }
      final liked = !p.likedByCurrentUser;

      return p.copyWith(likedByCurrentUser: liked ,
      likeCount: liked ? p.likeCount +1 : p.likeCount - 1);
    }).toList();

    state =state.copyWith(posts: updatedPosts);
  }

  void incrementCommentCount(String postId) {
    final updatedPosts = state.posts.map((e) {
      if(e.id != postId) {
        return e;
      }

      return e.copyWith(commentCount : e.commentCount + 1);
    }).toList();

    state = state.copyWith(posts: updatedPosts);
  }

}

final feedViewModelProvider = StateNotifierProvider<FeedViewModel, FeedState> ((ref){
  final repo = ref.read(feedRepoProvider);
  return FeedViewModel(repo);
});

