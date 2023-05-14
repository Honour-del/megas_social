import 'package:flutter/material.dart';
import 'package:megas/core/utils/constants/color_to_hex.dart';
import 'package:megas/core/utils/constants/navigator.dart';
import 'package:megas/core/utils/constants/size_config.dart';
import 'package:megas/core/utils/custom_widgets/buttons.dart';
import 'package:megas/src/views/register/components/take_selfie/capture.dart';
import 'package:megas/src/views/register/components/take_selfie/selfie_camera.dart';
// import 'package:numbers/screens/sign_up/take_selfie/selfie_camera.dart';
// import 'package:numbers/utils/sizeConfig.dart';
// import 'package:numbers/widgets/buttons/default_button.dart';
//
// import '../../../utils/constants.dart';


class TakeSelfie extends StatelessWidget {
  static final routeName = "/take_selfie";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        // Image.asset("assets/images/background.png"),
        SingleChildScrollView(
            child: Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                    child: SizedBox.shrink()),
                Padding(
                  padding: EdgeInsets.only(
                      top: getProportionateScreenHeight(30),
                      bottom: getProportionateScreenHeight(50)),
                  child: const Center(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Ubuntu'),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(40),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Upload",
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: getProportionateScreenHeight(20.0)),
                          const Text(
                              "Your selfie will be used to verify uploaded ID."),
                        ],
                      ),
                    ),
                    Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical:getProportionateScreenHeight(44)),
                      child: Image.asset("assets/images/selfie.png"),
                    ),
                    ),
                    const InfoHeading(headline: "Good Lighting", buttonNumber: "1"),
                    const InfoBody(
                        body:
                            "Make sure you are in a well lit area and both ears are uncovered"),
                    SizedBox(
                      height: getProportionateScreenHeight(10.0),
                    ),
                    const InfoHeading(headline: "Look Straight", buttonNumber: "2"),
                    const InfoBody(
                        body:
                            "Hold your phone at eye level and look straight at the camera"),
                    SizedBox(
                      height: getProportionateScreenHeight(50.0),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(40),
                      ),
                      child: FlatButton(
                          label: "!Open Camera",
                          onTap: () => push(context, FaceDetectorView())),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(30.0),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(40),
                      ),
                      child: FlatButton(
                          label: "Open Camera",
                          onTap: () => push(context, CaptureImage())),
                    ),
                  ],
                )
              ]),
        )),
        IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
      ]),
    ));
  }
}

class InfoBody extends StatelessWidget {
  const InfoBody({
    required this.body,
  });
  final String body;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(40),
      ),
      child: Text(body, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300)),
    );
  }
}

class InfoHeading extends StatelessWidget {
  const InfoHeading({super.key,
    required this.headline,
    required this.buttonNumber,
  });
  final String headline, buttonNumber;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: getProportionateScreenWidth(18.0),
      ),
      child: Row(
        children: [
          DecoratedNumber(child: buttonNumber),
          SizedBox(
            width: getProportionateScreenWidth(5.0),
          ),
          Text(headline,
              style: TextStyle(
                  color: secondary_color,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class DecoratedNumber extends StatelessWidget {
  const DecoratedNumber({
    Key? key,
    required this.child,
  }) : super(key: key);
  final String child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: primary_color),//Colors.green
      height: getProportionateScreenWidth(17.0),
      width: getProportionateScreenWidth(17.0),
      child: Center(
          child: Text(child,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500))),
    );
  }
}
