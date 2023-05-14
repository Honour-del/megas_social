import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/core/utils/constants/color_to_hex.dart';
import 'package:megas/core/utils/constants/size_config.dart';
import 'package:megas/core/utils/custom_widgets/app_bar.dart';
import 'package:megas/core/utils/custom_widgets/buttons.dart';
import 'package:megas/src/services/auth/auths_impl.dart';



class DetailsPage extends ConsumerStatefulWidget {
  const DetailsPage({Key? key,
    required this.id,
    required this.uid,
    required this.price,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.link,
  }) : super(key: key);
  final String id;
  final String uid;
  final double price;
  final String name;
  final String description;
  final String imageUrl;
  final String link;

  @override
  ConsumerState<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends ConsumerState<DetailsPage> {
  final String price = "N10,000";

  final String title = "Nike Shoes";

  final String description = "This is a very nice and beautiful shoe made of high quality leather";

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userDetailProvider);

    return Scaffold(
      appBar: appBar(context, 'Catalog', false, true),
      body: Padding(
          padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: detailImages(
                  image: widget.imageUrl,
                  //// images
                ),
              ),
            ),

            const SizedBox(height: 25,),

            Padding(
              padding: EdgeInsets.only(right: getProportionateScreenWidth(70), bottom: 10),
              child: Row(
                children: [
                  Text(
                    "Title: ${widget.name}"
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(right: getProportionateScreenWidth(70), bottom: 10),
              child: Row(
                children: [
                  Text(
                      "Price: ${widget.price}"
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(right: getProportionateScreenWidth(70), bottom: 10),
              child: Row(
                children: [
                  Text(
                      "Description: ${widget.description}",
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
            /// if it is the currentUser account return this
            if(widget.uid == user.value!.id) ifItsMe(),
            /// if it is not the currentUser account return this
            if(widget.uid != user.value!.id) Align(
              alignment: Alignment.bottomCenter,
              child: FlatButton(
                onTap: (){},
                label: "Message Business",
                color: HexColor("#F3F3F3"),
                textColor: primary_color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  detailImages({String? image}){
    return Container(
      height: getProportionateScreenHeight(280),
      width: getProportionateScreenWidth(288),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.5),
        image: DecorationImage(image: NetworkImage(image!)),
      ),
    );
  }

  ifItsMe(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: FlatButton(
        onTap: (){},
        label: "Edit Item",
        color: HexColor("#F3F3F3"),
        textColor: primary_color,
      ),
    );
  }
}
