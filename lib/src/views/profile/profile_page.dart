import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:megas/core/utils/constants/color_to_hex.dart';
import 'package:megas/core/utils/constants/consts.dart';
import 'package:megas/core/utils/constants/navigator.dart';
import 'package:megas/core/utils/constants/regex.dart';
import 'package:megas/core/utils/constants/size_config.dart';
import 'package:megas/core/utils/custom_widgets/app_bar.dart';
import 'package:megas/core/utils/custom_widgets/buttons.dart';
import 'package:megas/core/utils/custom_widgets/image_preview.dart';
import 'package:megas/src/controllers/profile.dart';
import 'package:megas/src/models/User.dart';
import 'package:megas/src/models/post.dart';
import 'package:megas/src/services/auth/auths_impl.dart';
import 'package:megas/src/services/notification/notification_impl.dart';
import 'package:megas/src/views/catalog/catalog_page.dart';
import 'package:megas/src/views/chat/screens/mobile_chat_screen.dart';
import 'package:megas/src/views/profile/edit_profile.dart';

class ProfilePage extends ConsumerStatefulWidget {
  final userId;

  const ProfilePage({Key? key, required this.userId,}) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}
bool isMyAccount = true;
bool isCertificated = false;
bool alreadyFollowing = false;
NotificationServiceImpl impl = NotificationServiceImpl();
class _ProfilePageState extends ConsumerState<ProfilePage> {

  _toggle(){
    setState(() {
      alreadyFollowing = !alreadyFollowing;
    });
  }

  _checkIfFollowing(uid, profile) async{
    // final profile  =  await ref.read(getProfile(widget.userId));
    UserModel? _model = profile.value;
    if(_model != null)
      if(_model.followersCount.contains(uid)){
        setState(() {
          alreadyFollowing = true;
        });
      }else{
        setState(() {
          alreadyFollowing = false;
        });
      }
  }
  @override
  Widget build(BuildContext context) {
    print('profile');
    String? uid = ref.watch(authProviderK).value?.uid;
    final profile = ref.watch(getProfile(widget.userId));
    _checkIfFollowing(uid, profile);
    Column buildCountColumn(String label, int count) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '$count',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Theme.of(context).primaryColorDark
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
        if(profile.value != null)
          push(context, CatalogPage(
            profileId: widget.userId,
            profileName: profile.value!.name,
          ));
        // push(context, const CatalogPage());
      },child: FaIcon(FontAwesomeIcons.cartShopping, color: primary_color,),)),
      body: Padding(padding: EdgeInsets.only(top: 50, left: getProportionateScreenWidth(15),right: getProportionateScreenWidth(20),),
      child: profile.when(data: (data)=> Column(
        children: [
          data.avatarUrl.isNotEmpty ? Align(
            alignment: Alignment.topCenter,
            child: GestureDetector(
              onTap: (){
                push(context, ImageViewScreen(
                  imageProviderCategory: ImageProviderCategory.NetworkImage,
                  imagePath: data.avatarUrl,
                ));
              },
              child: CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage(data.avatarUrl),
              ),
            ),
          ) : Align(
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
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(width: 1.5,),
                isCertificated ? FaIcon(FontAwesomeIcons.certificate, color: primary_color, size: 15,) : SizedBox.shrink(),

              ],
            ),
          ),
          const SizedBox(height: 40,),

          followersAndpostCounts(data.postsCount.length, data.followersCount.length, data.followingCount.length, ),

          const SizedBox(height: 12,),
          /* If the user Id == current user's id then the edit-profile button will show else
          *  follow and unfollow but will show which means i'm in another persons profile  */
          if (widget.userId == uid) FlatButtonCustom(onTap: (){
            push(context,
                 EditProfile());
            print("edit profile");
          }, label: "Edit Profile") else friendsAccount(data.username, data.avatarUrl),
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
  friendsAccount(username, profilePic){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //// when to show follow and unfollow button on friend's profile
        alreadyFollowing ?
             FlatButtonCustom(onTap: () async{
               String? uid = ref.read(authProviderK).value?.uid;
               final profile = ref.read(getProfile(widget.userId));
              final click = ref.read(profileControllerProvider(widget.userId).notifier);
              await click.unfollow();
              _checkIfFollowing(uid, profile);
              _toggle();
              print("Unfollow");
        }, label: "Unfollow", width: getProportionateScreenWidth(145), textColor: Colors.black, color: Colors.transparent,)
        : FlatButtonCustom(onTap: () async{
          final click = ref.read(profileControllerProvider(widget.userId).notifier);
          String? uid = ref.read(authProviderK).value?.uid;
          final profile = ref.read(getProfile(widget.userId));
          /* User to be followed */
          UserModel? owner = await ref.watch(getProfile(widget.userId)).value;
          await click.follow(owner);
          _checkIfFollowing(uid, profile);
          _toggle();
          print("Follow");
        }, label: "Follow", width: getProportionateScreenWidth(145),),


        FlatButtonCustom(onTap: (){
          push(context, MobileChatScreen(name: username, uid: widget.userId, isGroupChat: false, profilePic: profilePic));
          // push(context, ChatDetailPage(username: username, receiverId: widget.userId,)); //
        }, label: "Chat", width: getProportionateScreenWidth(145), textColor: Colors.black, color: Colors.transparent,),
      ],
    );
  }


  postGridList(){
    // String? uid = ref.watch(authProviderK).value?.uid;
    return ref.watch(getUsersPostProvider(widget.userId)).when(
        data: (data){
          return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell( // TODO: apply onTap function
        child: Container(
          height: 40,
          // width: getProportionateScreenWidth(40),
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(
                color: primary_color,
                width: 2,
              ),
              image: (post!.postImageUrl.isNotEmpty) ?  DecorationImage(image: NetworkImage(post.postImageUrl), fit: BoxFit.cover) : null,
          ),
          child: Center(child: Text(
              (post.postImageUrl.isEmpty) ? '${post.caption}' : '',
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).primaryColorDark),
          ),),
        ),
      ),
    );
  }
}
