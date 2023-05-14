import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/core/utils/constants/consts.dart';
import 'package:megas/core/utils/constants/exceptions.dart';
import 'package:megas/core/utils/constants/general_provider.dart';
import 'package:megas/core/utils/constants/regex.dart';
import 'package:megas/core/utils/constants/size_config.dart';
import 'package:megas/core/utils/custom_widgets/buttons.dart';
import 'package:megas/core/utils/custom_widgets/text_fields.dart';
import 'package:megas/src/controllers/auth.dart';
import 'check_your_mail.dart';




class ForgotPassword extends ConsumerStatefulWidget {
  ForgotPassword({Key? key}) : super(key: key);

  @override
  ConsumerState<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends ConsumerState<ForgotPassword> {
  // static String routeName = "/forgot_password";
  final _formKey = GlobalKey<FormState>();
  bool progress = false;
  final TextEditingController _email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.only(
            top: getProportionateScreenHeight(80),
            right: getProportionateScreenWidth(25),
            left: getProportionateScreenWidth(31),
            bottom: getProportionateScreenHeight(50)
        ),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 25,
                  ),
                ),

                const SizedBox(height: 40,),

                UnderlineField(
                  label: '',
                  obscure: false,
                  controller: _email, validator: (val){
                  if (val!.isEmpty || !_email.text.contains('@')) {
                    return 'Please enter valid email';
                  }else {
                    return null;
                  }
                }, hint: 'Email address', keyboardType: TextInputType.text,),

                const SizedBox(height: 67,),
                if(progress)
                  kProgressIndicator, //show loading if reset button is pressed
                FlatButton(label: 'RESET PASSWORD',
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      ref.read(loadingProvider.state)
                          .state = true;
                      setState(() {
                        progress = true;
                      });
                      Map<String, dynamic>? response = await ref
                          .read(authControllerProvider.notifier)
                          .forgetPassword(_email.text)
                          .catchError((e) {
                        ref.read(loadingProvider.state)
                            .state = false;
                        setState(() {
                          progress = false;
                        });
                        if (e is FirebaseAuthException) {
                          showSnackBar(context, text: e.message!);
                        } else {
                          setState(() {
                            progress = false;
                          });
                          ref.read(loadingProvider.state)
                              .state = false;
                          showSnackBar(context, text: "Something is wrong!");
                        }
                      });
                      if(response != null) {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => CheckYourMail(
                            otp: '0000')), (route) => false);
                      }
                    }
                  }
                  ),
                const SizedBox(height: 30,),
                const Text(
                  'Or',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),

                const Spacer(),
                FlatButton(label: 'Back', onTap: (){
                  Navigator.pop(context);
                }, ),
                const SizedBox(height: 60,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

