import 'package:flutter/material.dart';

import '../model/profile_user.dart';

class OtherUserProfileScreen extends StatelessWidget {

  final ProfileUser user;

  const OtherUserProfileScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(user.username),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [

                  CircleAvatar(
                    radius: 40,
                    backgroundImage:
                    NetworkImage(user.profileImage),
                  ),

                  const SizedBox(width: 20),

                  Expanded(
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                      children: [

                        _buildStat(
                          context: context,
                          title: "Posts",
                          value: user.posts.length.toString(),
                        ),

                        _buildStat(
                          context: context,
                          title: "Followers",
                          value: user.followers.toString(),
                        ),

                        _buildStat(
                          context: context,
                          title: "Following",
                          value: user.following.toString(),
                        ),

                      ],
                    ),
                  )

                ],
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Text(
                    user.username,
                    style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(user.bio),

                ],
              ),
            ),

            const SizedBox(height: 20),

            Divider(
              color: Theme.of(context).dividerColor,
            ),

            GridView.builder(
              shrinkWrap: true,
              physics:
              const NeverScrollableScrollPhysics(),
              itemCount: user.posts.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemBuilder: (context, index) {

                return Image.network(
                  user.posts[index],
                  fit: BoxFit.cover,
                );

              },
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildStat({
    required BuildContext context,
    required String title,
    required String value,
  }) {

    return Column(
      children: [

        Text(
          value,
          style: Theme.of(context)
      .textTheme
      .bodyMedium
      ?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),

        Text(title,
        style: Theme.of(context)
          .textTheme
          .bodyMedium,),

      ],
    );
  }
}