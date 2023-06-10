import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/core/utils/constants/color_to_hex.dart';
import 'package:megas/core/utils/constants/navigator.dart';
import 'package:megas/core/utils/constants/size_config.dart';
import 'package:megas/core/utils/constants/themes.dart';
import 'package:megas/core/utils/custom_widgets/list_tiles.dart';
import 'package:megas/src/controllers/auth.dart';
import 'package:megas/src/services/auth/auths_impl.dart';
import 'package:megas/src/useless.dart';
import 'package:megas/src/views/profile/profile_page.dart';
import 'package:megas/src/views/settings/components/account_compos/compos/event.dart';


class DrawerView extends ConsumerWidget {
  const DrawerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef? widgetRef) {
    // previously wrapped with container
    final uid = widgetRef?.watch(authProviderK).value?.uid;
    final user = widgetRef?.watch(userDetailProvider).value;
    final notifier = widgetRef!.watch(themeNotifierProvider);
    // final isNotified = widgetRef.watch(themeNotifierProvider.notifier).isDarkMode;
    return Drawer(
      child: Padding(
          padding: EdgeInsets.only(
              right: getProportionateScreenWidth(80)),
        child: Container(
          // color: Colors.white,
          child: Padding(padding: EdgeInsets.only(top: getProportionateScreenHeight(30),
              left: getProportionateScreenWidth(20),),
            child: Column(children: [
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: (){
                    popcontext(context);
                  },
                  child: Icon(Icons.cancel_outlined),
                ),
              ),
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(user!.avatarUrl),///profile image
                ),
              ),
              const SizedBox(height: 40,),
              Tiles(title: 'Profile', subtitle: '', leading: Icon(Icons.person,
                color: Theme.of(context).primaryColorDark,
              ), onTap: (){

                push(context, ProfilePage(userId: uid!));
              }),
              // Tiles(title: 'Settings', subtitle: '', leading: const Icon(Icons.settings), onTap: (){}),
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 20),
              //   child: SwitchListTile(
              //     title: Text('Theme', style: Theme.of(context).textTheme.bodyMedium,),
              //       // value: notifier.darkTheme,
              //       value: notifier  == ThemeMode.dark,
              //       onChanged: (onChanged){
              //       widgetRef.read(themeNotifierProvider.notifier).changeTheme(onChanged);
              //   }),
              // ),

              Tiles(title: 'Account', subtitle: '', leading: Icon(Icons.account_balance_rounded,
                color: Theme.of(context).primaryColorDark,
              ), onTap: (){
                push(context, FeedPageK());
              }),

              Tiles(title: 'Events', subtitle: '', leading: Icon(Icons.event,
                color: Theme.of(context).primaryColorDark,
              ), onTap: (){
                push(context, Events());
              }),
              const SizedBox(height: 10,),
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: (){
                    widgetRef?.read(authControllerProvider.notifier).logout();
                  },
                  child: Text('Log Out',style: TextStyle(
                      color: kOrange,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),),
                ),
              ),

              const SizedBox(height: 40,),
            ],
            ),
          ),
        ),
      ),
    );
  }
}
