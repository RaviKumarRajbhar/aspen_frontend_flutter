import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  final String username;
  final String content;
  final int likes;
  final int comments;
  final String imageUrl;
  final bool isLandscape;
  final bool isLiked;
  final VoidCallback onLike;
  final VoidCallback onComment;

  const PostWidget({
    super.key,
    required this.username,
    required this.imageUrl,
    required this.content,
    required this.likes,
    required this.comments,
    required this.isLandscape,
    required this.isLiked,
    required this.onLike,
    required this.onComment
  });

  @override
  Widget build(BuildContext context) {

    final baseUrl = "http://localhost:8080";
    
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 12,
      ),
      color: theme.cardColor,
      
      elevation: 3,
      
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      
      clipBehavior: Clip.antiAlias,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.all(12),
            
            child: Row(
              children: [
                
                CircleAvatar(
                  radius: 22,
                  
                  backgroundColor: theme.primaryColor.withValues(alpha: 0.15),
                  child: Icon(Icons.person ,color: theme.primaryColor,),
                  
                ),

                const SizedBox(width: 10),

                Expanded(
                  
                  child: Text(
                    username,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),

                Icon(Icons.more_vert ,
                color: theme.textTheme.bodyMedium?.color,),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: Text(
              content,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 18,
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 12),

          AspectRatio(
            aspectRatio:
            isLandscape
                ? 16 / 9
                : 4 / 5,
            child: Image.network(
              baseUrl + imageUrl,
              fit: BoxFit.cover,

              errorBuilder: (context , error , stackTree) {
                return Center(
                  child: Icon(
                    Icons.broken_image,
                    color: theme.primaryColor,
                      size: 40,
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                GestureDetector(

                  onTap: onLike,
                  child: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    size: 26,
                    color: isLiked ? Colors.red : theme.primaryColor,
                  ),
                ),

                const SizedBox(width: 6),

                Text(
                  likes.toString(),
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 15)),

                const SizedBox(width: 20),

                GestureDetector(
                  onTap: onComment,
                  child: Icon(
                  Icons.comment_outlined,
                  size: 26,
                  color: theme.primaryColor,
                  ),
                ),

                const SizedBox(width: 6),

                Text(comments.toString(), style: theme.textTheme.bodyMedium ?.copyWith(fontSize: 15)),

                const Spacer(),

                Icon(Icons.share_outlined ,
                color: theme.primaryColor,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}