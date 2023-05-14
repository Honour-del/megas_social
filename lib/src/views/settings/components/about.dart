import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:megas/core/utils/constants/navigator.dart';
import 'package:megas/core/utils/custom_widgets/app_bar.dart';
import 'package:megas/src/views/settings/components/help.dart';
import 'package:megas/src/views/settings/header_widget.dart';
import 'package:url_launcher/url_launcher.dart';


class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String trues = 'Push Notifications';
  String txt = 'Help';
  String truth = 'Terms of service';
  String data = 'Privacy policy';
  String twit = 'Follow us on Twitter';
  String inst = 'Follow us on Instagram';
  String git = 'Follow us on GitHub';

  String soc = 'Social' ;

  Future<void> openUrl(String url, {bool forceWebView = false, bool enableJavaScript = false}) async{
    if(await canLaunch(url)) {
      await launch(url, forceWebView: forceWebView, enableJavaScript: enableJavaScript);
    }
  }

  aboutApp() {
    return Container(
      child: Column(
        children: [
          HeaderWidget(soc),
          Divider(),
          ListTile(
            title: Text(twit, style: Theme
                .of(context)
                .textTheme
                .subtitle1,),
            leading: FaIcon(FontAwesomeIcons.twitter, size: 25,),
            onTap: () async{
              await openUrl("twitter.com/basharsherifs?s=09", forceWebView: false, enableJavaScript: true);
            },
          ),
          Divider(),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.instagram, size: 25,),
            title: Text(inst, style: Theme
                .of(context)
                .textTheme
                .subtitle1,),
            onTap: () async {
              await openUrl("github.com/Honour-del/Pusheat-with-me");
            },
          ),
          Divider(),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.github, size: 25,),
            title: Text(git, style: Theme
                .of(context)
                .textTheme
                .subtitle1,),
            onTap: () async {
              await openUrl("github.com/Honour-del");
            },
          ),
          Divider(),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'About', false, true ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.help,size: 25,),
                title: Text("Help",style: Theme.of(context).textTheme.subtitle1,),
                subtitle: Text("Help and support center "),
                onTap: () => push(context, Help()),
              ),
              HeaderWidget('Legal'),
              ListTile(
                leading: Icon(Icons.security,size: 25,),
                title: Text("Privacy and policy",style: Theme.of(context).textTheme.subtitle1,),
                onTap: () => "go to chat settings",
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.computer,size: 25,),
                title: Text("Term or services",style: Theme.of(context).textTheme.subtitle1,),
                onTap: () => "go to chat settings",
              ),
              ListTile(
                leading: Icon(Icons.note,size: 25,),
                title: Text("Legal notices",style: Theme.of(context).textTheme.subtitle1,),
                onTap: () => "go to chat settings",
              ),
              Divider(),
              aboutApp()
            ],
          ),
        ),
      ),
    );
  }

  // privacy(){
  //   return Navigator.of(context).push(BouncyPageRoute(widget:PrivacyPages()));//not yet created
  // }
}
