import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:megas/core/utils/constants/color_to_hex.dart';
import 'package:megas/core/utils/constants/navigator.dart';
import 'package:megas/core/utils/constants/regex.dart';
import 'package:megas/core/utils/constants/size_config.dart';
import 'package:megas/src/controllers/feeds.dart';
import 'package:megas/src/models/User.dart';
import 'package:megas/src/models/post.dart';
import 'package:megas/src/services/auth/auths_impl.dart';
import 'package:megas/src/services/posts/posts_impl.dart';
import 'package:megas/src/views/Post/create_post.dart';
import 'package:megas/src/views/home/feed_screen/customs/drawer.dart';
import 'package:megas/src/views/home/feed_screen/customs/feeds.dart';
import 'package:megas/src/views/search/search_screen.dart';


class FeedPageK extends ConsumerStatefulWidget {
  const FeedPageK({Key? key}) : super(key: key);

  @override
  ConsumerState<FeedPageK> createState() => _FeedPageKState();
}

final draw = GlobalKey();
CreatePostImpl impl = CreatePostImpl();
class _FeedPageKState extends ConsumerState<FeedPageK> {
  @override
  Widget build(BuildContext context) {
    final userDetails = ref.watch(userDetailProvider);

    // final feed = ref.watch(newFeedProvider);
    final suggestions = ref.watch(shuffledItemsProvider);
    // test(){
    //   // return suggestions.
    // }

    // print('Feed detail: ${feed.first.}');
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,////80
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: primary_color),
        // leading: Text('yes'),
        shadowColor: Colors.transparent,
        flexibleSpace: Center(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 32.5,
              left: 20,
              // right: 10
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(onPressed: (){
                  push(context, SearchScreen());
                }, icon: FaIcon(FontAwesomeIcons.magnifyingGlass, color: primary_color)),
                SizedBox(width: getProportionateScreenWidth(50),),
                Text(
                  "FEED",
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black
                  ),
                ),

                SizedBox(width: getProportionateScreenWidth(50),),
                IconButton(onPressed: (){
                  push(context, MakePost());
                }, icon: FaIcon(FontAwesomeIcons.pen, color: primary_color))
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async{
          await ref.refresh(newFeedProvider);
        },
        child: Padding(
          padding: EdgeInsets.only(
            top: getProportionateScreenHeight(30),
          ),
          child: suggestions.when(data: (suggestions){
            return ListView.separated(
              separatorBuilder: (context, index) => const Divider(color: Colors.grey, height: 15,),
              itemCount: suggestions.length,
              itemBuilder: (context, index){
                final _feeds = suggestions[index];
                // PostModel yes = PostModel.fromJson(data);
                if(_feeds is PostModel){
                  return InkWell(
                    onLongPress: () async{
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
                                    // final del = ref.read(createpostServiceProvider);
                                    // del.deletePost(uId: userDetails.value!.id, postId: _feeds.postId);
                                    // // ref.read(eventRepositoryProvider).deleteCard(event);
                                    // // Provider.of<EventData>(context, listen: false)
                                    // //     .deleteCard(index);
                                    // Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          });
                    },
                    child: FeedsView(
                      post: _feeds,
                    ),
                  );
                }
                if(_feeds is UserModel){
                  return InkWell(
                    onLongPress: () async{
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
                                    // final del = ref.read(createpostServiceProvider);
                                    // del.deletePost(uId: userDetails.value!.id, postId: _feeds.postId);
                                    // // ref.read(eventRepositoryProvider).deleteCard(event);
                                    // // Provider.of<EventData>(context, listen: false)
                                    // //     .deleteCard(index);
                                    // Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          });
                    },
                    child: Text(_feeds.name),
                  );
                }
              },
            );
          },
              error: (e,_)=> throw e, loading: ()=> kProgressIndicator),
        ),
      ),
      drawer: DrawerView(),
    );
  }
}
