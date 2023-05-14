import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:megas/core/utils/constants/color_to_hex.dart';
import 'package:megas/core/utils/constants/consts.dart';
import 'package:megas/core/utils/constants/navigator.dart';
import 'package:megas/core/utils/constants/size_config.dart';
import 'package:megas/core/utils/constants/uuid.dart';
import 'package:megas/core/utils/custom_widgets/alert_dialog.dart';
import 'package:megas/src/controllers/catalog.dart';
import 'package:megas/src/models/catalog.dart';
import 'package:megas/src/services/auth/auths_impl.dart';
import 'package:megas/src/services/posts/posts_impl.dart';
import 'package:megas/src/views/profile/customs/text_fields.dart';


class AddItemsPage extends ConsumerStatefulWidget {
  const AddItemsPage({Key? key}) : super(key: key);
  @override
  ConsumerState<AddItemsPage> createState() => _AddItemsPageState();
}

final name = TextEditingController();
final price = TextEditingController();
final quantity = TextEditingController();
final description = TextEditingController();
final link = TextEditingController();
bool isEditing = false;
bool loading = false;
File? _image;
List<XFile>? _imageList;
final ImagePicker _imagePicker = ImagePicker();
CreatePostImpl impl = CreatePostImpl();

class _AddItemsPageState extends ConsumerState<AddItemsPage> {
  @override

  void initState(){
    super.initState();
    name.addListener(_done);
    price.addListener(_done);
    description.addListener(_done);
  }
  void _done(){
    setState(() {
      isEditing = (_image != null) && (name.text.isNotEmpty)  && (price.text.isNotEmpty) && (description.text.isNotEmpty);
    });
  }
  Widget build(BuildContext context) {
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
              // top: 30,
                left: 20,
                right: 20
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(onPressed: (){}, icon: FaIcon(FontAwesomeIcons.arrowLeft, color: primary_color)),
                SizedBox(width: getProportionateScreenWidth(70),),
                Text(
                  "Add Item",
                  style: const TextStyle(
                      fontSize: 18,
                      // fontFamily: "MISTRAL",
                      // fontWeight: FontWeight.w500,
                      color: Colors.black
                  ),
                ),

                SizedBox(width: getProportionateScreenWidth(70),),
                isEditing ?  InkWell( //if ((username.text.isEmpty) || ( website.text.isEmpty) || (bio.text.isEmpty))
                  onTap: ()async{
                    setState(() {
                      loading = true;
                    });
                    String? uid = ref.read(authProviderK).value?.uid;
                    final catalogs = ref.read(catalogProvider(uid!).notifier);
                    // String? uid = ref.read(authProviderK).value?.uid;
                    String id = uuid.v1();
                    print('about to start');
                    final i =  await impl.uploadImage(file: _image!, directoryName: 'catalog', fileName: 'catalog.jpg', uid: uid);
                    print('image uploaded successfully');
                    var catalog = CatalogModel(
                        userId: uid, id: id,
                        description: description.text,
                        images: i,
                        itemQuantity: int.parse(quantity.text),
                        itemName: name.text,
                        itemPrice: double.parse(price.text));
                    await catalogs.createCatalog(catalogModel: catalog);
                    // if(data = 'success')
                    showSnackBar(context, text: 'Catalog successfully created');
                    setState(() {
                      loading = false;
                    });
                    popcontext(context);
                  },
                  child: (loading) ? Text('Loading...',style: TextStyle(color: Colors.black),) : Text('Done',style: TextStyle(color: Colors.black),),
                ) : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: getProportionateScreenHeight(1),),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              _image == null ?
              InkWell(
                onTap: () async{
                  //// go to gallery to select image(s)
                  showDialog(context: context, builder: (context){
                    return AlertBox(
                      firstGo: (){
                        popcontext(context);
                      },
                      secondGo: () {
                        _getImage(ImageSource.camera);
                        print('camera');
                      },
                      thirdGo: (){
                        _getImage(ImageSource.gallery);
                        print("gallery");
                      },
                    );
                  });
                },
                  child: Container(
                    decoration: BoxDecoration(
                      color: HexColor("#e9d8f2"),
                    ),
                    height: getProportionateScreenHeight(285),
                    width: getProportionateScreenWidth(340),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(FontAwesomeIcons.camera, size: 25, color: primary_color,),
                          const SizedBox(),
                          Text(
                            "Add Images",
                            style: TextStyle(color: primary_color,),
                          ),
                        ],
                      ),
                    ),
              )) :
              Image.file(_image!),

              const SizedBox(height: 27,),

              EditForm(controller: name, label: "Item Name", onChanged: (value){
                if(name.text.isNotEmpty) {

                }
              },),
              EditForm(controller: price, label: "Price", onChanged: (value){
                if(price.text.isNotEmpty) {
                }
              },),
              EditForm(controller: quantity, label: "Quantity", onChanged: (value){
                if(quantity.text.isNotEmpty) {
                }
              },),
              EditForm(controller: description, label: "Description", onChanged: (value){
                if(description.text.isNotEmpty) {

                }
              },),
              EditForm(controller: link, label: "Link", onChanged: (value){
                if(link.text.isNotEmpty) {

                }
              },),
            ],
          ),
        ),
      ),
    );
  }



  void _pickingList() async{
    try{
      final List<XFile>? pickedFile2 = await _imagePicker.pickMultiImage(
        // maxWidth: ma,
        // maxHeight: ,
        // imageQuality: ,
      );
      // final imageTemps = File(pickedFile2.);
      setState(() {
        _imageList = pickedFile2;
      });
    } catch (e){
      throw('Failed to pick images: $e');
    }
  }

  Future _getImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(source: source);
      if(pickedFile == null) return;
      final imageTemp = File(pickedFile.path);
      setState(() {
        _image = imageTemp;
        _done();
      });
      popcontext(context);
    } on PlatformException catch (e) {
      throw('Failed to pick image: $e');
    }
  }


   _previewImage() {
    if(_imageList != null){
      return Semantics(
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          key: UniqueKey(),
          itemBuilder: (context, index){
            return Semantics(
              child: Image.file(File(_imageList![index].path)),
            );},
          itemCount: _imageList!.length,
        ),
      );
    }
  }
}


