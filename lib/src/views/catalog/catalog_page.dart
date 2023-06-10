import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:megas/core/utils/constants/navigator.dart';
import 'package:megas/core/utils/constants/regex.dart';
import 'package:megas/core/utils/constants/size_config.dart';
import 'package:megas/core/utils/custom_widgets/app_bar.dart';
import 'package:megas/src/controllers/catalog.dart';
import 'package:megas/src/services/auth/auths_impl.dart';
import 'package:megas/src/views/catalog/views/add_items_page.dart';
import 'package:megas/src/views/catalog/views/details_page.dart';


class CatalogPage extends ConsumerWidget {
  const CatalogPage({Key? key,this.profileId, this.profileName}) : super(key: key);
  final String? profileId;
  final String? profileName;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Todo:
    print('catalog');
    String? uid = ref.watch(authProviderK).value?.uid;
    final catalogs = ref.watch(catalogProvider(profileId!));
    // final catalogOwner = ref.watch(catalogProvider(profileId!));
    return Scaffold(
      appBar: appBar(context, 'Catalog', false, true),

      body: Padding(
          padding: EdgeInsets.only(top: getProportionateScreenHeight(50),left: getProportionateScreenWidth(15)),
        child: uid != profileId ?
        Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                "$profileName Catalog's list",
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),

            SizedBox(height: getProportionateScreenHeight(25),),
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
                        context: context,
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

          ],
        )
            :  Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                'Add item(s) to  your Catalog',
                style: Theme.of(context).textTheme.labelLarge,
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
                        context: context,
                        item: true,
                        title: data[index].itemName,
                        width: getProportionateScreenWidth(300),
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
                        widget: Row(
                          children: [
                            Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  height: 80,
                                  width: 100,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        image: DecorationImage(image: NetworkImage(data[index].images), fit: BoxFit.fill)
                                    ),
                                  ),
                                )),
                            SizedBox(width: 8,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10,),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        data[index].itemName, style: Theme.of(context).textTheme.labelSmall,
                                      ),
                                    ),
                                  SizedBox(height: 4,),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      "\u20A6${data[index].itemPrice.toString()}", style: Theme.of(context).textTheme.labelSmall,
                                    ),
                                  ),
                                  SizedBox(height: 3,),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      data[index].description, style: Theme.of(context).textTheme.labelSmall,
                                      overflow: TextOverflow.ellipsis,
                                      // maxLines: 1,
                                    ),
                                  ),
                                  SizedBox(height: 2,),
                                ],
                              ),
                            ),
                          ],
                        ),
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
                  context: context,
                  item: false,
                  onTap: (){
                    push(context, AddItemsPage());
                  },
                  widget: Align(
                  alignment: Alignment.center,
                    child: Stack(
                      children: [
                        Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                        ),
                        FaIcon(FontAwesomeIcons.plus, color: Theme.of(context).primaryColorDark,),
                      ],
                    )),
                ),
                const SizedBox(width: 13,),

                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Add new item',
                    style: Theme.of(context).textTheme.labelLarge,
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

  addnewitemcontainer({Color? color, Widget? widget, VoidCallback? onTap, double? width, bool item = false, title,required BuildContext context }){
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
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.15),
                      blurRadius: 5,
                    ),
                  ]),
              child: widget,
            ),
          ),
          SizedBox(height: 5,),
        ],
      ),
    );
  }
}
