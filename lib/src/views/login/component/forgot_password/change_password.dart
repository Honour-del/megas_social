// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:megas/core/utils/constants/color_to_hex.dart';
// import 'package:megas/core/utils/constants/consts.dart';
// import 'package:megas/core/utils/constants/general_provider.dart';
// import 'package:megas/core/utils/constants/regex.dart';
// import 'package:megas/core/utils/constants/size_config.dart';
// import 'package:megas/core/utils/custom_widgets/buttons.dart';
// import 'package:megas/src/controllers/auth.dart';
// import 'package:megas/src/views/login/login_page.dart';
//
// class ChangePassword extends ConsumerStatefulWidget {
//   static String routeName = "/change_password";
//   const ChangePassword({
//     Key? key,
//     this.otp,
//   }) : super(key: key);
//   final String? otp;
//
//   @override
//   _ChangePasswordState createState() => _ChangePasswordState();
// }
//
// class _ChangePasswordState extends ConsumerState<ChangePassword> {
//   bool visible = false;
//   bool progress = false;
//   final GlobalKey<FormState> _form = GlobalKey<FormState>();
//   final TextEditingController _confirmPass = TextEditingController();
//   final TextEditingController _pass = TextEditingController();
//  bool isEnabled = false;
//   @override
//   Widget build(BuildContext context) {
//        bool isEmpty() {
//       setState(() {
//         if (_pass.text.isNotEmpty &&
//            _confirmPass.text.isNotEmpty
//          ) {
//           isEnabled = true;
//         } else {
//           isEnabled = false;
//         }
//       });
//       return isEnabled;
//     }
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Container(
//           height: double.infinity,
//           // decoration: const BoxDecoration(
//           //     image: DecorationImage(
//           //       image: AssetImage(
//           //           'assets/images/splash_bg.jfif'
//           //       ),
//           //       filterQuality: FilterQuality.low,
//           //       fit: BoxFit.cover,
//           //       opacity: 0.5,
//           //     )
//           // ),
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.symmetric(
//                   horizontal: getProportionateScreenWidth(36.0)),
//               child: Column(
//                 // mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Image.asset("assets/images/social.png"),
//                   Text(
//                     "Create new password",
//                     style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: getFontSize(24),
//                         fontWeight: FontWeight.w600,
//                         // fontFamily: 'Ubuntu'
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(
//                         top: getProportionateScreenHeight(20.0),
//                         bottom: getProportionateScreenHeight(40.0)),
//                     child: Text(
//                       "Your new password must be different from your previously used passwords.",
//                       style: TextStyle(
//                         fontSize: getFontSize(16),
//                         color: Colors.grey,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   Form(
//                     key: _form,
//                     child: Column(
//                       children: [
//                         TextFormField(
//                           controller: _pass,
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return "Empty Field.";
//                             } else if (!atleastOneLowerCase.hasMatch(value)) {
//                               return "Must contain atleast 1 lowercase letter";
//                             } else if (!atLeastOneUpperCase.hasMatch(value)) {
//                               return "Must contain atleast 1 uppercase letter";
//                             } else if (!atleastOneDigit.hasMatch(value)) {
//                               return "Must contain atleast 1 digit";
//                             } else if (!atleastOneSpecial.hasMatch(value)) {
//                               return "Must contain atleast 1 special character";
//                             } else if (value.length < 6) {
//                               return "Password too short!";
//                             }
//                             return null;
//                           },
//                           cursorColor: primary_color,
//                           onChanged: (val) {
//                             isEmpty();
//                           },
//                           decoration: kInputDecoration.copyWith(
//                               hintText: "Password",
//                               hintStyle: const TextStyle(color: Colors.grey,),
//                               suffixIcon: IconButton(
//                                 icon: Icon(
//                                   visible
//                                       ? Icons.visibility_outlined
//                                       : Icons.visibility_off_outlined,
//                                   color: kOrange,
//                                   size: getProportionateScreenWidth(18.0),
//                                 ),
//                                 onPressed: () {
//                                   setState(() {
//                                     visible = !visible;
//                                   });
//                                 },
//                               )),
//                           obscureText: !visible,
//                         ),
//                         SizedBox(
//                           height: getProportionateScreenHeight(25.0),
//                         ),
//                         TextFormField(
//                           controller: _confirmPass,
//                           onChanged: (val) {
//                             isEmpty();
//                             },
//                           validator: (val) {
//                             if (val!.isEmpty  ) return 'Empty Field.';
//                             if (val != _pass.text) {
//                               return 'Passwords do not match';
//                             }
//                             return null;
//                           },
//                           decoration: kInputDecoration.copyWith(
//                             hintText: "Confirm Password",
//                             hintStyle: const TextStyle(color: Colors.grey,),
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 visible
//                                     ? Icons.visibility_outlined
//                                     : Icons.visibility_off_outlined,
//                                 color: kOrange,
//                                 size: getProportionateScreenWidth(18.0),
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   visible = !visible;
//                                 });
//                               },
//                             ),
//                           ),
//                           obscureText: !visible,
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: getProportionateScreenHeight(30.0),
//                   ),
//                   if(progress)
//                     kProgressIndicator, //show loading if api call is in progress
//                   FlatButtonCustom(
//                       // label: 'SIGN UP',
//                       label: "Reset Password",
//                       onTap: () async {
//                         if (_form.currentState!.validate()) {
//                           setState(() {
//                             progress = true;
//                           });
//                           ref.read(loadingProvider.notifier).state = true;
//                           bool? reset = await (ref
//                               .read(authControllerProvider.notifier)
//                               .resetPassword(
//                                   // otp: widget.otp,
//                                   email: widget.otp,
//                                   password: _pass.text,
//                                   password2: _confirmPass.text));
//                           if (reset!) {
//                             setState(() {
//                               progress = false;
//                             });
//                             ref.read(loadingProvider.notifier).state = false;
//                             showDialog(
//                                 barrierDismissible: false,
//                                 context: context,
//                                 builder: (context) {
//                                   return AlertDialog(
//                                     contentPadding: EdgeInsets.fromLTRB(
//                                       getProportionateScreenWidth(32),
//                                       getProportionateScreenHeight(60),
//                                       getProportionateScreenWidth(32),
//                                       getProportionateScreenHeight(60),
//                                     ),
//                                     content: Column(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Text(
//                                           "Congratulations! ",
//                                           style: TextStyle(
//                                               color: primary_color,
//                                               fontSize: getFontSize(24),
//                                               fontWeight: FontWeight.w600,
//                                               // fontFamily: 'Ubuntu'
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: EdgeInsets.only(
//                                               top: getProportionateScreenHeight(
//                                                   18.0),
//                                               bottom:
//                                                   getProportionateScreenHeight(
//                                                       23.0)),
//                                           child: Text(
//                                             "Your password has been changed successfully.  ",
//                                             style: TextStyle(
//                                               fontSize: getFontSize(16),
//                                             ),
//                                             textAlign: TextAlign.center,
//                                           ),
//                                         ),
//                                         Stack(
//                                           children: [
//                                             FlatButtonCustom(
//                                                 label: "Let’s go again",
//                                                 onTap: () {
//                                                   Navigator.of(context)
//                                                       .pushAndRemoveUntil(MaterialPageRoute(builder:
//                                                       (context) => const Login()),
//                                                           (route) => false);
//                                                 }),
//                                             Positioned(
//                                               right:
//                                                   getProportionateScreenWidth(12),
//                                               top: getProportionateScreenHeight(
//                                                   10.0),
//                                               bottom:
//                                                   getProportionateScreenHeight(
//                                                       10.0),
//                                               child: Image.asset(
//                                                   "assets/images/biceps_emoji.png"),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 });
//                           } else {
//                             ref.read(loadingProvider.notifier).state = false;
//                             showSnackBar(context,
//                                 text: "Unable to reset password");
//                           }
//                         }
//                       }),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class UpperCaseTextFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     return TextEditingValue(
//       text: newValue.text.toUpperCase(),
//       selection: newValue.selection,
//     );
//   }
// }
