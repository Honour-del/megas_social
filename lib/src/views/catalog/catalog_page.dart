import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/core/utils/constants/navigator.dart';
import 'package:megas/core/utils/constants/regex.dart';
import 'package:megas/core/utils/constants/size_config.dart';
import 'package:megas/core/utils/custom_widgets/app_bar.dart';
import 'package:megas/src/controllers/catalog.dart';
import 'package:megas/src/services/auth/auths_impl.dart';
import 'package:megas/src/views/catalog/views/add_items_page.dart';
import 'package:megas/src/views/catalog/views/details_page.dart';
import '../../../core/utils/constants/color_to_hex.dart';


class CatalogPage extends ConsumerWidget {
  const CatalogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Todo:
    print('catalog');
    String? uid = ref.watch(authProviderK).value?.uid;
    final catalogs = ref.watch(catalogProvider(uid!));
    return Scaffold(
      appBar: appBar(context, 'Catalog', false, true),

      body: Padding(
          padding: EdgeInsets.only(top: getProportionateScreenHeight(50),left: getProportionateScreenWidth(15)),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topCenter,
              child: Text(
                'Add item(s) to  your Catalog',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),

            SizedBox(height: getProportionateScreenHeight(40),),
            // SizedBox(height: getProportionateScreenHeight(250),),
            Flexible(
              fit: FlexFit.tight,
              child: Padding(
                padding: const EdgeInsets.only(right: 40, left: 18),
                child: catalogs.when(data: (data) {
                  print("Data: ${data.length}");
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, index){
                      return addnewitemcontainer(
                        item: true,
                        title: data[index].itemName,
                        width: 178.5,
                        color: Colors.transparent,
                        onTap: (){
                          push(context, DetailsPage(
                            id: data[index].id,
                            uid: data[index].userId,
                            price: data[index].itemPrice,
                            link: data[index].link ?? 'link is empty',
                            description: data[index].description,
                            imageUrl: data[index].images,
                            name: data[index].itemName,));
                          print("i am tapped");
                        },
                        widget: Align(
                            alignment: Alignment.center,
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(image: NetworkImage(data[index].images), fit: BoxFit.fill)
                              ),
                            )),
                      );
                    },
                  );
                },
                    error: (error,_) => throw error, loading: ()=> kProgressIndicator),
              ),
            ),

            SizedBox(height: getProportionateScreenHeight(20),),
            Row(
              children: [
                addnewitemcontainer(
                  item: false,
                  onTap: (){
                    push(context, AddItemsPage());
                    print("i am tapped");
                  },
                  widget: Align(
                  alignment: Alignment.center,
                    child: Container(
                      height: 15,
                      width: 15,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                    )),
                ),
                const SizedBox(width: 13,),

                const Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Add new item',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(80),),
          ],
        ),
      ),
    );
  }

  addnewitemcontainer({Color? color, Widget? widget, VoidCallback? onTap, double? width, bool item = false, title }){
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Container(
              height: 85,
              width: width ?? 85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: color ?? primary_color,
                  border: Border.all(
                    color: primary_color,
                    width: 2,
                  )
              ),
              child: widget,
            ),
          ),
          SizedBox(height: 5,),
          if(item)
            Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              title, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            ),
          )
        ],
      ),
    );
  }
}
