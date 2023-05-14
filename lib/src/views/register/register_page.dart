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
// import 'package:megas/src/views/home/navigation.dart';
import 'package:megas/src/views/login/login_page.dart';
import 'package:megas/src/views/register/components/take_selfie/take_selfie.dart';
// import 'package:megas/src/views/register/components/otp_page.dart';


class Register extends ConsumerStatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  ConsumerState<Register> createState() => _RegisterState();
}
 bool _secureText = true;
final name = TextEditingController();
final email = TextEditingController();
final password= TextEditingController();
final prefs = Preferences();
final _formKey = GlobalKey<FormState>();
String? username;
class _RegisterState extends ConsumerState<Register> {
  @override
  Widget build(BuildContext context) {
    // final auth = ref.watch(authControllerProvider);
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),///
        child: Padding(
          padding: EdgeInsets.only(left: getProportionateScreenWidth(39), top: getProportionateScreenHeight(180), right: 50),
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Welcome to megas',
                    style: TextStyle(
                      color: primary_color,
                      fontSize: getFontSize(23),
                      fontWeight: FontWeight.w700
                    ),
                  ),
                ),

                const SizedBox(height: 20,),

                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Create an account to\ncontinue',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        color: secondary_color,
                        fontSize: getFontSize(19),
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ),

                /// name
                UnderlineField(label: 'Name', hint: 'alienwear', keyboardType: TextInputType.text, obscure: false, controller: name,
                  validator: (val){
                    if(val!.length < 3)
                      return 'Pls use a valid name';
                    return null;
                  },
                ),
                /// email
                UnderlineField(label: 'Email', hint: 'alienwear@gmail.com', keyboardType: TextInputType.emailAddress, obscure: false,
                  validator: (val){
                    if(!val!.contains('@'))
                      return 'Email is not valid';
                    return null;
                  },
                  controller: email,),
                /// password
                UnderlineField(label: 'Password', hint: r'@1$@^password', keyboardType: TextInputType.text, obscure: _secureText, controller: password,
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
                FlatButton(onTap: (){
                  registerAction();
                  // push(context, Nav());
                } /// go to selfie page TakeSelfie()
                    , label: "Register"),

                const SizedBox(height: 24,),

                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Already an existing User?',
                        style: TextStyle(
                          fontSize: getFontSize(16.5),
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 3,),
                      TextButton(onPressed: () {
                        pushreplacement(context,const Login());
                      }, child: Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: getFontSize(16.5),
                          color: primary_color,
                        ),
                      )),
                    ],),
                ),
                // const SizedBox(height: 30,),

              ],
            ),
          ),
        ),
      ),
    );
  }

  void registerAction() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      setState(() {
        isLoading = true;
      });
      ref
          .read(loadingProvider.notifier)
          .state = true;
      final auth = await ref.read(authControllerProvider.notifier);
      username = name.text.split('').first;
      final response = await auth.register(email: email.text,
          password: password.text,
          name: username!,);
      //// after login function is completed
      response.fold((e) {
        //// if error is detected loading will stop and this task will come to live
        setState(() {
          isLoading = false;
        });
        ref
            .read(loadingProvider.notifier)
            .state = false;
        showSnackBar(context, text: 'Error: $e');
        debugPrint('Error: $e');
      }, (status) async {
          setState(() {
            isLoading = false;
          });
          ref
              .read(loadingProvider.notifier)
              .state = false;
          showSnackBar(
              context, text: "Sign Up successful!");
          // Navigator.of(context)
          //     .pushAndRemoveUntil(MaterialPageRoute(
          //     builder: (context)
          //     => const Login()), (route) => false);
          Navigator.of(context) //TODO
              .pushAndRemoveUntil(MaterialPageRoute(
              builder: (context)
              => TakeSelfie()), (route) => false);
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) =>
          //           OtpVerification(
          //             fullName: name!.text,
          //             phoneNumber: 'Edit profile to update phoneNumber',
          //             email: email!.text,
          //             password: password!.text,
          //           )
          //   ),
          // );
        // else {
        //   setState(() {
        //     isLoading = false;
        //   });
        //   ref
        //       .read(loadingProvider.notifier)
        //       .state = false;
        //   showSnackBar(
        //       context, text: "Sign Up unsuccessful!");
        // }
      });
    }
  }
}