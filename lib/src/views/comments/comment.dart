import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/core/utils/constants/color_to_hex.dart';
import 'package:megas/core/utils/constants/navigator.dart';
import 'package:megas/core/utils/constants/regex.dart';
import 'package:megas/core/utils/constants/size_config.dart';
import 'package:megas/core/utils/custom_widgets/alert_dialog.dart';
import 'package:megas/core/utils/custom_widgets/app_bar.dart';
import 'package:megas/src/controllers/comments.dart';
import 'package:megas/src/views/profile/profile_page.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:megas/src/models/post.dart';
import 'package:megas/src/services/auth/auths_impl.dart';
import 'package:megas/src/services/notification/notification_impl.dart';

class Comments extends ConsumerStatefulWidget {
  final PostModel? post;

  Comments({this.post});

  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends ConsumerState<Comments> {
  bool myComment = false;
  NotificationServiceImpl impl = NotificationServiceImpl();
  // PostService services = PostService();
  final DateTime timestamp = DateTime.now();
  TextEditingController commentsTEC = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    // final comments  = ref.watch(commentProvider);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: appBar(context, 'Comments', false, true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildComments(),
          if(loading) // TODO:
            Center(child: kProgressIndicator,),
          commentField(),
        ],
      ),
    );
  }


  commentField(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          constraints: BoxConstraints(
            maxHeight: 190.0,
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(0),
            title: TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: commentsTEC,
              style: TextStyle(
                fontSize: 15.0,
                // color:
                // Theme.of(context).textTheme.titleLarge!.color,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color:
                    Theme.of(context).colorScheme.secondary,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color:
                    Theme.of(context).colorScheme.secondary,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: primary_color,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                hintText: "Write your comment...",
                hintStyle: TextStyle(
                  fontSize: 15.0,
                  // color: ,
                ),
              ),
              maxLines: null,
            ),
            trailing: GestureDetector(
              onTap: () async {
                setState(() {
                  loading = true;
                });
                print('About to send comment');
                final _user = ref.read(userDetailProvider).value;
                print("postOwner: ${widget.post!.userId}");
                print("user details retrieved");
                ref.read(commentProvider.notifier).addComment(postId: widget.post!.postId,
                    commenterUserId: _user!.id, comment: commentsTEC.text, displayName: _user.name, userName: _user.username, photoUrl: _user.avatarUrl,
                  postOwner: widget.post!.userId,
                );
                commentsTEC.clear();
                setState(() {
                  loading = false;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Icon(
                  Icons.send,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  final ScrollController messageController = ScrollController();

 Widget buildComments() {
    final comment  = ref.watch(getCommentProvider(widget.post!.postId));
    String? uid = ref.read(authProviderK).value?.uid;
    return comment.when(
        data: (data) => ListView.separated(
          controller: messageController,
          shrinkWrap: true,
          separatorBuilder: (context, index) => Divider(),
          itemCount: data.length,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index){
            return GestureDetector(
              onLongPress: (){
                data[index].commenterUserId == uid ? showDialog<void>(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertBox(
                        titleText: 'Wanna delete this comment?',
                        del: (){
                            ref.read(commentProvider.notifier).deleteComments(userId: data[index].commenterUserId,
                                commentId: data[index].commentId);
                            if(kDebugMode)print("Comment deleted");
                          Navigator.pop(context);
                        },
                      );
                    }) : null;
              },
              child: Padding(
                padding: EdgeInsets.only(left: getProportionateScreenWidth(20), right: getProportionateScreenWidth(20),),
                child: Row(
                  children: [
                    data[index].avatarUrl!.isNotEmpty ?
                    GestureDetector(
                      onTap: (){
                        push(context, ProfilePage(userId: data[index].commenterUserId));
                      },
                      child: CircleAvatar(
                        radius: 20.0,
                        backgroundImage: NetworkImage(data[index].avatarUrl!),
                      ),
                    ) : CircleAvatar(radius: 20.0,),
                    SizedBox(width: 4,),
                    SizedBox(width: 3,),
                    Container(
                      padding: const EdgeInsets.fromLTRB(12, 13, 12, 11),
                      margin:
                      EdgeInsets.symmetric(vertical: getProportionateScreenHeight(10)),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.15),
                              blurRadius: 5,
                            ),
                          ]),
                      constraints: BoxConstraints(
                        minWidth: 0.0,
                        minHeight: 0.0,
                        maxWidth: double.infinity,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data[index].name!,
                                style: TextStyle(fontSize: 16.5, color: Colors.grey[900]),
                              ),
                              SizedBox(height: 2.5,),
                              Text(
                                timeago.format(data[index].commentCreatedAt!.toDate()),
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 12.0, color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0.0),
                            child: Text(
                              data[index].comment!,
                              style: TextStyle(fontWeight: FontWeight.w400,),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        error: (e, st) => throw e,
        // error: (e, st) => Center(child: CustomErrorWidget(err: e.toString(),),),
        loading: ()=> const Center(child: CircularProgressIndicator()));
  }

  buildLikesCount(BuildContext context) {
    // var stream = ref.watch(likesProvider(widget.post?.postId).notifier).getLikes();
    return Padding(
      padding: const EdgeInsets.only(left: 7.0),
      child: Text(
        "",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 10.0,
        ),
      ),
    );
  }
}




typedef ItemBuilder<T> = Widget Function(
    BuildContext context,
    Object?
    );

class CommentsStreamWrapper extends StatelessWidget {
  final Stream<List<Object?>>? stream;
  final ItemBuilder itemBuilder;
  final Axis scrollDirection;
  final bool shrinkWrap;
  final ScrollPhysics physics;
  final EdgeInsets padding;

  const CommentsStreamWrapper({
    Key? key,
    required this.stream,
    required this.itemBuilder,
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = false,
    this.physics = const ClampingScrollPhysics(),
    this.padding = const EdgeInsets.only(bottom: 2.0, left: 2.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var list = snapshot.data!.toList();
          return list.length == 0
              ? Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text('No comments'),
              ),
            ),
          )
              : ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 0.5,
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: const Divider(),
                ),
              );
            },
            reverse: true,
            padding: padding,
            scrollDirection: scrollDirection,
            itemCount: list.length,
            shrinkWrap: shrinkWrap,
            physics: physics,
            itemBuilder: (BuildContext context, int index) {
              return itemBuilder(context, list[index]);
            },
          );
        } else {
          return kProgressIndicator;
        }
      },
    );
  }
}
