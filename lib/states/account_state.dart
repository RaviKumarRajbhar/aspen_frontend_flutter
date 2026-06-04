import 'package:aspen_app/model/follow_model.dart';

import '../model/feed_model.dart';
import '../model/user_model.dart';

class AccountState {

  final bool isLoading;
  final bool isRefreshing;
  final bool isSaving;
  final User? user;
  final String? error;
  final List<FeedModel>? posts;
  final List<FollowModel>? followers;
  final List<FollowModel>? following;

  const AccountState({
    this.isRefreshing = false,
    this.isLoading = false,
    this.isSaving = false,
    this.user,
    this.posts,
    this.error, this.followers, this.following
  });

  AccountState copyWith({
      bool? isLoading,
      bool? isRefreshing,
      bool? isSaving,
      User? user,
      List<FeedModel>? posts,
      List<FollowModel>? followers,
      List<FollowModel>? followings,
      String? error,
}) {
    return AccountState(
      isLoading : isLoading ?? this.isLoading,
      isRefreshing : isRefreshing ?? this.isRefreshing,
      isSaving : isSaving ?? this.isSaving,
      user : user ?? this.user,
      posts: posts ?? this.posts,
      error : error ?? this.error,
        followers: followers ?? this.followers,
      following: followings ?? this.following
    );
  }

}