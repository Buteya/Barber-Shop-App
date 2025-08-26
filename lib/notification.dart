import 'package:flutter/material.dart.';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class Notification {
  String? id;
  String? userId;
  String? barberId;
  DateTime? notificationTime;

  Notification({
    @required id,
    @required userId,
    @required barberId,
    @required notificationTime,
  });

  // list of notifications
  List<Notification> notifications = [];

  // get all notifications
  List<Notification> allNotifications() {
    return notifications;
  }

  //create a new notification
  String newNotification(String barberId, String userId) {
    //check if values are empty
    if (barberId.isNotEmpty && userId.isNotEmpty) {
      // create new notification id
      final notificationId = Uuid().v4();
      //create new notification time
      final notificationTime = DateFormat(
        'EEE, MMM d, y hh:mm aaa',
      ).format(DateTime.now());
      // new notification constructor
      final newNotification = Notification(
        id: notificationId,
        userId: userId,
        barberId: barberId,
        notificationTime: notificationTime,
      );
      //add the new notification
      notifications.add(newNotification);
      //check if notification has been added successfully
      if (notifications.contains(newNotification)) {
        return 'notification created successfully';
      } else {
        return 'failed to create notification';
      }
    } else {
      return 'no empty values';
    }
  }

  //update notification
  String updateNotification(
    int index, [
    String? userId,
    String? barberId,
    DateTime? notificationTime,
  ]) {
    //check if notification exists
    if (notifications.contains(notifications[index])) {
      // update notification individual values
      notifications[index].userId = userId ?? notifications[index].userId;
      notifications[index].barberId = barberId ?? notifications[index].barberId;
      notifications[index].notificationTime =
          notificationTime ?? notifications[index].notificationTime;
      //check if update was a success
      if (notifications[index].userId == userId ||
          notifications[index].barberId == barberId ||
          notifications[index].notificationTime == notificationTime) {
        return 'notification was updated successfully';
      } else {
        return 'failed to update notification';
      }
    } else {
      return 'notification does not exist';
    }
  }

  //delete notification
  String deleteNotification(int index) {
    //check if notification exists
    if (notifications.contains(notifications[index])) {
      //delete notification
      notifications.remove(notifications[index]);
      //check if notification is deleted
      if (notifications.contains(notifications[index])) {
        return 'failed to delete notification';
      } else {
        return 'notification was deleted successfully';
      }
    } else {
      return 'notification does not exist';
    }
  }

  //delete all notifications
  String deleteAllNotification() {
    //check if notifications exists
    if (notifications.isNotEmpty) {
      notifications.clear();
      //check if notifications were deleted
      if (notifications.isNotEmpty) {
        return 'failed to delete notifications';
      } else {
        return 'notifications deleted successfully';
      }
    } else {
      return 'no notifications';
    }
  }
}
