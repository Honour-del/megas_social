import 'package:flutter/material.dart';
import 'package:megas/core/utils/constants/color_to_hex.dart';
import 'package:megas/core/utils/constants/size_config.dart';
import 'package:megas/core/utils/custom_widgets/app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class Help extends StatelessWidget {
  const Help({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Help', false, true ),
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
