import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:megas/src/models/comments.dart';

class PostModel {
  PostModel({
    required this.postId,
    required this.postImageUrl,
    required this.caption,
    required this.comments,
     this.commentCounts,
    required this.createdAt,
    required this.likesCount,
     this.username,
     this.name,
    this.avatarUrl,
    this.userId
  });
  late final String postId;
  late final String postImageUrl;
  late final String caption;
  late final String? userId;
  late final Timestamp createdAt;
  late final List<dynamic> likesCount; /* Just changed it to lIst dynamic */
  late List<CommentModel>? comments;
  late final commentCounts;
  late String? username;
  late String? name;
  late String? avatarUrl;



  /* The initial error was because of 'late' initializer error  */
  PostModel.fromJson(json) {
    /// mapping comments into the post
    // final commentJsons = json['comments'] as List<dynamic>?;

    // comments = commentJsons?.map((commentJson) => CommentModel.fromJson(commentJson)).toList();

    postId = json['post_id'] ?? '';
    postImageUrl = json['post_image_url'] ?? '';
    caption = json['caption'] ?? '';
    userId = json['user_id'] ?? '';
    createdAt = json['posted_at'] ?? Timestamp.now();
    likesCount = json['likes'] ?? [];
    comments =  [];
    commentCounts = json['commentCounts'] ?? [];
    username = json['username'] ?? '';
    name = json['name'] ?? '';
    avatarUrl = json['avatar_url'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['post_id'] = postId;
    data['post_image_url'] = postImageUrl;
    data['caption'] = caption;
    data['user_id'] = userId!;
    // data['comments'] = comments!.map((comment) => comment.toJson());
    data['comments'] = comments!.map((comment) => comment.toJson());
    data['posted_at'] = createdAt;
    data['likes'] = likesCount;
    data['commentCounts'] = comments!.length;
    data['username'] = username;
    data['name'] = name;
    data['avatar_url'] = avatarUrl;
    return data;
  }
  PostModel geFromJson(dynamic json){///Json
    Map<String, dynamic> data = jsonDecode(json);

    return PostModel.fromJson(data);
    //// use this to get json data
  }
}