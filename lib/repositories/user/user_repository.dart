import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tevo/config/paths.dart';
import 'package:tevo/enums/enums.dart';
import 'package:tevo/models/models.dart';
import 'package:tevo/models/user_model.dart';
import 'package:tevo/repositories/repositories.dart';
import 'package:tevo/widgets/widgets.dart';

class UserRepository extends BaseUserRepository {
  final FirebaseFirestore _firebaseFirestore;

  UserRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<User> getUserWithId({required String userId}) async {
    final doc =
        await _firebaseFirestore.collection(Paths.users).doc(userId).get();
    return doc.exists ? User.fromDocument(doc) : User.empty;
  }

  @override
  Future<void> updateUser({required User user}) async {
    await _firebaseFirestore
        .collection(Paths.users)
        .doc(user.id)
        .update(user.toDocument());
  }

  @override
  Future<List<User>> searchUsers({required String query}) async {
    final userSnap = await _firebaseFirestore
        .collection(Paths.users)
        .where('username', isGreaterThanOrEqualTo: query)
        .get();
    return userSnap.docs.map((doc) => User.fromDocument(doc)).toList();
  }

  @override
  Future<bool> searchUserbyPhone(
      {required String query, required bool newAccount}) async {
    try {
      return await _firebaseFirestore
          .collection(Paths.users)
          .where("phoneNumber", isEqualTo: query)
          .snapshots()
          .isEmpty;
    } on FirebaseException catch (err) {
      if (err.code == 'permission-denied') {
        flutterToast(
            msg: newAccount ? 'New Account' : 'Account does not exists',
            position: ToastGravity.CENTER);
      } else {
        flutterToast(msg: 'An Error occured', position: ToastGravity.CENTER);
      }
    } catch (err) {
      flutterToast(msg: 'An Error occured', position: ToastGravity.CENTER);
    }
    return true;
  }

  @override
  void followUser({
    required String userId,
    required String followUserId,
  }) {
    // Add followUser to user's userFollowing.
    _firebaseFirestore
        .collection(Paths.following)
        .doc(userId)
        .collection(Paths.userFollowing)
        .doc(followUserId)
        .set({});
    // Add user to followUser's userFollowers.
    _firebaseFirestore
        .collection(Paths.followers)
        .doc(followUserId)
        .collection(Paths.userFollowers)
        .doc(userId)
        .set({});

    final notification = Notif(
      type: NotifType.follow,
      fromUser: User.empty.copyWith(id: userId),
      date: DateTime.now(),
    );

    _firebaseFirestore
        .collection(Paths.notifications)
        .doc(followUserId)
        .collection(Paths.userNotifications)
        .add(notification.toDocument());
  }

  @override
  void unfollowUser({
    required String userId,
    required String unfollowUserId,
  }) {
    // Remove unfollowUser from user's userFollowing.
    _firebaseFirestore
        .collection(Paths.following)
        .doc(userId)
        .collection(Paths.userFollowing)
        .doc(unfollowUserId)
        .delete();
    // Remove user from unfollowUser's userFollowers.
    _firebaseFirestore
        .collection(Paths.followers)
        .doc(unfollowUserId)
        .collection(Paths.userFollowers)
        .doc(userId)
        .delete();
  }

  @override
  Future<bool> isFollowing({
    required String userId,
    required String otherUserId,
  }) async {
    // is otherUser in user's userFollowing
    final otherUserDoc = await _firebaseFirestore
        .collection(Paths.following)
        .doc(userId)
        .collection(Paths.userFollowing)
        .doc(otherUserId)
        .get();
    return otherUserDoc.exists;
  }
}
