import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/core/utils/constants/color_to_hex.dart';
import 'package:megas/core/utils/constants/consts.dart';
import 'package:megas/core/utils/constants/general_provider.dart';
import 'package:megas/core/utils/constants/navigator.dart';
import 'package:megas/core/utils/constants/regex.dart';
import 'package:megas/core/utils/constants/size_config.dart';
import 'package:megas/core/utils/custom_widgets/buttons.dart';
import 'package:megas/core/utils/custom_widgets/text_fields.dart';
import 'package:megas/src/controllers/auth.dart';
import 'package:megas/src/services/shared_prefernces.dart';
import 'package:megas/src/views/home/navigation.dart';
import 'package:megas/src/views/login/component/forgot_password/forgot_password.dart';


class Login extends ConsumerStatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  ConsumerState<Login> createState() => _LoginState();
}
bool _secureText = true;
bool isLoading = false;
final loginKey = GlobalKey<FormState>();
final email = TextEditingController();
final password = TextEditingController();
final prefs = Preferences();

class _LoginState extends ConsumerState<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(left: getProportionateScreenWidth(22), top: getProportionateScreenHeight(180), right: 25),
          child: Form(
            key: loginKey,
            child: Column(
              children: [

                // SizedBox(),
                Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text( //smiley.png
                              "Welcome back ",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  color: primary_color,
                                  fontSize: getFontSize(23),
                                  fontWeight: FontWeight.w700
                              ),
                            ),
                            Image.asset('assets/images/smiley.png'),
                          ],
                        ),
                        Text( //smiley.png
                          "you've been missed!",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              color: primary_color,
                              fontSize: getFontSize(23),
                              fontWeight: FontWeight.w700
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20,),

                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Login to continue!',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        color: secondary_color,
                        fontSize: getFontSize(19),
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ),

                /// email
                UnderlineField(label: 'Email', hint: 'alienwear@gmail.com', keyboardType: TextInputType.emailAddress, obscure: false,
                  controller: email,
                  validator: (val){
                    if(!val!.contains('@'))
                      return 'Email is not valid';
                    return null;
                  },
                ),
                /// password
                UnderlineField(label: 'Password', hint: r'@1$@^password', keyboardType: TextInputType.text, obscure: _secureText,
                    controller: password,
                    validator: (val){
                      if(val!.length < 7)
                        return 'Password is too short';
                      if(val.isEmpty || val == '')
                        return 'Password must be at least 7 chars';
                      return null;
                    },
                    suffixIcon: IconButton(
                        icon: Icon(
                          (_secureText
                              ? Icons.remove_red_eye
                              : Icons.security),
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _secureText = !_secureText;
                          });
                        }
                    )),

                const SizedBox(height: 50,),
                if(isLoading)
                  kProgressIndicator,
                FlatButtonCustom(onTap: (){
                  loginAction();
                }, label: "Login"),

                const SizedBox(height: 24,),

                TextButton(onPressed: () {
                  push(context, ForgotPassword());
                }, child: Text(
                  'Forgot password?',
                  style: TextStyle(
                    fontSize: getFontSize(18.5),
                    color: kOrange,
                  ),
                )),
                // const SizedBox(height: 30,),
              ],
            ),
          ),
        ),
      ),
    );
  }

   void loginAction() async{
    if(loginKey.currentState!.validate()){
      loginKey.currentState!.save();
      setState(() {
        isLoading = true;
      });
      ref.read(loadingProvider.notifier).state = true;
      final auth  = await ref.read(authControllerProvider.notifier);
      final response = await auth.login(email.text, password.text);
      //// after login function is completed
      response.fold((e) {
        //// if error is detected loading will stop and this task will come to live
        ref.read(loadingProvider.notifier).state =false;
        setState(() {
          isLoading = false;
        });
        if (e is FirebaseAuthException) {
          showSnackBar(context, text: e.message!);
        }
        showSnackBar(context, text: 'Error: $e');
        debugPrint('Error: $e');
      }, (tokens) async{
        ref.read(loadingProvider.notifier).state =false;
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
            builder: (context) => Nav()), (route) => false);
      });
    }
  }
}