import 'package:flutter/material.dart';

import 'package:tevo/screens/screens.dart';
import 'package:tevo/screens/stream_chat/ui/stream_chat_inbox.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print('Route: ${settings.name}');
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/'),
          builder: (_) => const Scaffold(),
        );
      case SplashScreen.routeName:
        return SplashScreen.route();
      case AuthScreen.routeName:
        return AuthScreen.route();
      case NavScreen.routeName:
        return NavScreen.route();
      case ProfileScreen.routeName:
        return ProfileScreen.route(
          args: settings.arguments as ProfileScreenArgs,
        );

      case EditProfileScreen.routeName:
        return EditProfileScreen.route(
          args: settings.arguments as EditProfileScreenArgs,
        );
      case SearchScreen.routeName:
        return SearchScreen.route();
      case CommentsScreen.routeName:
        return CommentsScreen.route(
          args: settings.arguments as CommentsScreenArgs,
        );
      case ChannelScreen.routeName:
        return ChannelScreen.route(
          args: settings.arguments as ChannelScreenArgs,
        );
      case StreamChatInbox.routeName:
        return StreamChatInbox.route();
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Something went wrong!'),
        ),
      ),
    );
  }
}
