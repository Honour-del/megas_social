import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/core/utils/constants/color_to_hex.dart';
import 'package:megas/core/utils/constants/navigator.dart';
import 'package:megas/core/utils/constants/size_config.dart';
import 'package:megas/core/utils/custom_widgets/list_tiles.dart';
import 'package:megas/src/services/auth/auths_impl.dart';
import 'package:megas/src/views/profile/profile_page.dart';
import 'package:megas/src/views/settings/components/account_compos/compos/event.dart';


class DrawerView extends ConsumerWidget {
  const DrawerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef? widgetRef) {
    // previously wrapped with container
    final uid = widgetRef?.watch(authProviderK).value?.uid;
    print("This is uid___: $uid");
    return Padding(
        padding: EdgeInsets.only(
            right: getProportionateScreenWidth(80)),
      child: Container(
        color: Colors.white,
        child: Padding(padding: EdgeInsets.only(top: getProportionateScreenHeight(30),
            left: getProportionateScreenWidth(20),),
          child: Column(children: [
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: (){
                  popcontext(context);
                },
                child: const Icon(Icons.cancel_outlined),
              ),
            ),
            const Center(
              child: CircleAvatar(
                radius: 50,
                // backgroundImage: ,///profile image
              ),
            ),
            const SizedBox(height: 40,),
            Tiles(title: 'Profile', subtitle: '', leading: const Icon(Icons.person), onTap: (){

              push(context, ProfilePage(userId: uid!));
            }),
            Tiles(title: 'Settings', subtitle: '', leading: const Icon(Icons.settings), onTap: (){}),

            Tiles(title: 'Account', subtitle: '', leading: const Icon(Icons.account_balance_rounded), onTap: (){}),

            Tiles(title: 'Events', subtitle: '', leading: const Icon(Icons.sunny), onTap: (){
              push(context, Events());
            }),
            const Spacer(),

            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: (){},
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
    );
  }
}
