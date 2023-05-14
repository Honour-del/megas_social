import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:megas/core/utils/constants/regex.dart';
import 'package:megas/core/utils/constants/uuid.dart';
import 'package:megas/core/utils/custom_widgets/app_bar.dart';
import 'package:megas/main.dart';
import 'package:megas/src/controllers/comments.dart';
import 'package:megas/src/controllers/likes.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:megas/src/models/post.dart';
import 'package:megas/src/services/auth/auths_impl.dart';
import 'package:megas/src/services/comments/comment_interface.dart';
import 'package:megas/src/services/notification/notification_impl.dart';
import '../../services/notification/interface.dart';

class Comments extends ConsumerStatefulWidget {
  final PostModel? post;

  Comments({this.post});

  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends ConsumerState<Comments> {
  // UserModel? user;
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
      appBar: appBar(context, 'Comments', false, true),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
          //   child: buildFullPost(),
          // ),
          // Divider(thickness: 1.5),
          buildComments(),
          if(loading) // TODO:
            Center(child: kProgressIndicator,),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                constraints: BoxConstraints(
                  maxHeight: 190.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible( // Todo:
                      child: ListTile(
                        contentPadding: EdgeInsets.all(0),
                        title: TextField(
                          textCapitalization: TextCapitalization.sentences,
                          controller: commentsTEC,
                          style: TextStyle(
                            fontSize: 15.0,
                            color:
                                Theme.of(context).textTheme.headline6!.color,
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
                                color:
                                    Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    Theme.of(context).colorScheme.secondary,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            hintText: "Write your comment...",
                            hintStyle: TextStyle(
                              fontSize: 15.0,
                              color: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .color,
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
                            final _user =ref.read(userDetailProvider).value;
                            print("user details retrieved");
                            ref.read(commentServiceProvider).addComment(postId: widget.post!.postId,
                                commenterUserId: _user!.id, comment: commentsTEC.text, type: cType.Text, displayName: _user.name, userName: _user.username, photoUrl: _user.avatarUrl);
                            print('About to send notification');
                            final notify = ref.read(notificationServiceProviderK);

                            String notificationId = uuid.v1();
                            Map<String, dynamic> toJson() {
                              var data = <String, dynamic>{};
                              data['notification_id'] = notificationId;
                              data['body'] = impl.handleNotification(Type.Follower, _user.username);
                              data['post_id'] = widget.post!.postId;
                              data['_type'] = Type.Comments;
                              data['time_at'] = dateTime;
                              data['isRead'] = false;
                              data['name'] = _user.username;
                              data['avatar_url'] = _user.avatarUrl;
                              return data;
                            }
                            await notify.sendNotification(toJson: toJson(), userToReceiveNotificationId: widget.post!.userId);
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildFullPost() {
    // postID = widget.post!.postId;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 250.0,
          width: MediaQuery.of(context).size.width - 20.0,
          decoration: BoxDecoration(
            // shape: BoxShape.circle,
              color: Colors.grey,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
              image: DecorationImage(image: NetworkImage(widget.post!.postImageUrl), fit: BoxFit.cover)
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.post?.caption ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      Text(
                        timeago.format(widget.post!.createdAt.toDate()),
                        style: TextStyle(
                          fontSize: 17
                        ),
                      ),
                      SizedBox(width: 3.0),

                      buildLikesCount(context),
                      // StreamBuilder(
                      //   stream: stream,
                      //   // stream: likesRef
                      //   //     .where('postId', isEqualTo: widget.post!.postId)
                      //   //     .snapshots(),
                      //   builder:
                      //       (context, AsyncSnapshot snapshot) {
                      //     if (snapshot.hasData) {
                      //       var snap = snapshot.data!;
                      //       List docs = snap.docs;
                      //       return buildLikesCount(context, docs.length ?? 0);
                      //     } else {
                      //       return buildLikesCount(context, 0);
                      //     }
                      //   },
                      // ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              buildLikeButton(),
            ],
          ),
        ),
      ],
    );
  }

  buildComments() {
    var comment  = ref.watch(commentProvider(widget.post?.postId ?? ''));
    String? uid = ref.read(authProviderK).value?.uid;
    return comment.when(
        data: (data) => SizedBox(
          height: 200,
          child: ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (context, index) => Divider(),
            itemCount: data.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index){
              return GestureDetector(
                onLongPress: (){
                  showDialog<void>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Delete?"),
                          content: const Text("Do you want to delete this event?"),
                          actions: [
                            InkWell(
                              child: const Text("No",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            InkWell(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                                child: const Text(
                                  "Yes",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              onTap: () {
                                // TODO :
                                /// if the uid of the comment == currentUser id
                                print("deleting this comment");
                                if(data[index].commenterUserId == uid){
                                  ref.read(commentServiceProvider).deleteComments(userId: data[index].commenterUserId,
                                      commentId: data[index].commentId);
                                }
                                Navigator.pop(context);
                              },
                            )
                          ],
                        );
                      });
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                        // color: primary_color,
                        width: 2,
                      )
                  ),
                  constraints: BoxConstraints(
                    minWidth: 0.0,
                    minHeight: 0.0,
                    maxWidth: double.infinity,
                  ),
                  child: Column(
                    crossAxisAlignment: (data[index].commenterUserId == uid) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20.0,
                            backgroundImage: NetworkImage(data[index].avatarUrl!),
                          ),
                          SizedBox(width: 4,),
                          Column(
                            children: [
                              Text(
                                data[index].username!,
                                style: TextStyle(fontSize: 18, color: Colors.grey[900]),
                              ),
                              SizedBox(height: 2.5,),
                              Text(
                                data[index].commentCreatedAt!,
                                style: TextStyle(fontSize: 16.0, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 3,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          data[index].comment!,
                          style: TextStyle(fontWeight: FontWeight.w400,),
                        ),
                      ),
                    ],
                  ),
                ),
              );
              },
          ),
        ),
        error: (e, st) => Padding(
            padding: const EdgeInsets.only(right: 30),
            child: Center(child: IsEmpty(err: e.toString(),),),
        ),
        loading: ()=> const Center(child: CircularProgressIndicator()));
  }

  buildLikeButton() {
    return SizedBox.shrink();
    // return IconButton(
    //   onPressed: () {
    //     if (docs.isEmpty) {
    //       likesRef.add({
    //         'userId': currentUserId(),
    //         'postId': widget.post!.postId,
    //         'dateCreated': Timestamp.now(),
    //       });
    //       addLikesToNotification();
    //     } else {
    //       likesRef.doc(docs[0].id).delete();
    //
    //       removeLikeFromNotification();
    //     }
    //   },
    //   icon: docs.isEmpty
    //       ? Icon(
    //           CupertinoIcons.heart,
    //         )
    //       : Icon(
    //           CupertinoIcons.heart_fill,
    //           color: Colors.red,
    //         ),
    // );
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

  addLikesToNotification() async {
    // bool isNotMe = currentUserId() != widget.post!.ownerId;
    //
    // if (isNotMe) {
      // DocumentSnapshot doc = await usersRef.doc(currentUserId()).get();
      // user = UserModel.fromJson(doc.data() as Map<String, dynamic>);
      // notificationRef
      //     .doc(widget.post!.ownerId)
      //     .collection('notifications')
      //     .doc(widget.post!.postId)
      //     .set({
      //   "type": "like",
      //   "username": user!.username!,
      //   "userId": currentUserId(),
      //   "userDp": user!.photoUrl!,
      //   "postId": widget.post!.postId,
      //   "mediaUrl": widget.post!.mediaUrl,
      //   "timestamp": timestamp,
      // });
    // }
  }

  removeLikeFromNotification() async {
    // bool isNotMe = currentUserId() != widget.post!.ownerId;

    // if (isNotMe) {
      // DocumentSnapshot doc = await usersRef.doc(currentUserId()).get();
      // user = UserModel.fromJson(doc.data() as Map<String, dynamic>);
      // notificationRef
      //     .doc(widget.post!.ownerId)
      //     .collection('notifications')
      //     .doc(widget.post!.postId)
      //     .get()
      //     .then((doc) => {
      //           if (doc.exists) {doc.reference.delete()}
      //         });
    }
  // }
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
