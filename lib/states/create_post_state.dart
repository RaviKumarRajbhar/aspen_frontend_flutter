import 'dart:io';

class CreatePostState {

  final File? selectedImage;

  final String caption;

  final bool isLoading;

  CreatePostState({

    this.selectedImage,

    this.caption = "",

    this.isLoading = false,
  });

  CreatePostState copyWith({

    File? image,

    String? caption,

    bool? isLoading,
  }) {

    return CreatePostState(

      selectedImage:
      image ??
          selectedImage,

      caption:
      caption ??
          this.caption,

      isLoading:
      isLoading ??
          this.isLoading,
    );
  }
}