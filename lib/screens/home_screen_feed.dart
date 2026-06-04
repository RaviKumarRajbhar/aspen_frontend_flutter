import 'package:aspen_app/states/feed_state.dart';
import 'package:aspen_app/viewmodel/feed_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/comment_bottom_sheet.dart';
import '../widgets/post_widget.dart';

class HomeFeedScreen extends ConsumerStatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  ConsumerState<HomeFeedScreen> createState() =>
      HomeFeedScreenState();
}

class HomeFeedScreenState
    extends ConsumerState<HomeFeedScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(feedViewModelProvider.notifier).loadFeed();
    }
    );
  }

  @override
  Widget build(BuildContext context) {

    final feedState = ref.watch(feedViewModelProvider);

    if (feedState.status == FeedStatus.loading) {

      return const Center(child: CircularProgressIndicator());
    }

    if (feedState.status == FeedStatus.error) {

      return Center(
        child: Text(
          feedState.error ?? "Error",
          style: Theme.of(context)
              .textTheme
              .bodyMedium,
        ),
      );
    }

    return ListView.builder(
      itemCount: feedState.posts.length,

      itemBuilder: (_, i) {

        final post = feedState.posts[i];

        return PostWidget(
          imageUrl: post.imageUrl,
          username: post.username,
          content: post.caption,
          likes: post.likeCount,
          comments: post.commentCount,
          isLandscape: post.landscape,
          isLiked: post.likedByCurrentUser,
          onLike: (){ref.read(feedViewModelProvider.notifier).toggleLike(post);},
          onComment: () {
            showModalBottomSheet(context: context,
                isScrollControlled: true,
                builder: (_){
              return CommentBottomSheet( postId: post.id,);
                });
          },
        );
      },
    );
  }
}