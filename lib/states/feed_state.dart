import '../model/feed_model.dart';

enum FeedStatus {
  initial,
  loading,
  success,
  error
}

class FeedState {

  final FeedStatus status;
  final List<FeedModel> posts;
  final String? error;

  FeedState({required this.status, this.posts = const[], this.error});

  FeedState copyWith({
    FeedStatus? status,
    List<FeedModel>? posts,
    String? error
}) {
     return FeedState(
       status: status ?? this.status,
       posts: posts ?? this.posts,
       error: error ?? this.error
     );
  }

}