import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:megas/core/utils/constants/color_to_hex.dart';
import 'package:megas/core/utils/constants/navigator.dart';
import 'package:megas/core/utils/constants/size_config.dart';
import 'package:megas/src/useless.dart';



PreferredSizeWidget appBar(BuildContext context, String title, bool? autolead,  bool? lead, {Widget? widget}) {
  // Widget? widget;
  VoidCallback? onTap;
  return AppBar(
    automaticallyImplyLeading: autolead!,
    toolbarHeight: 70,////80
    backgroundColor: Colors.transparent,
    elevation: 0.0,
    iconTheme: IconThemeData(color: primary_color),
    // leading: Text('yes'),
    shadowColor: Colors.transparent,
    flexibleSpace: Center(
      child: Padding(
        padding: const EdgeInsets.only(
            // top: 30,
            left: 12,
            right: 12
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            lead! ? IconButton(onPressed: (){popcontext(context);}, icon: FaIcon(FontAwesomeIcons.arrowLeft, color: primary_color)) : SizedBox.shrink(),
            SizedBox(width: getProportionateScreenWidth(75),),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 18,
                  // fontFamily: "MISTRAL",
                  // fontWeight: FontWeight.w500,
                  color: Colors.black
              ),
            ),

            SizedBox(width: getProportionateScreenWidth(75),),
            InkWell(
              onTap: onTap,
                child: widget ?? IconButton(onPressed: (){
                  push(context, HomePage());
                }, icon: FaIcon(FontAwesomeIcons.magnifyingGlass, color: primary_color))),
            // SizedBox(width: getProportionateScreenWidth(12),),
          ],
        ),
      ),
    ),
  );
}
// class AppBars extends StatefulWidget {
//   const AppBars({Key? key}) : super(key: key);
//
//   @override
//   State<AppBars> createState() => _AppBarsState();
// }
//
// class _AppBarsState extends State<AppBars> with TickerProviderStateMixin{
//   late TabController _controller;
//
//   @override
//   void initState(){
//     super.initState();
//     _controller = TabController(length: 3, vsync: this);
//     _controller.animateTo(2);
//   }
//
//     static const List<Tab> _tabs = [
//     Tab(child: Text(
//       'LOCATION',
//       style: TextStyle(
//         fontSize: 20,
//         fontWeight: FontWeight.w700,
//       ),
//     ),),
//     Tab(child: Text(
//       'EVENT',
//       style: TextStyle(
//         fontSize: 20,
//         fontWeight: FontWeight.w700,
//       ),
//     ),),
//     Tab(child: Text(
//       'CATEGORIES',
//       style: TextStyle(
//         fontSize: 20,
//         fontWeight: FontWeight.w700,
//       ),
//     ),)
//   ];
//
//   static const List<Widget> _widget = [
//
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       automaticallyImplyLeading: false,
//       toolbarHeight: 80,
//       backgroundColor: Colors.transparent,
//       elevation: 0.0,
//       // leading: Text('yes'),
//       shadowColor: Colors.transparent,
//       bottom: TabBar(
//           controller: _controller,
//           tabs: _tabs,
//       ),
//       flexibleSpace: Center(
//         child: Padding(
//           padding: const EdgeInsets.only(
//               left: 20,
//               right: 20
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: SizedBox(
//                   child: Row(
//                     children: const[
//                       Text(
//                         'Welcome',
//                         style: TextStyle(
//                             fontSize: 16,
//                             // fontFamily: "MISTRAL",
//                             // fontWeight: FontWeight.w500,
//                             color: Colors.black
//                         ),
//                       ),
//                       ImageIcon(
//                         AssetImage('images/welcome.png',),
//                         color: kOrange,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               IconButton(onPressed: (){}, icon: const FaIcon(FontAwesomeIcons.search))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// class Bar extends StatefulWidget {
//   const Bar({Key? key}) : super(key: key);
//
//   @override
//   State<Bar> createState() => _BarState();
// }
//
// class _BarState extends State<Bar> with TickerProviderStateMixin{
//   late TabController _controller;
//
//   @override
//   void initState(){
//     super.initState();
//     _controller = TabController(length: 3, vsync: this);
//     _controller.animateTo(2);
//   }
//
//   static const List<Tab> _tabs = [
//     Tab(child: Text(
//       'LOCATION',
//       style: TextStyle(
//         fontSize: 20,
//         fontWeight: FontWeight.w700,
//       ),
//     ),),
//     Tab(child: Text(
//       'EVENT',
//       style: TextStyle(
//         fontSize: 20,
//         fontWeight: FontWeight.w700,
//       ),
//     ),),
//     Tab(child: Text(
//       'CATEGORIES',
//       style: TextStyle(
//         fontSize: 20,
//         fontWeight: FontWeight.w700,
//       ),
//     ),)
//   ];
//
//   static const List<Widget> _widget = [
//
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return const TabBar(
//         tabs: _tabs
//     );
//   }
// }
//
