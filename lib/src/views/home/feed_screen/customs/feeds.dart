import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/core/utils/constants/color_to_hex.dart';
import 'package:megas/core/utils/constants/navigator.dart';
import 'package:megas/core/utils/constants/size_config.dart';
import 'package:megas/core/utils/constants/uuid.dart';
import 'package:megas/main.dart';
import 'package:megas/src/controllers/likes.dart';
import 'package:megas/src/models/User.dart';
import 'package:megas/src/models/comments.dart';
import 'package:megas/src/models/post.dart';
import 'package:megas/src/services/auth/auths_impl.dart';
import 'package:megas/src/services/notification/notification_impl.dart';
import 'package:megas/src/views/comments/comment.dart';
import '../../../../services/likes/interface.dart';
import '../../../../services/notification/interface.dart';
import 'package:timeago/timeago.dart' as timeago;


class FeedsView extends ConsumerStatefulWidget {
  const FeedsView({Key? key,
    required this.post,
    // this.name, this.avatarUrl, this.text, this.contentImage, this.likesCounts, this.commentCounts,
  }) : super(key: key);
  final PostModel post;
  // TODO:

  @override
  ConsumerState<FeedsView> createState() => _FeedsViewState();
}

class _FeedsViewState extends ConsumerState<FeedsView> {
 // late final NotificationModel model;
  UserModel? currentUser;
  NotificationServiceImpl impl = NotificationServiceImpl();


  @override
  Widget build(BuildContext context) {

    avatarAndname(){
      return SizedBox(
          child: Row(
            children: [
              const CircleAvatar(
                radius: 30,
              ),
              const SizedBox(width: 3,),
              Column(
                children: [
                  Text(
                    widget.post.username ?? '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[900],
                    ),
                  ),
                  SizedBox(height: 2.5,),
                  Text(
                    timeago.format(widget.post.createdAt.toDate()),
                    style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
        ],
      ));
    }

    text(){
      return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          widget.post.caption,
          softWrap: true,
          // textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          maxLines: 20,
          style: TextStyle(
            fontSize: getFontSize(14),
            fontWeight: FontWeight.normal,
            color: Colors.grey[800],
          ),
        ),
      );
    }

    media(){
      return Container(
        height: getProportionateScreenHeight(225),
        decoration: BoxDecoration(
            // shape: BoxShape.circle,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
            image: DecorationImage(image: NetworkImage(widget.post.postImageUrl), fit: BoxFit.cover)
        ),
      );
    }


    bool like  = false;
    interactivity({VoidCallback? onTap}){
      // final isLiked = ref.watch(likesProvider(widget.post.postId));
      final userData = ref.watch(userDetailProvider).value;
      return Row(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                IconButton(onPressed: () async{
                  /// this should push to comment page
                  print("ok");
                  bool isLiked = !widget.post.likesCount.contains(userData?.id);
                  print('postId: ${widget.post.postId}');
                  await ref.read(likesUpdateServicesProvider).addLike(postid: widget.post.postId, likerid: userData!.id, liked: isLiked);
                  print("ok2");
                  if(isLiked)
                    setState(() {
                      like = isLiked;
                    });

                  final notify = ref.read(notificationServiceProviderK);
                  //
                  // String notificationId = uuid.v1();
                  // Map<String, dynamic> toJson() {
                  //   var data = <String, dynamic>{};
                  //   data['notification_id'] = notificationId;
                  //   data['body'] = impl.handleNotification(Type.Likes, userData.username);
                  //   data['post_id'] = widget.post.postId;
                  //   data['_type'] = Type.Likes;
                  //   data['time_at'] = dateTime;
                  //   data['isRead'] = false;
                  //   data['name'] = userData.username;
                  //   data['avatar_url'] = userData.avatarUrl;
                  //   return data;
                  // }
                  // await notify.sendNotification(toJson: toJson(), userToReceiveNotificationId: widget.post.userId);
                  print('like notification sent');
                }, icon: like ? Icon(Icons.thumb_up, color: primary_color,) : Icon(Icons.thumb_up, color: Colors.grey,) ),
                const SizedBox(width: 6.5,),
                Text(widget.post.likesCount.length.toString()),
              ],
            ),
          ),
          const SizedBox(width: 45,),
          Align(
            alignment: Alignment.center,
            child: Row(
              children: [
                IconButton(onPressed: (){
                  push(context, Comments(
                    post: PostModel(postId: widget.post.postId,
                        postImageUrl: widget.post.postImageUrl, caption: widget.post.caption,
                        comments: [], createdAt: widget.post.createdAt, likesCount: []),
                  ));
                }, icon: const Icon(Icons.comment, color: Colors.grey,)),
                const SizedBox(width: 6.5,),
                Text(widget.post.comments!.length.toString()),
              ],
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: onTap,
              child: Text("SHARE",
                style: TextStyle(
                  color: primary_color,
                  fontSize: 17
                ),
              ),
            ),
          )
        ],
      );
    }
    return SizedBox(
      // height: getProportionateScreenHeight(430), ///
      child: Padding(
        padding: EdgeInsets.only(top: 12, bottom: 14, left: getProportionateScreenWidth(20), right: getProportionateScreenWidth(10)),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          // these weren't there before
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                color: primary_color,
                width: 2,
              )
            ),
            constraints: BoxConstraints(
              minWidth: 0.0,
              minHeight: 0.0,
              maxWidth: double.infinity,
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 12, bottom: 12, left: getProportionateScreenWidth(15), right: getProportionateScreenWidth(7)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  avatarAndname(), // name and avatar of post author
                  const SizedBox(height: 20,),
                  text(), /// string content of the post
                  const SizedBox(height: 15,),
                  widget.post.postImageUrl.isNotEmpty ? media() : SizedBox.shrink(), /// photos or videos
                  const SizedBox(height: 20,),
                  interactivity(onTap: (){}), /// likes,comments count
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
