
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:megas/core/utils/constants/color_to_hex.dart';
import 'package:megas/core/utils/constants/consts.dart';
import 'package:megas/core/utils/constants/navigator.dart';
import 'package:megas/core/utils/constants/regex.dart';
import 'package:megas/core/utils/constants/size_config.dart';
import 'package:megas/core/utils/custom_widgets/alert_dialog.dart';
import 'package:megas/src/controllers/create_post.dart';
import 'package:megas/src/services/auth/auths_impl.dart';


class MakePost extends ConsumerStatefulWidget {
  const MakePost({Key? key}) : super(key: key);

  @override
  ConsumerState<MakePost> createState() => _MakePostState();
}
  // bool isDone = false;
  final posts = TextEditingController();
  File? _image;

  ImagePicker _imagePicker = ImagePicker();
  bool isLoading = false; ///
  bool isActivated = false;
  String caption = 'the text controller can\'t be empty';
  AuthServiceImpl service  = AuthServiceImpl();
  final GlobalKey<FormState> _key = GlobalKey();
class _MakePostState extends ConsumerState<MakePost> {
  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    setState(() {
      posts.text = '';
      _image = null;
    });
    super.dispose();
  }

  Widget build(BuildContext context) {
    Future _getImage(ImageSource source) async {
      try {
        setState(() {
          isLoading = true;
        });
        final XFile? pickedFile = await _imagePicker.pickImage(source: source);
        if(pickedFile == null) return;
        final imageTemp = File(pickedFile.path);
        setState(() {
          _image = imageTemp;
        });
        setState(() {
          isLoading = false;
        });
        popcontext(context);
      } on PlatformException catch (e) {
        throw('Failed to pick image: $e');
      }
    }

    addnewitemcontainer({String? label, VoidCallback? onTap}){
      return Padding(
        padding: const EdgeInsets.only(bottom: 24, left: 20),
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              InkWell(
                onTap: onTap,
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      // color: color ?? primary_color,
                      border: Border.all(
                        color: Theme.of(context).primaryColorDark,
                        width: 2,
                      )
                  ),
                  child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 15,
                        width: 15,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                      )),
                ),
              ),

              const SizedBox(width: 13,),

              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  label!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      );
    }


    createPost(){
      return Stack(
        children: [
          Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)
                  ),
                  hintText: "Whats on your mind?",
                  hintStyle: TextStyle(color: Theme.of(context).primaryColorDark)
                ),
                controller: posts,
                onChanged: (value){
                  if(posts.text.isNotEmpty)
                    setState(() {
                      caption = value;  // caption value is == post controller value
                      isActivated = true;
                      print(caption);
                    });
                  else setState(() {
                    isActivated = false;
                  });
                },
                keyboardType: TextInputType.text,
              ),

              const SizedBox(height: 30,),


              if (_image != null) Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.file(_image!),
              ) else SizedBox.shrink(),

              addnewitemcontainer(label: "Photo/Video", onTap: (){
                print("object");
                setState(() {
                  isLoading = true;
                });
                showDialog(context: context, builder: (context){
                  return AlertBox(
                    firstGo: (){
                      setState(() {
                        _image = null;
                      });
                      print('selected image deleted');
                    },
                    secondGo: () {
                      _getImage(ImageSource.camera);
                      print("camera");
                    },
                    thirdGo: () {
                      _getImage(ImageSource.gallery);
                      // popcontext(context);
                      print("gallery");
                    },
                  );
                });
                setState(() {
                  isLoading = false;
                });
              }),
              const SizedBox(height: 20,),
              addnewitemcontainer(label: "Location", onTap: (){
                // push(context, AddItemsPage());
              }),
            ],
          ),
          if(isLoading)
            Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: kProgressIndicator,
              ),
            ),
        ],
      );
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,////80
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        // iconTheme: IconThemeData(color: primary_color),
        shadowColor: Colors.transparent,
        flexibleSpace: Center(
          child: Padding(
            padding: const EdgeInsets.only(
              // top: 30,
                left: 20,
                right: 20
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(onPressed: (){
                  popcontext(context);
                }, icon: FaIcon(FontAwesomeIcons.arrowLeft, color: Theme.of(context).primaryColorDark)),
                SizedBox(width: getProportionateScreenWidth(80),),
                Text(
                  "Post",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                SizedBox(width: getProportionateScreenWidth(80),),
                IconButton(onPressed: isActivated ? () async{ /// it must not respond unless it is activated
                  // if(!isActivated) /// if isActivated = true
                    /// posting
                    setState(() {
                      isLoading = true;
                    });
                    final user = await ref.read(userDetailProvider).value;
                  final post = ref.read(createPostProvider.notifier);
                    print('Uploading post');
                    if(_image  != null){
                      print('Path: ${_image?.path}');
                      await post.uploadPost(
                        caption: caption,
                        url: _image!,
                        uid: user!.id, username: user.username, name: user.name, avatarUrl: user.avatarUrl,
                      ).catchError((err){
                        showSnackBar(context, text: "Error: $err");
                        throw err;
                      });
                    } else{
                      print('Media-less post');
                      await post.uploadTextPost(uid: user!.id, username: user.username,
                        name: user.name, avatarUrl: user.avatarUrl,
                        caption: caption,
                      ).catchError((err){
                        showSnackBar(context, text: "Error: $err");
                        throw err;
                      });;
                    }
                    setState(() {
                      isLoading = false;
                      isActivated = false;
                    });
                    showSnackBar(context, text: "Post successfully uploaded");
                    popcontext(context);
                  /// done
                } : null, icon: FaIcon(Icons.send, color: isActivated ? Theme.of(context).primaryColorDark : Colors.grey) ),
              ],
            ),
          ),
        ),
      ),
      body: Form(
        key: _key,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(top: 25),
            child: createPost(),
          ),
        ),
      ),
    );
  }
}
