import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:megas/core/utils/constants/color_to_hex.dart';
import 'package:megas/core/utils/constants/navigator.dart';
import 'package:megas/core/utils/constants/size_config.dart';



PreferredSizeWidget appBar(BuildContext context, String title, bool? autolead,  bool? lead, {Widget? widget, bool? search, color}) {
  // Widget? widget;
  VoidCallback? onTap;
  return AppBar(
    automaticallyImplyLeading: autolead!,
    toolbarHeight: 70,////80
    backgroundColor: color ?? Colors.transparent,
    elevation: 0.0,
    // iconTheme: IconThemeData(color: primary_color),
    // leading: Text('yes'),
    shadowColor: Colors.transparent,
    flexibleSpace: Center(
      child: Padding(
        padding: const EdgeInsets.only(
            // top: 30,
            left: 12,
            right: 12
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            lead! ? IconButton(onPressed: (){popcontext(context);}, icon: FaIcon(FontAwesomeIcons.arrowLeft, color: Theme.of(context).focusColor)) : SizedBox.shrink(),
            lead ? SizedBox(width: getProportionateScreenWidth(75),) : SizedBox(width: getProportionateScreenWidth(115),),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),

            SizedBox(width: getProportionateScreenWidth(75),),
            InkWell(
              onTap: onTap,
                child: widget ?? IconButton(onPressed: (){
                  // push(context, HomePage());
                }, icon: FaIcon(FontAwesomeIcons.magnifyingGlass, color: Theme.of(context).focusColor))),
            // SizedBox(width: getProportionateScreenWidth(12),),
          ],
        ),
      ),
    ),
  );
}
