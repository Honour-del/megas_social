import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:megas/core/utils/constants/color_to_hex.dart';
import 'package:megas/core/utils/constants/navigator.dart';
import 'package:megas/core/utils/constants/regex.dart';
import 'package:megas/core/utils/constants/size_config.dart';
import 'package:megas/src/controllers/search.dart';
// import 'package:megas/src/models/User.dart';
import 'package:megas/src/views/profile/profile_page.dart';


class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowResults = false;
  String _search = '';
  @override
  Widget build(BuildContext context) {
    // final search2  = ref.read(searchProvider2(searchController.text));
    // final search  = ref.read(searchProvider(searchController.text));
    return SafeArea(
      child: Scaffold(
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
                // top: 30,
                  left: 0,
                  right: 12
              ),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: (){popcontext(context);}, icon: FaIcon(FontAwesomeIcons.arrowLeft, color: primary_color)),
                  SizedBox(width: getProportionateScreenWidth(15),),
                  SizedBox(
                    width: getProportionateScreenWidth(280),
                    height: getProportionateScreenHeight(50),
                    child: TextFormField(
                      controller: searchController,
                      decoration: const InputDecoration(labelText: 'Search for users',
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)
                        ),
                      ),
                      onChanged: (query){
                        setState(() {
                          _search = "@$query";
                        });
                        print(_search);
                      },
                      onFieldSubmitted: (String _){
                        setState(() {
                          isShowResults = true;
                        });
                        print(_);
                      },
                    ),
                  ),

                  SizedBox(width: getProportionateScreenWidth(15),),
                ],
              ),
            ),
          ),
        ),

        body: isShowResults ?  ref.read(searchProvider2(_search)).when(data: (users){
          if(users.isEmpty)
            Center(child: Text('$_search does not exist'),);
          return ListView.builder(
              itemCount: users.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index){
                return InkWell(
                  onTap: (){
                    push(context, ProfilePage(userId: users[index].id,));
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: getProportionateScreenWidth(20), right: getProportionateScreenWidth(20), top: 28),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.grey,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                            )
                          ]),
                      child: ListTile(
                        leading: CircleAvatar(
                          // TODO: profile image
                        ),
                        title: Text(users[index].username),
                        trailing: Icon(FontAwesomeIcons.arrowRight),
                      ),
                    ),
                  ),
                );
              }
          );
        },error: (error,_) => throw error, loading: ()=> kProgressIndicator, )
        : Center(
          child: Container(
            // height: 250,
            // width: 250,
            child: Column(
              children: [
                Icon(Icons.person,color: primary_color, size: 200,),
                Text(
                  "Search User",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: primary_color, fontWeight: FontWeight.w500, fontSize: 50),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
