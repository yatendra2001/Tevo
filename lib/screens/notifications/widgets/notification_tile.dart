import 'package:flutter/material.dart';
import 'package:tevo/enums/enums.dart';
import 'package:tevo/models/models.dart';
import 'package:tevo/screens/screens.dart';
import 'package:tevo/widgets/widgets.dart';
import 'package:intl/intl.dart';

class NotificationTile extends StatelessWidget {
  final Notif notification;

  const NotificationTile({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: UserProfileImage(
        radius: 18.0,
        profileImageUrl: notification.fromUser.profileImageUrl,
      ),
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: notification.fromUser.username,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            const TextSpan(text: ' '),
            TextSpan(text: _getText(notification)),
          ],
        ),
      ),
      subtitle: Text(
        DateFormat.yMd().add_jm().format(notification.date),
        style: TextStyle(
          color: Colors.grey[600],
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: _getTrailing(context, notification),
      onTap: () => Navigator.of(context).pushNamed(
        ProfileScreen.routeName,
        arguments: ProfileScreenArgs(userId: notification.fromUser.id),
      ),
    );
  }

  String _getText(Notif notification) {
    switch (notification.type) {
      case NotifType.like:
        return 'liked your post.';
      case NotifType.comment:
        return 'commented on your post.';
      case NotifType.follow:
        return 'followed you.';
      default:
        return '';
    }
  }

  Widget _getTrailing(BuildContext context, Notif notif) {
    if (notification.type == NotifType.like ||
        notification.type == NotifType.comment) {
      // return GestureDetector(
      //   onTap: () => Navigator.of(context).pushNamed(
      //     CommentsScreen.routeName,
      //     arguments: CommentsScreenArgs(post: notification.post!),
      //   ),
      //   child: SizedBox(
      //     height: 60,
      //     width: 60,
      //     child: PostView(post: notification.post!),
      //   ),
      // );
    } else if (notification.type == NotifType.follow) {
      return const SizedBox(
        height: 60.0,
        width: 60.0,
        child: Icon(Icons.person_add),
      );
    }
    return const SizedBox.shrink();
  }
}
