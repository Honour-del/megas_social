//
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:megas/src/models/comments.dart';
// import 'package:megas/src/models/post.dart';
//
// class Feedm extends PostModel{
//   Feedm({required super.postId, required super.postImageUrl, required super.caption, required super.comments, required super.commentCounts, required super.createdAt, required super.likesCount, required super.username, required super.name, required super.avatarUrl});
//
//   factory Feedm.fromJson(DocumentSnapshot json){
//     return Feedm(postId: 'postId', postImageUrl: 'postImageUrl', caption: 'caption', comments: 'comments' as List<CommentModel>, commentCounts: 'commentCounts', createdAt: 'createdAt', likesCount: 'likesCount', username: 'username', name: 'name', avatarUrl: 'avatarUrl');
//   }
// }