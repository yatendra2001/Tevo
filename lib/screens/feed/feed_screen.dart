import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tevo/cubits/cubits.dart';
import 'package:tevo/screens/feed/bloc/feed_bloc.dart';
import 'package:tevo/widgets/widgets.dart';

class FeedScreen extends StatefulWidget {
  static const String routeName = '/feed';

  const FeedScreen();

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset >=
                _scrollController.position.maxScrollExtent &&
            !_scrollController.position.outOfRange &&
            context.read<FeedBloc>().state.status != FeedStatus.paginating) {
          context.read<FeedBloc>().add(FeedPaginatePosts());
        }
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FeedBloc, FeedState>(
      listener: (context, state) {
        if (state.status == FeedStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(content: state.failure.message),
          );
        } else if (state.status == FeedStatus.paginating) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).primaryColor,
              duration: const Duration(seconds: 1),
              content: const Text('Fetching More Posts...'),
            ),
          );
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'TEVO',
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                if (state.posts.isEmpty && state.status == FeedStatus.loaded)
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () =>
                        context.read<FeedBloc>().add(FeedFetchPosts()),
                  )
              ],
            ),
            body: _buildBody(state),
          ),
        );
      },
    );
  }

  Widget _buildBody(FeedState state) {
    switch (state.status) {
      case FeedStatus.loading:
        return const Center(child: CircularProgressIndicator());
      default:
        return RefreshIndicator(
          onRefresh: () async {
            context.read<FeedBloc>().add(FeedFetchPosts());
            context.read<LikedPostsCubit>().clearAllLikedPosts();
          },
          child: ListView.builder(
            controller: _scrollController,
            itemCount: state.posts.length,
            itemBuilder: (BuildContext context, int index) {
              final post = state.posts[index];
              // final likedPostsState = context.watch<LikedPostsCubit>().state;
              // final isLiked = likedPostsState.likedPostIds.contains(post!.id);
              // final recentlyLiked =
              //     likedPostsState.recentlyLikedPostIds.contains(post.id);
              return PostView(
                post: post!,
              );
            },
          ),
        );
    }
  }
}
