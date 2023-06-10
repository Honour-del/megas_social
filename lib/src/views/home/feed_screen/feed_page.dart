import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:megas/core/utils/constants/color_to_hex.dart';
import 'package:megas/core/utils/constants/navigator.dart';
import 'package:megas/core/utils/constants/regex.dart';
import 'package:megas/core/utils/constants/size_config.dart';
import 'package:megas/core/utils/custom_widgets/alert_dialog.dart';
import 'package:megas/main.dart';
import 'package:megas/src/controllers/feeds.dart';
import 'package:megas/src/controllers/profile.dart';
import 'package:megas/src/services/auth/auths_impl.dart';
import 'package:megas/src/services/posts/interface.dart';
import 'package:megas/src/services/posts/posts_impl.dart';
import 'package:megas/src/services/shared_prefernces.dart';
import 'package:megas/src/views/Post/create_post.dart';
import 'package:megas/src/views/home/feed_screen/customs/drawer.dart';
import 'package:megas/src/views/home/feed_screen/customs/feeds.dart';
import 'package:megas/src/views/search/search_screen.dart';

Preferences? _prefs;

class FeedPage extends ConsumerStatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  ConsumerState<FeedPage> createState() => _FeedPageState();
}

final draw = GlobalKey();
CreatePostImpl impl = CreatePostImpl();
class _FeedPageState extends ConsumerState<FeedPage> {
   get() async{
    if (_prefs != null) {
      String? fcmToken = await _prefs!.getFCMToken();
      print("token: $fcmToken");
      return fcmToken;
    }
  }

  @override
  // void initState(){
  //    super.initState();
  //   initiatilization();
  // }
  //
  // initiatilization(){
  //    print('Removing splash');
  //   FlutterNativeSplash.remove();
  // }
   @override
  Widget build(BuildContext context) {

    final userDetails = ref.watch(userDetailProvider);
    final feed = ref.watch(newFeedProvider);
    final token = ref.watch(fcmTokenProvider).token;
    WidgetsBinding.instance.addPostFrameCallback((_) async{

      String? id = userDetails.value?.id;
      if(id != null)
        ref.read(profileControllerProvider(id).notifier)
            .updateProfile(json: {"fcm_token": token});
    });
    // get(id);
    print('done2');
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,////80
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        // iconTheme: IconThemeData(color: primary_color),
        // leading: Text('yes'),
        shadowColor: Colors.transparent,
        // title: Text('data'),
        flexibleSpace: FlexibleSpaceBar(
          titlePadding: EdgeInsets.only(right: 4, left: 6),
          title: Container(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(onPressed: (){
                    push(context, SearchScreen());
                  }, icon: FaIcon(FontAwesomeIcons.magnifyingGlass,
                      // color: primary_color
                  )),
                  SizedBox(width: getProportionateScreenWidth(50),),
                  Text(
                    "FEED",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  SizedBox(width: getProportionateScreenWidth(50),),
                  IconButton(onPressed: (){
                    push(context, MakePost());
                  }, icon: FaIcon(FontAwesomeIcons.pen,
                      // color: primary_color
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async{
          await ref.refresh(newFeedProvider.stream);
        },
        child: feed.when(data: (snapshot) {
          print(snapshot.length);
          if(snapshot.isEmpty){
            return Center(child: Text('''No data''', style: Theme.of(context).textTheme.bodyMedium,));
          }
          return Padding(
            padding: EdgeInsets.only(
              top: getProportionateScreenHeight(30),
            ),
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(color: Colors.grey, height: 15,),
              itemCount: snapshot.length,
              itemBuilder: (context, index){
                final _feeds = snapshot[index];
                return InkWell(
                  onLongPress: () {
                    _feeds.userId == userDetails.value!.id ?  showDialog<void>(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertBox(
                            del: (){
                              final del = ref.read(createpostServiceProvider);
                              del.deletePost(uId: userDetails.value!.id, postId: _feeds.postId);
                              Navigator.pop(context);
                            },
                            edit: (){},
                          );
                        }) : null;
                  },
                  child: FeedsView(
                    post: _feeds,
                  ),
                );
              },
            ),
          );
        }, error: (e,_)=> throw e, loading: ()=>kProgressIndicator),
      ),
      drawer: DrawerView(),
    );
  }
}
