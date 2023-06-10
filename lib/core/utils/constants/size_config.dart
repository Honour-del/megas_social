import 'package:flutter_screenutil/flutter_screenutil.dart';

//class SizeConfig {
//  SizeConfig([BuildContext context]) {
//     ScreenUtil.instance = ScreenUtil(width: 414, height: 896)..init(context);
//   }
//}

String server_key = 'AAAAB9T7eIg:APA91bFotrIsyxoJzFzTzmpX_L_o1Agl2h9Dm4Yu-vFwNup_xfSWbAclV4STkCzNgJkx5w9Od27krolfmfVRtYKhH2qIObb-NW9xwCNorDAlJQHOQKtKxHpmj5YZUPaWV98Ks08zIgqy';
///gets the proportionate height in relation to the screen height
double getProportionateScreenHeight(double inputHeight) {
  double height = inputHeight.h;
  //double screenHeight = SizeConfig.screenHeight;
  return height;
}

double getProportionateScreenWidth(double inputWidth) {
  double width = inputWidth.w;
//  double screenWidth = SizeConfig.screenWidth;
  return width;
}

getFontSize(double inputSize) {
  double fontSize = inputSize.sp;
  return fontSize;
}
