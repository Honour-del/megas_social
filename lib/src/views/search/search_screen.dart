import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:megas/core/utils/constants/color_to_hex.dart';
import 'package:megas/core/utils/constants/navigator.dart';
import 'package:megas/core/utils/constants/regex.dart';
import 'package:megas/core/utils/constants/size_config.dart';
import 'package:megas/src/controllers/search.dart';
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
                children: [
                  IconButton(onPressed: (){popcontext(context);}, icon: FaIcon(FontAwesomeIcons.arrowLeft, color: primary_color)),
                  SizedBox(width: getProportionateScreenWidth(15),),
                  SizedBox(
                    width: getProportionateScreenWidth(280),
                    height: getProportionateScreenHeight(50),
                    child: TextFormField(
                      controller: searchController,
                      decoration: InputDecoration(labelText: 'Search for users',
                        labelStyle: TextStyle(color: Theme.of(context).primaryColorDark),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).primaryColorDark)
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

        body: isShowResults ?  ref.watch(searchProvider2(_search)).when(data: (users){
          if(users.isEmpty)
            Center(child: Text('$_search does not exist',
              style: Theme.of(context).textTheme.displayMedium,
            ),);
          return ListView.builder(
              itemCount: users.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index){
                return GestureDetector(
                  onTap: (){
                    push(context, ProfilePage(userId: users[index].id,));
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: getProportionateScreenWidth(20), right: getProportionateScreenWidth(20), top: 28),
                    child: Container(
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
                      child: Row(
                        children: [
                          CircleAvatar(backgroundImage: NetworkImage(users[index].avatarUrl),),
                          SizedBox(width: 2,),
                          Column(
                            children: [
                              Text(
                                users[index].name,
                                style: TextStyle( // Theme.of(context).textTheme.labelMedium
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[900],
                                ),
                              ),
                              SizedBox(height: 2.5,),
                              Text(
                                users[index].username,
                                style: TextStyle(
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),
                );
              }
          );
        },error: (error,_) => throw error, loading: ()=> kProgressIndicator,)
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
                  style: TextStyle(color: Theme.of(context).cardColor, fontWeight: FontWeight.w500, fontSize: 50),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
