import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:megas/core/utils/constants/color_to_hex.dart';
import 'package:megas/core/utils/constants/size_config.dart';
import 'package:megas/core/utils/custom_widgets/app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/constants/navigator.dart';

class InviteFriends extends StatelessWidget {
  const InviteFriends({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: appBar(context, 'Invite\n Friends & Opps', false, true ),
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
                left: 12,
                right: 12
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(onPressed: (){popcontext(context);}, icon: FaIcon(FontAwesomeIcons.arrowLeft, color: primary_color)),
                SizedBox(width: getProportionateScreenWidth(58),),
                Text(
                  "Invite\n Friends & Opps",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18,
                      // fontFamily: "MISTRAL",
                      // fontWeight: FontWeight.w500,
                      color: Colors.black
                  ),
                ),

                SizedBox(width: getProportionateScreenWidth(58),),
                InkWell(
                    onTap: (){},
                    child: IconButton(onPressed: (){}, icon: FaIcon(FontAwesomeIcons.magnifyingGlass, color: primary_color))),
                // SizedBox(width: getProportionateScreenWidth(12),),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
              fit: FlexFit.loose,
              child: SizedBox(
                height: getProportionateScreenHeight(93),
              )),
          InkWell(
            onTap: launchSupportEmail,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(35.0)),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(),
                    ),
                    child: Image.asset(
                      "assets/images/help.png",
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: getProportionateScreenWidth(21)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Contact Us",
                          style: TextStyle(fontSize: getFontSize(18))),
                      Text(
                        "Questions? Need help?",
                        style: TextStyle(
                            fontSize: getFontSize(18),
                            color: tertiary_color,
                            decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  launchSupportEmail() async {
    final url = Uri(
      scheme: 'mailto',
      path: 'support@numbers.ng',
      // queryParameters: {'subject': 'Example'}
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Cannot not launch $url';
    }
  }
}
