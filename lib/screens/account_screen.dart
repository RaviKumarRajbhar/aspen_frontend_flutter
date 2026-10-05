import 'package:aspen_app/viewmodel/account_view_model.dart';
import 'package:aspen_app/viewmodel/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState
    extends ConsumerState<AccountScreen>
    with TickerProviderStateMixin {

  late TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 3, vsync: this);

    Future.microtask(() {
      ref.read(accountViewModelProvider.notifier).loadProfile();
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("Logout"),
          content: const Text(
            "Are you sure you want to logout?",
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor:
                      Theme.of(context).primaryColor,
                      side: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      Theme.of(context).primaryColor,
                      foregroundColor:
                      Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Logout"),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      await ref
          .read(authViewModelProvider.notifier)
          .logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(accountViewModelProvider);

    if (state.user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 16,
                  right: 16,
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showLogoutDialog(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor:
                      Theme.of(context).primaryColor,
                      side: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    icon: const Icon(
                      Icons.logout,
                      size: 20,
                    ),
                    label: const Text("Logout"),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  CircleAvatar(
                    radius: 45,
                    backgroundImage: NetworkImage(
                      "https://i.pravatar.cc/300",
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    state.user!.name,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(state.user!.bio),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,
                    children: [
                      countBox(
                        "${state.user!.postCount}",
                        "Posts",
                      ),
                      countBox(
                        "${state.user!.followerCount}",
                        "Followers",
                      ),
                      countBox(
                        "${state.user!.followingCount}",
                        "Following",
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),

            SliverPersistentHeader(
              pinned: true,
              delegate: TabHeader(
                TabBar(
                  controller: tabController,
                  labelColor:
                  Theme.of(context).primaryColor,
                  unselectedLabelColor:
                  Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color,
                  indicatorColor:
                  Theme.of(context).primaryColor,
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.grid_on),
                    ),
                    Tab(
                      text: "Followers",
                    ),
                    Tab(
                      text: "Following",
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: tabController,
          children: [
            PostsGrid(),
            const FollowersPage(),
            const FollowingPage(),
          ],
        ),
      ),
    );
  }

  Widget countBox(String count, String title) {
    return Column(
      children: [
        Text(
          count,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodyMedium,
        ),
      ],
    );
  }
}

class TabHeader extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  TabHeader(this.tabBar);

  @override
  Widget build(
      context,
      shrinkOffset,
      overlapsContent,
      ) {
    return Container(
      color: Theme.of(context).cardColor,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(oldDelegate) => false;
}

class PostsGrid extends ConsumerStatefulWidget {
  const PostsGrid({super.key});

  @override
  ConsumerState<PostsGrid> createState() => PostsGridState();
}

class PostsGridState
    extends ConsumerState<PostsGrid> {

  static const baseUrl = "http://localhost:8080";

  @override
  Widget build(BuildContext context) {
    final state =
    ref.watch(accountViewModelProvider);

    final posts = state.posts ?? [];

    if (posts.isEmpty) {
      return const Center(
        child: Text("No posts yet"),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(2),
      itemCount: posts.length,
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemBuilder: (context, index) {
        final post = posts[index];

        final fullImageUrl =
            baseUrl + post.imageUrl;

        return Image.network(
          fullImageUrl,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) {
            return Center(
              child: Icon(
                Icons.broken_image,
                color:
                Theme.of(context).primaryColor,
              ),
            );
          },
          loadingBuilder:
              (context, child, progress) {
            if (progress == null) {
              return child;
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );
      },
    );
  }
}

class FollowersPage extends ConsumerStatefulWidget {
  const FollowersPage({super.key});

  @override
  ConsumerState<FollowersPage> createState() =>
      FollowersPageState();
}

class FollowersPageState
    extends ConsumerState<FollowersPage> {

  @override
  Widget build(BuildContext context) {
    final state =
    ref.watch(accountViewModelProvider);

    final followers = state.followers ?? [];

    return ListView.builder(
      itemCount: followers.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              "https://i.pravatar.cc/150?img=${index + 1}",
            ),
          ),
          title: Text(
            followers[index].username,
          ),
          subtitle: const Text(
            "Following you",
          ),
          trailing: SizedBox(
            width: 80,
            height: 36,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
              ),
              onPressed: () {},
              child: const Text(
                "Remove",
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class FollowingPage extends ConsumerStatefulWidget {
  const FollowingPage({super.key});

  @override
  ConsumerState<FollowingPage> createState() =>
      FollowingPageState();
}

class FollowingPageState
    extends ConsumerState<FollowingPage> {

  @override
  Widget build(BuildContext context) {
    final state =
    ref.watch(accountViewModelProvider);

    final following = state.following ?? [];

    return ListView.builder(
      itemCount: following.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              "https://i.pravatar.cc/150?img=${index + 30}",
            ),
          ),
          title: Text(
            following[index].username,
          ),
          subtitle: const Text(
            "User account",
          ),
          trailing: SizedBox(
            width: 80,
            height: 36,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
              ),
              onPressed: () {},
              child: const Text(
                "Unfollow",
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}