import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tevo/blocs/blocs.dart';
import 'package:tevo/cubits/cubits.dart';
import 'package:tevo/enums/enums.dart';
import 'package:tevo/repositories/repositories.dart';
import 'package:tevo/screens/create_post/create_post_screen.dart';
import 'package:tevo/screens/feed/feed_screen.dart';
import 'package:tevo/screens/nav/cubit/bottom_nav_bar_cubit.dart';
import 'package:tevo/screens/notifications/bloc/notifications_bloc.dart';
import 'package:tevo/screens/notifications/notifications_screen.dart';

import '../create_post/bloc/create_post_bloc.dart';
import '../feed/bloc/feed_bloc.dart';

class NavScreen extends StatelessWidget {
  static const String routeName = '/nav';

  NavScreen({Key? key}) : super(key: key);

  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (_, __, ___) => BlocProvider<BottomNavBarCubit>(
        create: (_) => BottomNavBarCubit(),
        child: NavScreen(),
      ),
    );
  }

  final Map<BottomNavItem, dynamic> items = {
    BottomNavItem.feed: Container(
      height: 38,
      width: 38,
      decoration: BoxDecoration(
          color: const Color(0xffD8F3F1),
          borderRadius: BorderRadius.circular(8)),
      child: const Icon(
        Icons.home_outlined,
        size: 23,
        color: Color(0xff009688),
      ),
    ),
    BottomNavItem.create: Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
          color: const Color(0xff009688),
          borderRadius: BorderRadius.circular(10)),
      child: const Icon(
        Icons.add,
        color: Colors.white,
        size: 30,
      ),
    ),
    BottomNavItem.notifications: Container(
      height: 38,
      width: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: const Color(0xffD8F3F1),
          borderRadius: BorderRadius.circular(8)),
      child: const Icon(
        Icons.notifications_none_outlined,
        size: 23,
        color: Color(0xff009688),
      ),
    )
  };

  final Map<BottomNavItem, dynamic> screens = {
    BottomNavItem.feed: BlocProvider<FeedBloc>(
      create: (context) => FeedBloc(
        postRepository: context.read<PostRepository>(),
        authBloc: context.read<AuthBloc>(),
        likedPostsCubit: context.read<LikedPostsCubit>(),
        userRepository: context.read<UserRepository>(),
      )..add(FeedFetchPosts()),
      child: const FeedScreen(),
    ),
    BottomNavItem.create: BlocProvider<CreatePostBloc>(
      create: (context) => CreatePostBloc(
        userRepository: context.read<UserRepository>(),
        authBloc: context.read<AuthBloc>(),
        postRepository: context.read<PostRepository>(),
      )..add(const GetTaskEvent()),
      child: const CreatePostScreen(),
    ),
    BottomNavItem.notifications: BlocProvider<NotificationsBloc>(
      create: (context) => NotificationsBloc(
        notificationRepository: context.read<NotificationRepository>(),
        userRepository: context.read<UserRepository>(),
        authBloc: context.read<AuthBloc>(),
      ),
      child: const NotificationsScreen(),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xffE5E5E5),
              resizeToAvoidBottomInset: false,
              extendBody: true,
              body:
                  screens[context.read<BottomNavBarCubit>().state.selectedItem],
              bottomNavigationBar: _customisedBottomNavBar(context, state),
            ),
          );
        },
      ),
    );
  }

  void _selectBottomNavItem(
    BuildContext context,
    BottomNavItem selectedItem,
  ) {
    context.read<BottomNavBarCubit>().updateSelectedItem(selectedItem);
  }

  _customisedBottomNavBar(context, state) {
    return Container(
      height: 76,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            spreadRadius: 0,
            blurRadius: 10,
          ),
        ],
        color: Color(0xffFFFFFF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.zero,
          bottomRight: Radius.zero,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: items
            .map((item, icon) => MapEntry(
                item,
                Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    highlightColor: Colors.grey,
                    onTap: () {
                      _selectBottomNavItem(
                        context,
                        item,
                      );
                    },
                    child: icon,
                  ),
                )))
            .values
            .toList(),
      ),
    );
  }
}
