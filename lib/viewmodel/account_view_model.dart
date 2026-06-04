import 'package:aspen_app/states/account_state.dart';
import 'package:aspen_app/repository/account_repository.dart';
import 'package:aspen_app/repository/follow_repository.dart';
import 'package:aspen_app/model/api_response.dart';
import 'package:aspen_app/model/follow_model.dart';
import 'package:aspen_app/repository/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/feed_model.dart';
import '../model/user_model.dart';

class AccountViewModel extends StateNotifier<AccountState> {

  final AccountRepository repository;
  final PostRepository postRepository;
  final FollowRepository followRepository;

  AccountViewModel(this.repository,  this.postRepository, this.followRepository): super(const AccountState(isLoading: false , isRefreshing: false , isSaving: false));

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, error: null);


    try {
      final results = await Future.wait([
        repository.getInfo(),
        postRepository.getAllPosts(),
        followRepository.getFollowers(),
        followRepository.getFollowings()
      ]);


      final userResponse = results[0] as ApiResponse<User>;
      final postResponse = results[1] as ApiResponse<List<Map<String, dynamic>>>;
      final followResponse = results[2] as ApiResponse<List<Map<String, dynamic>>>;
      final followingResponse = results[3] as ApiResponse<List<Map<String, dynamic>>>;

      print("POST SUCCESS = ${postResponse.success}");
      print("FOLLOWERS SUCCESS = ${followResponse.success}");
      print("FOLLOWING SUCCESS = ${followingResponse.success}");

      print("POST DATA = ${postResponse.data}");
      print("FOLLOWERS DATA = ${followResponse.data}");
      print("FOLLOWING DATA = ${followingResponse.data}");

      print("FOLLOWERS ERROR = ${followResponse.error}");
      print("FOLLOWING ERROR = ${followingResponse.error}");


      if (!userResponse.success) {
        state = state.copyWith(isLoading: false, error: userResponse.error ?? "Failed to load Info");
        return;
      }

      print(postResponse.data);

      final postData = (postResponse.data ?? [])
          .map((e) => FeedModel.fromJson(e))
          .toList();

      final followData = (followResponse.data ?? [])
          .map((e) => FollowModel.fromJson(e))
          .toList();

      final followingData = (followingResponse.data ?? [])
          .map((e) => FollowModel.fromJson(e))
          .toList();


      state = state.copyWith(isLoading: false,
          user: userResponse.data,
          posts: postData,
          followings: followingData,
          followers: followData);
     } catch (e, stackTrace) {
  print("ACCOUNT ERROR => $e");
  print(stackTrace);

  state = state.copyWith(
  error: e.toString(),
  isLoading: false,
  );
}
  }


  Future<void> refreshProfile() async {

    state = state.copyWith(isRefreshing: true , error:  null);
    final response = await repository.getInfo();

    state = state.copyWith(isRefreshing: false ,
        error : response.success ? null : response.error,
        user : response.data);
  }

  Future<void> saveProfile() async {
    state = state.copyWith(isSaving: true);
  }



}

final accountViewModelProvider = StateNotifierProvider<AccountViewModel , AccountState> ((ref) {
  final repository = ref.read(accountRepoProvider);
  final postRepo = ref.read(postRepoProvider);
  final followRepo = ref.read(followRepoProvider);
  return AccountViewModel( repository , postRepo , followRepo);
});