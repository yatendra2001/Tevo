import 'package:flutter/material.dart';
import 'package:tevo/screens/login/onboarding/add_profile_photo_screen.dart';
import 'package:tevo/screens/login/onboarding/dob_screen.dart';
import 'package:tevo/screens/login/onboarding/follow_users_screen.dart';
import 'package:tevo/screens/login/onboarding/registration_screen.dart';
import 'package:tevo/screens/login/onboarding/username_screen.dart';

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
      case WelcomeScreen.routeName:
        return WelcomeScreen.route();
      case LoginScreen.routeName:
        return LoginScreen.route();
      case OtpScreen.routeName:
        return OtpScreen.route();
      case RegistrationScreen.routeName:
        return RegistrationScreen.route();
      case UsernameScreen.routeName:
        return UsernameScreen.route();
      case DobScreen.routeName:
        return DobScreen.route();
      case AddProfilePhotoScreen.routeName:
        return AddProfilePhotoScreen.route();
      case FollowUsersScreen.routeName:
        return FollowUsersScreen.route();
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
