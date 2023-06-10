import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/core/utils/constants/color_to_hex.dart';
import 'package:megas/core/utils/constants/consts.dart';
import 'package:megas/core/utils/constants/navigator.dart';
import 'package:megas/core/utils/constants/size_config.dart';
import 'package:megas/core/utils/custom_widgets/image_preview.dart';
import 'package:megas/src/controllers/likes.dart';
import 'package:megas/src/models/User.dart';
import 'package:megas/src/models/post.dart';
import 'package:megas/src/services/auth/auths_impl.dart';
import 'package:megas/src/services/notification/notification_impl.dart';
import 'package:megas/src/views/comments/comment.dart';
import 'package:megas/src/views/profile/profile_page.dart';
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
  Color _defaultLike_color = Colors.grey;
  bool isLiked  = false;

  _checkIfLiked(uid) async{
    final _post  =  await ref.watch(getLikesProvider(widget.post.postId));
    PostModel? _model = _post.value;
    if(_model != null)
      if(_model.likesCount.contains(uid)){
        if(mounted){
          setState(() {
            isLiked = true;
            _defaultLike_color = primary_color;
          });
        }
      } else{
        if(mounted){
          setState(() {
            isLiked = false;
            _defaultLike_color = Colors.grey;
          });
        }
      }
  }


  @override
  Widget build(BuildContext context) {
    String? uid = ref.watch(authProviderK).value?.uid;
    _checkIfLiked(uid);
    avatarAndname(){
      return SizedBox(
          child: Row(
            children: [
             widget.post.avatarUrl!.isNotEmpty  ?
            GestureDetector(
              onTap: (){
                push(context, ProfilePage(userId: widget.post.userId));
              },
              child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(widget.post.avatarUrl!),
          ),
            )
            :
            const CircleAvatar(
                radius: 30,
              ),
              const SizedBox(width: 4,),
              Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
          style: Theme.of(context).textTheme.displaySmall,
        ),
      );
    }

    media(){
      return GestureDetector(
        onTap: (){
          push(context, ImageViewScreen(
            imageProviderCategory: ImageProviderCategory.NetworkImage,
            imagePath: widget.post.postImageUrl,
          ));
        },
        child: Container(
          height: getProportionateScreenHeight(225),
          decoration: BoxDecoration(
            // shape: BoxShape.circle,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
              image: DecorationImage(image: NetworkImage(widget.post.postImageUrl), fit: BoxFit.cover)
          ),
        ),
      );
    }


    interactivity({VoidCallback? onTap}){

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
                   isLiked = !widget.post.likesCount.contains(userData?.id);
                  print('postId: ${widget.post.postId}');
                  // likesUpdateServicesProvider

                  await ref.read(likesProvider.notifier).likePost(postid: widget.post.postId,
                      likerId: userData!.id, liked: isLiked, post_owner: widget.post.userId);
                  print("ok2");
                  _checkIfLiked(uid);
                }, icon: Icon(Icons.thumb_up, color: _defaultLike_color,)),
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
                        comments: widget.post.comments, createdAt: widget.post.createdAt, likesCount: [],
                      userId: widget.post.userId,
                    ),
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
                color: Theme.of(context).cardColor,
                width: 2,
              )
            ),
            constraints: BoxConstraints(
              minWidth: 0.0,
              minHeight: 0.0,
              maxWidth: double.infinity,
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 12, bottom: 5, left: getProportionateScreenWidth(15), right: getProportionateScreenWidth(7)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  avatarAndname(), // name and avatar of post author
                  const SizedBox(height: 20,),
                  text(), /// string content of the post
                  const SizedBox(height: 3,),
                  widget.post.postImageUrl.isNotEmpty ? media() : SizedBox.shrink(), /// photos or videos
                  const SizedBox(height: 2,),
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
