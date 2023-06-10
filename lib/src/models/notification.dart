import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:megas/src/models/post.dart';




class NotificationModel {
  NotificationModel({
    required this.notificationId,
    required this.body,
    required this.postId,
    required this.type,
    this.followerId,
    required this.timeAt,
    required this.isRead,
    required this.name,
    required this.avatarUrl,
  });
  late final String notificationId;
  late final String body;
  late final String postId;
  late final type;
  String? followerId;
  late final Timestamp timeAt;
  late final bool isRead;
  late final PostModel model;
  late final String name;
  late final String avatarUrl;

  NotificationModel.fromJson(json) {
    notificationId = json['notification_id'];
    body = json['body'] ?? '';
    postId = json['post_id'] ?? '';
    type = json['_type'] ?? '';
    followerId = json['follower_id'] ?? '';
    timeAt = json['time_at'] ?? '';
    isRead = json['isRead'] ?? '';
    name = json['name'] ?? '';
    // model = PostModel.fromJson(json);
    avatarUrl = json['avatar_url'] ?? '';
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['notification_id'] = notificationId;
    data['body'] = body;
    data['post_id'] = postId;
    // data = model.toJson() ?? '';
    data['_type'] = type;
    data['follower_id'] = followerId;
    data['time_at'] = timeAt;
    data['isRead'] = isRead;
    data['name'] = name;
    data['avatar_url'] = avatarUrl;
    return data;
  }
}