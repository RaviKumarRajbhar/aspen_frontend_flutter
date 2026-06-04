import 'dart:io';

import 'package:aspen_app/viewmodel/create_post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'crop_image_screen.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() =>
      CreatePostScreenState();
}

class CreatePostScreenState extends ConsumerState<CreatePostScreen> {

  final captionController = TextEditingController();

  bool postIsLandscape = false;

  @override
  Widget build(BuildContext context) {

    final state = ref.watch(createPostViewModelProvider);

    final notifier = ref.read(createPostViewModelProvider.notifier);

    return Scaffold(

      appBar: AppBar(
        title: const Text("Create Post"),
      ),

      body: SingleChildScrollView(

        child: Padding(

          padding: const EdgeInsets.all(16),

          child: Column(

            children: [

              GestureDetector(

                onTap: () async {

                  if (state.selectedImage != null) {

                    try {
                      await state.selectedImage!.delete();
                    } catch (_) {}

                    notifier.reset();
                  }

                  final image = await notifier.pickImage();

                  if (image == null) {
                    return;
                  }

                  final bytes = await image.readAsBytes();

                  final cropResult = await Navigator.push(
                    context,

                    MaterialPageRoute(

                      builder: (_) =>
                          CropImageScreen(
                            imageBytes:
                            bytes,
                          ),
                    ),
                  );

                  if (cropResult == null) {
                    return;
                  }

                  final croppedBytes = cropResult.croppedImage;

                  postIsLandscape = cropResult.isLandscape;

                  final dir = await getTemporaryDirectory();

                  final croppedFile =File(
                    "${dir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.jpg",
                  );

                  await croppedFile.writeAsBytes(croppedBytes);

                  notifier.setSelectedImage(croppedFile);

                  setState(() {});
                },

                child: AspectRatio( aspectRatio: postIsLandscape ? 16 / 9 : 4 / 5,

                  child: Container(
                    decoration:BoxDecoration(
                      color: Colors.grey.shade300,

                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: state.selectedImage == null ? const Center(

                      child: Text("Select Image"),
                    ) : ClipRRect(

                      borderRadius: BorderRadius.circular(12),

                      child: Image.file(

                        state.selectedImage!,

                        fit: BoxFit.cover,

                        width: double.infinity,

                        height: double.infinity,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: captionController,

                maxLines: 4,
                decoration:const InputDecoration( hintText: "Write a caption..."),
              ),

              const SizedBox( height: 20 ),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(

                  onPressed: state.isLoading ? null : () async {

                    if (state.selectedImage == null) {
                      return;
                    }

                    await notifier.uploadPost(

                      image: state.selectedImage!,

                      caption: captionController.text,

                      isLandscape:postIsLandscape);

                    notifier.reset();

                    captionController.clear();

                    postIsLandscape = false;

                    if (!mounted) {
                      return;
                    }

                    ScaffoldMessenger
                        .of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text("Post uploaded successfully"),
                      ),
                    );

                    Navigator.pop(context);
                  },

                  child: const Text("Post"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}