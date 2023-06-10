import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:megas/core/utils/constants/color_to_hex.dart';
import 'package:megas/core/utils/constants/navigator.dart';
import 'package:megas/core/utils/constants/regex.dart';
import 'package:megas/core/utils/constants/size_config.dart';
import 'package:megas/src/controllers/profile.dart';
import 'package:megas/src/services/auth/auths_impl.dart';
import 'package:megas/src/views/profile/customs/text_fields.dart';


class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

// @override
class _EditProfileState extends ConsumerState<EditProfile> {

  final GlobalKey<FormState> _key = GlobalKey();
  @override
  void initState(){
    super.initState();
    // username.addListener(_done);
    // bio.addListener(_done);
    // website.addListener(_done);
  }
  // @override
  // void dispose(){
  //   username.dispose();
  //   bio.dispose();
  //   website.dispose();
  //   super.dispose();
  // }

  void _done(){
    setState(() {
      isEditing = (username.text.isNotEmpty) || (website.text.isNotEmpty) || (bio.text.isNotEmpty);
    });
  }

  TextEditingController username = TextEditingController();
  TextEditingController website = TextEditingController();
  TextEditingController bio = TextEditingController();
  bool isEditing = false;
  bool loading =false;
  @override
  Widget build(BuildContext context) {
    String? uid = ref.watch(authProviderK).value?.uid;
    final previous = ref.watch(getProfile(uid!));
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        extendBody: true,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: Padding(padding: const EdgeInsets.all(10),
            child: InkWell(
              onTap: () => popcontext(context),
              child: const Icon(Icons.arrow_back),
            ),
          ),
          toolbarHeight: 70,////80
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          // iconTheme: IconThemeData(color: primary_color),
            flexibleSpace: Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 6.5,
                  left: 20,
                  // right: 10
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(width: getProportionateScreenWidth(80),),
                    Text(
                      "Edit Profile",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                    SizedBox(width: getProportionateScreenWidth(50),),
                    isEditing ?  InkWell( //if ((username.text.isEmpty) || ( website.text.isEmpty) || (bio.text.isEmpty))
                      onTap: (){
                        if(_key.currentState!.validate()){
                          _key.currentState!.save();
                          setState(() {
                            loading = true;
                          });
                          print('Im tapped');
                          String? uid = ref.read(authProviderK).value?.uid;
                          final click = ref.read(profileControllerProvider(uid!).notifier);
                          print(uid);
                          String validUsername = '';
                          if(!username.text.contains('@')){
                            setState(() {
                              validUsername = "@${username.text}";
                            });
                          }else {
                            validUsername = username.text;
                          }
                          print('json');
                          Map<String, dynamic>? json = {
                            "username": validUsername,
                            "bio": bio.text,
                            "website": website.text,
                          };
                          click.updateProfile(
                              json: json
                          );
                          print('Im tapped');
                          setState(() {
                            loading = false;
                          });
                          popcontext(context);
                        }
                      },
                      child: Text('Done',style: TextStyle(color: Theme.of(context).primaryColorDark),),
                    ) : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: getProportionateScreenHeight(60),),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Form(
                  key: _key,
                  child: previous.when(data: (data)=>Column(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(data.avatarUrl),
                          radius: 70,
                        ),
                      ),
                      const SizedBox(height: 15,),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text('Change Profile Picture',
                          style: TextStyle(
                            color: Theme.of(context).focusColor,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40,),
                      const Divider(),

                      EditForm(controller: username, label: "Username",
                        validator: (value){
                          if(username.text.length >= 4)
                            return null;
                          if(username.text.contains(' '))
                            return 'white space is not allowed';
                          else return 'username must be >= 4';
                        },
                        onChanged: (value){
                          if(username.text.isNotEmpty) {
                            // setState(() {
                            //   isEditing = true;
                            // });
                          }
                        },),
                      EditForm(controller: website, label: "Website",
                        validator: (value){
                          if(website.text.contains(' '))
                            return 'this url is not valid';
                          else return null;
                        },
                        onChanged: (value){
                          if(website.text.isNotEmpty) {
                            // setState(() {
                            //   isEditing = true;
                            // });
                          }
                        },),
                      EditForm(controller: bio, label: "Bio",
                        validator: (value){
                          if(bio.text.length  != -1)
                            return null;
                          return null;
                        },
                        onChanged: (value){
                          if(bio.text.isNotEmpty) {
                            // setState(() {
                            //   isEditing = true;
                            // });
                          }
                        },),
                    ],
                  ), error: (error,_) => throw error,
                      loading: ()=> kProgressIndicator),
                ),
              ),
            ),
            if(loading)
            kProgressIndicator,
          ],
        ),
      ),
    );
  }
}

