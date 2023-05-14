import 'dart:convert';

class CommentModel {
  CommentModel({
    required this.commenterUserId,
     this.postId,
     this.comment,
     this.commentCreatedAt,
    required this.commentId,
     this.username,
     this.name,
     this.avatarUrl,
  });
  late final String commenterUserId;
  late String? postId;
  late String? comment;
  late String? commentCreatedAt;
  late final String commentId;
  late String? username;
  late String? name;
  late  String? avatarUrl;

  CommentModel.fromJson(Map<String, dynamic> json) {
    commenterUserId = json['commenter_user_id'];
    postId = json['post_id'];
    comment = json['comment'];
    commentCreatedAt = json['comment_created_at'];
    commentId = json['comment_id'];
    username = json['username'];
    name = json['name'];
    avatarUrl = json['avatar_url'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['commenter_user_id'] = commenterUserId;
    _data['post_id'] = postId;
    _data['comment'] = comment;
    _data['comment_created_at'] = commentCreatedAt;
    _data['comment_id'] = commentId;
    _data['username'] = username;
    _data['name'] = name;
    _data['avatar_url'] = avatarUrl;
    return _data;
  }

  CommentModel geFromJson(dynamic json){///Json
    Map<String, dynamic> data = jsonDecode(json);

    return CommentModel.fromJson(data);
    //// use this to get json data
  }
}


class LikesModel
{
  late final postId;

}