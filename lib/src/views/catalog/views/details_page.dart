import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/core/utils/constants/color_to_hex.dart';
import 'package:megas/core/utils/constants/navigator.dart';
import 'package:megas/core/utils/constants/size_config.dart';
import 'package:megas/core/utils/custom_widgets/app_bar.dart';
import 'package:megas/core/utils/custom_widgets/buttons.dart';
import 'package:megas/src/services/auth/auths_impl.dart';
import 'package:megas/src/services/catalog/catalogs_impl.dart';
import 'package:megas/src/views/catalog/views/cart.dart';



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
  bool addedToCart = false;
  int value = 0;
  _checkIfAddedToCart() async{
    // final _user  =  await ref.watch(getProfile(widget.userId));
    //
    // UserModel? _model = _user.value;
    //
    // if(_model != null)
      if(value > 0){
        setState(() {
          addedToCart = true;
        });
      }else{
        setState(() {
          addedToCart = false;
        });
      }
  }

  final String price = "N10,000";

  final String title = "Nike Shoes";

  final String description = "This is a very nice and beautiful shoe made of high quality leather";

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userDetailProvider);

    return Scaffold(
      appBar: appBar(context, 'Details page', false, true, widget: SizedBox.shrink() ),
      body: Padding(
          padding: const EdgeInsets.only(top: 25, bottom: 25, left: 20),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0, left: 15),
                child: Row(
                  children: [
                    detailImages(
                      image: widget.imageUrl,
                      //// images
                    )
                  ],
                ),
              ),

               SizedBox(height: getProportionateScreenHeight(70),),

              Padding(
                padding: EdgeInsets.only(right: getProportionateScreenWidth(10), bottom: 10),
                child: Row(
                  children: [
                    Text(
                      "Title: ${widget.name}",
                      style: TextStyle(color: Theme.of(context).primaryColorDark),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(right: getProportionateScreenWidth(10), bottom: 10),
                child: Row(
                  children: [
                    Text(
                        "Price: ${widget.price}",
                      style: TextStyle(color: Theme.of(context).primaryColorDark),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(right: getProportionateScreenWidth(10), bottom: 10),
                child: Row(
                  children: [
                    Text(
                        "Description: ${widget.description}",
                      style: TextStyle(color: Theme.of(context).primaryColorDark),
                      softWrap: true,
                      maxLines: 10,
                    ),
                  ],
                ),
              ),

              SizedBox(height: getProportionateScreenHeight(50),),
              /// if it is the currentUser account return this
              if(widget.uid == user.value!.id) ifItsMe(),
              /// if it is not the currentUser account return this
              if(widget.uid != user.value!.id) FittedBox(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: FlatButtonCustom(
                        onTap: (){},
                        label: "Message Business",
                        color: HexColor("#F3F3F3"),
                        textColor: primary_color,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text('Or', style: TextStyle(fontSize: 13, color: Colors.grey),),
                    SizedBox(height: 10,),
                    addedToCart ?
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        children: [
                          itemCounter(),
                          SizedBox(width: 10,),
                          FlatButtonCustom(
                            onTap: (){
                              push(context, CartPage());
                            },
                            label: "View Cart",
                            color: HexColor("#F3F3F3"),
                            width: MediaQuery.of(context).size.width * 0.4,
                            textColor: primary_color,
                          ),
                        ],
                      ),
                    )
                        :
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: FlatButtonCustom(
                        onTap: (){
                          ref.read(cartProvider)
                          .increment(value);
                          _checkIfAddedToCart();
                        },
                        label: "Add to Cart",
                        color: HexColor("#F3F3F3"),
                        textColor: primary_color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  itemCounter(){
    final counter = ref.watch(cartProvider);
    return Row(
      children: [
        FlatButtonCustom(
            onTap: (){
              counter.decrement(value);
            }, label: '-',
          width: getProportionateScreenWidth(60),
        ),
        SizedBox(),
        Text(
          '$value',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.grey,
          ),
        ),
        SizedBox(),
        FlatButtonCustom(
          onTap: (){
            counter.increment(value);
          }, label: '+',
          width: getProportionateScreenWidth(60),
        ),
      ],
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
      child: FlatButtonCustom(
        onTap: (){},
        label: "Edit Item",
        color: HexColor("#F3F3F3"),
        textColor: primary_color,
      ),
    );
  }
}
