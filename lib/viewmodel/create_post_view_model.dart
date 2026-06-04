import 'dart:io';

import 'package:aspen_app/states/create_post_state.dart';
import 'package:aspen_app/repository/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostViewModel extends StateNotifier<CreatePostState> {

  final PostRepository repository;

  CreatePostViewModel( this.repository ) : super(CreatePostState());

  final ImagePicker picker = ImagePicker();

  Future<File?> pickImage() async {

    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) {
      return null;
    }

    return File(picked.path);
  }

  void setSelectedImage( File file ) {
    state = state.copyWith(image: file);
  }

  void clearSelectedImage() {
     state = state.copyWith(image: null);
  }

  void reset() {
    state = CreatePostState();
  }

  Future<void> uploadPost({
    required File image,
    required String caption,
    required bool isLandscape,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      await repository.uploadPost( image: image, caption: caption , isLandscape: isLandscape);
      try {
        if (await image.exists()) {
          await image.delete();
        }

      } catch (_) {}

    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final createPostViewModelProvider = StateNotifierProvider<CreatePostViewModel, CreatePostState>((ref) {
  final repo = ref.read( postRepoProvider );
  return CreatePostViewModel( repo );
});