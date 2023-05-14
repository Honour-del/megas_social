// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:megas/core/utils/constants/color_to_hex.dart';
import 'package:megas/core/utils/constants/size_config.dart';
// import 'package:padie_mobile/common/constants/colors.dart';
// import 'package:padie_mobile/common/constants/size_config.dart';
// import '../../app_main.dart';


import 'package:flutter/material.dart';
// import 'buttons.dart';

class IsEmpty extends StatelessWidget {
  const IsEmpty({Key? key, this.err}) : super(key: key);
  final String? err;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Something went wrong',
          style: TextStyle(
              color: Colors.grey,
              fontSize: 17,
              fontWeight: FontWeight.w700
          ),
        ),
        const SizedBox(height: 16,),
        Text(
          err.toString() ?? '',
          textAlign: TextAlign.justify,
          style: const TextStyle(
              color: Colors.grey,
              fontSize: 17,
              fontWeight: FontWeight.w700
          ),
        ),
        const SizedBox(height: 16,),

        // MyButton(label: 'Retry', onTap: () { }, isSmall: false, withLogo: false, isOrange: true, icon: Icons.refresh),
      ],
    );
  }
}


enum USERTYPE {restUser, googleUser, appleUser}
const String googleApiKey = "API_KEY";
void hasInternetConnection(){
  // Connectivity().onConnectivityChanged.listen((event) {
  //   if (event == ConnectivityResult.none)
  //   {
  //     showDialogFlash();
  //   }
  // });
}




Center kProgressIndicator = Center(
  child: Padding(
    padding: EdgeInsets.only(bottom: 8),
    child: CircularProgressIndicator(
      color: primary_color,
    ),
  ),
);

InputDecoration kInputDecoration = InputDecoration(
  isDense: true,
  //isCollapsed: true,
  labelStyle: TextStyle(
    fontSize: getFontSize(16),
    color: Colors.grey,
    fontWeight: FontWeight.w400,
  ),
  errorBorder: const UnderlineInputBorder(
    borderSide: BorderSide(color: Color(0xffF1A01F), width: 1.0),
  ),
  errorStyle: const TextStyle(color: Color(0xffF1A01F)),
  hintText: "Email Address",
  hintStyle: TextStyle(
    fontSize: getFontSize(16),
    color: Colors.black,
    fontWeight: FontWeight.w400,
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: primary_color, width: 2.0),
  ),
);


const support_mail = 'mailto:info@hangoutpadie.com?subject=News&body=New%20plugin';

final RegExp emailValidatorRegExp =
RegExp(r"^((.*?)@[a-zA-Z0-9]+\.[a-zA-Z]+)"); //[a-zA-Z0-9.]+
final RegExp urlPattern = RegExp(
    r'^((?:.|\n)*?)((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:Ã¢â‚¬Å’Ã¢â‚¬â€¹,.;]*)?)');
final RegExp atleastOneLowerCase = RegExp(r"^(?=.*[a-z])");
final RegExp atLeastOneUpperCase = RegExp(r"^(?=.*[A-Z])");
final RegExp atleastOneDigit = RegExp(r"^(?=.*?[0-9])");
final RegExp atleastOneSpecial = RegExp(r"^(?=.*?[!@#\$&*~])");


void showDialogFlash() {
  // mainNavigatorKey.currentContext!.showFlashDialog(
  //     constraints: const BoxConstraints(maxWidth: 300),
  //     title: const Text('Internet Connection'),
  //     content: const Text('You are currently offline, turn on your mobile data or wifi to connect',
  //         style: TextStyle(fontSize: 14)),
  //     positiveActionBuilder: (context, controller, _,) {
  //       return TextButton(
  //           onPressed: ()=> controller.dismiss(), child: const Text('OK'));
  //     }
  // );
}

const noConnection = '';
const somethingWentWrong = '';

extension ValidNumber on String {
  String? get validPhoneNumber {
    String? newPh;
    if (length == 11) {
      if (startsWith("0")) {
        newPh = replaceFirst(RegExp(r"0"), "234");
      }
    } else if (length > 11) {
      if (startsWith("+")) {
        newPh = replaceFirst(RegExp(r"\+"), "").trim();
      } else if (startsWith(RegExp(r"234"))) {
        newPh = this;
      }
    }

    return newPh;
  }
}



extension ExtString on String {
  bool get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(this);
  }

  bool get isValidName {
    final nameRegExp = RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
    return nameRegExp.hasMatch(this);
  }

  bool get isValidPassword {
    final passwordRegExp = RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*[0-9])(?=.*?[!@#\><*~]).{8,}/pre>");
    return passwordRegExp.hasMatch(this);
  }

  bool get isNotNull {
    return this!=null;
  }

  bool get isValidPhone {
    final phoneRegExp = RegExp(r"^\+?0[0-9]{}");
    return phoneRegExp.hasMatch(this);
  }
}