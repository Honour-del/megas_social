import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:megas/core/utils/constants/color_to_hex.dart';
import 'package:megas/core/utils/constants/navigator.dart';
import 'package:megas/core/utils/constants/regex.dart';
import 'package:megas/core/utils/constants/size_config.dart';
import 'package:megas/core/utils/constants/uuid.dart';
import 'package:megas/core/utils/custom_widgets/app_bar.dart';
import 'package:megas/core/utils/custom_widgets/buttons.dart';
import 'package:megas/main.dart';
import 'package:megas/src/controllers/profile.dart';
import 'package:megas/src/models/post.dart';
import 'package:megas/src/services/auth/auths_impl.dart';
import 'package:megas/src/services/notification/interface.dart';
import 'package:megas/src/services/notification/notification_impl.dart';
import 'package:megas/src/views/catalog/catalog_page.dart';
import 'package:megas/src/views/chat/chat_screen/chat_view.dart';
import 'package:megas/src/views/profile/edit_profile.dart';

class ProfilePage extends ConsumerStatefulWidget {
  final userId;
  // final username;
  const ProfilePage({Key? key, required this.userId,}) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}
bool isMyAccount = true;
bool isCertificated = true;
bool alreadyFollowing = false;
NotificationServiceImpl impl = NotificationServiceImpl();
class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    print('profile');
    String? uid = ref.watch(authProviderK).value?.uid;
    final profile = ref.watch(profileControllerProvider(uid!));
    print(uid);
    Column buildCountColumn(String label, int count) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '$count',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 4),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      );
    }


    followersAndpostCounts(postCounts, followerCounts, followingCounts, ){
      return Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              buildCountColumn( "posts", postCounts),
              buildCountColumn('follower', followerCounts),
              buildCountColumn('following', followingCounts),
            ],
          ),
        ],
      );
    }
    return Scaffold(
      appBar: appBar(context, 'Profile', false, true, widget: InkWell(onTap: (){
        push(context, const CatalogPage());
      },child: FaIcon(FontAwesomeIcons.cartShopping, color: primary_color,),)),
      body: Padding(padding: EdgeInsets.only(top: 50, left: getProportionateScreenWidth(15),right: getProportionateScreenWidth(20),),
      child: profile.when(data: (data)=> Column(
        children: [
          const Align(
            alignment: Alignment.topCenter,
            child: CircleAvatar(
              radius: 70,
            ),
          ),
          const SizedBox(height: 15,),
          Align(
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(data.username,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                SizedBox(width: 1.5,),
                isCertificated ? FaIcon(FontAwesomeIcons.certificate, color: primary_color, size: 15,) : SizedBox.shrink(),

              ],
            ),
          ),
          const SizedBox(height: 40,),

          // const SizedBox(height: 12,),

          followersAndpostCounts(data.postsCount.length, data.followingCount.length, data.followersCount.length),
          const SizedBox(height: 12,),
          /* If the user Id == current user's id then the edit-profile button will show else
          *  follow and unfollow but will show which means i'm in another persons profile  */
          if (widget.userId == uid) FlatButton(onTap: (){
            push(context,
                const EditProfile());
            print("edit profile");
          }, label: "Edit Profile") else friendsAccount(data.username),
          const SizedBox(height: 12,),
          postGridList(),
        ],
      ),
          error: (error, _)=> throw error,
          loading: ()=> kProgressIndicator),
      ),
    );
  }

  /* It will show this if i'm on another users account */
  friendsAccount(username,){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //// when to show follow and unfollow button on friend's profile
        alreadyFollowing ?
        FlatButton(onTap: ()async{
          // String? uid = ref.watch(authProviderK).value?.uid;
          final click = ref.read(profileControllerProvider(widget.userId).notifier);
          final notify = ref.read(notificationServiceProviderK);
          final userdata = ref.read(userDetailProvider).value;
          await click.follow();
          print("Follow");
          setState(() {
            alreadyFollowing = true;
            // if this is true it will return unfollow button
          });
          String notificationId = uuid.v1();
          Map<String, dynamic> toJson() {
            var data = <String, dynamic>{};
            data['notification_id'] = notificationId;
            data['body'] = impl.handleNotification(Type.Follower, userdata?.username);
            data['_type'] = Type.Follower;
            data['time_at'] = dateTime;
            data['isRead'] = false;
            data['name'] = userdata?.username;
            data['avatar_url'] = userdata?.avatarUrl;
            return data;
          }
          await notify.sendNotification(toJson: toJson(), userToReceiveNotificationId: widget.userId);
        }, label: "Follow", width: getProportionateScreenWidth(145),)
            : FlatButton(onTap: () async{
              // String? uid = ref.watch(authProviderK).value?.uid;
              final click = ref.read(profileControllerProvider(widget.userId).notifier);
              await click.unfollow();
              print("Unfollow");
          setState(() {
            alreadyFollowing = false;
            // if this is false it will return follow button
          });
        }, label: "Unfollow", width: getProportionateScreenWidth(145), textColor: Colors.black, color: Colors.transparent,),


        FlatButton(onTap: (){
          push(context, ChatDetailPage(username: username,)); //
        }, label: "Chat", width: getProportionateScreenWidth(145), textColor: Colors.black, color: Colors.transparent,),
      ],
    );
  }


  postGridList(){
    String? uid = ref.watch(authProviderK).value?.uid;
    return ref.watch(getUsersPostProvider(uid!)).when(
        data: (data){
          return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2
                // maxCrossAxisExtent: 400,
                // childAspectRatio: 1,
                // mainAxisSpacing: 20,
              ),
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: data.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index){
                final post = data[index];
                return postCard(post: post);
              }
          );
        },
        error: (e,_)=> throw e,
        loading: ()=> kProgressIndicator);
  }


  Widget postCard({PostModel? post}){
    return InkWell( // TODO: apply onTap function
      child: Container(
        height: 50,
        width: getProportionateScreenWidth(60),
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.all(
              color: primary_color,
              width: 2,
            ),
            image: DecorationImage(image: NetworkImage(post!.postImageUrl), fit: BoxFit.cover)
        ),
      ),
    );
  }
}
