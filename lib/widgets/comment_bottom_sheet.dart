import 'package:aspen_app/viewmodel/feed_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodel/comment_view_model.dart';

class CommentBottomSheet extends ConsumerStatefulWidget {

  final String postId;

  const CommentBottomSheet({
    super.key,
    required this.postId,
  });

  @override
  ConsumerState<CommentBottomSheet> createState() =>
      _CommentBottomSheetState();
}

class _CommentBottomSheetState extends ConsumerState<CommentBottomSheet> {

  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {

    super.initState();

    Future.microtask(() {
      ref.read(commentViewModelProvider.notifier).loadComments(widget.postId);
    });
  }

  @override
  void dispose() {

    commentController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final state = ref.watch(commentViewModelProvider);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),

      child: SafeArea(

        child: SizedBox(

          height: MediaQuery.of(context).size.height * 0.8,

          child: Column(

            children: [
              const SizedBox(height: 12),

              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.circular(20),
                ),
              ),

              const SizedBox( height: 16),

              const Text("Comments",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const Divider(),

              Expanded(
                child: state.loading ?
                const Center( child: CircularProgressIndicator()) : state.comments.isEmpty ?
                  const Center(
                  child: Text("No comments yet")) : ListView.builder(
                  itemCount: state.comments.length,

                  itemBuilder:(_, index) {

                    final comment = state.comments[index];

                    return ListTile( leading: const CircleAvatar( child: Icon( Icons.person )),
                      title: Text( comment.username,
                      ),

                      subtitle: Text( comment.content ),
                    );
                  },
                ),
              ),

              const Divider(),

              Padding(

                padding: const EdgeInsets.all( 12 ),

                child: Row(
                  children: [

                    Expanded(
                      child: TextField(
                        controller:commentController,

                        decoration: const InputDecoration(
                          hintText:"Write a comment...",
                            border: OutlineInputBorder()),
                      ),
                    ),

                    const SizedBox(width: 8),

                    IconButton( onPressed: () async {
                        final text = commentController.text.trim();

                        if (text.isEmpty) {
                          return;
                        }

                        await ref.read(commentViewModelProvider.notifier).addComment( widget.postId, text);

                        ref.read(feedViewModelProvider.notifier).incrementCommentCount(widget.postId);
                        commentController.clear();
                      },

                      icon: const Icon(Icons.send ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}