// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:megas/core/utils/constants/color_to_hex.dart';
// import 'package:megas/core/utils/constants/navigator.dart';
// import 'package:megas/core/utils/constants/size_config.dart';
// import 'package:megas/core/utils/custom_widgets/app_bar.dart';
// import 'package:megas/src/controllers/chat.dart';
// import 'package:megas/src/views/chat_f/screens/mobile_chat_screen.dart';
//
//
// //// Chat list page
// class ChatPage extends ConsumerStatefulWidget {
//   const ChatPage({Key? key}) : super(key: key);
//   @override
//   _ChatPageState createState() => _ChatPageState();
// }
//
// class _ChatPageState extends ConsumerState<ChatPage> {
//
//   @override
//   Widget build(BuildContext context) {
//     final data  = ref.watch(chatContactProvider);
//     emptyList(){
//       return Center(
//         child: Container(
//           height: getProportionateScreenHeight(158),//280
//           width: getProportionateScreenWidth(250),//158
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(
//                 color: Colors.grey,
//                 width: 5
//             ),
//           ),
//           child: Column(
//             children: [
//               const SizedBox(height: 20,),
//               Align(
//                 alignment: Alignment.topCenter,
//                 child: Text('Chat list is empty',
//                   style: TextStyle(
//                     color: primary_color,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//
//               const Spacer(),
//
//               Align(
//                 alignment: Alignment.topCenter,
//                 child: Text('Chat list will be\n displayed here',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: primary_color,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 25,),
//             ],
//           ),
//         ),
//       );
//     }
//
//     return Scaffold(
//       appBar: appBar(context, 'Chats', false, false),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.only(left: 16,right: 16),
//             child: TextField(
//               decoration: InputDecoration(
//                 hintText: "Search...",
//                 hintStyle: TextStyle(color: Colors.grey.shade600),
//                 prefixIcon: Icon(Icons.search,color: Colors.grey.shade600, size: 20,),
//                 filled: true,
//                 fillColor: Colors.grey.shade100,
//                 contentPadding: const EdgeInsets.all(8),
//                 enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(20),
//                     borderSide: BorderSide(
//                         color: Colors.grey.shade100
//                     )
//                 ),
//               ),
//             ),
//           ),
//           data.when(data: (chat)=> (chat.isEmpty) ? Align(
//               alignment: Alignment.center,
//               child: emptyList()) : ListView.builder(
//             itemCount: chat.length,
//             shrinkWrap: true,
//             padding: const EdgeInsets.only(top: 0),
//             physics: const BouncingScrollPhysics(),
//             itemBuilder: (context, index){
//               return _ConversationList(
//                 id: chat[index].id as String,
//                 name: chat[index].user!.name,
//                 username: chat[index].user!.username,
//                 messageText: chat[index].lastMessage as String,
//                 imageUrl: chat[index].user!.avatarUrl,
//                 time: chat[index].lastMessageSendAt as String,
//                 isMessageRead: (index == 0 || index == 3)?true:false,
//               );
//             },
//           ),
//               error: (error,_) => throw error.toString(),
//               loading: ()=> CircularProgressIndicator()
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
// class _ConversationList extends StatefulWidget{
//   final String id;
//   final String name;
//   final String username;
//   final String messageText;
//   final String imageUrl;
//   final String time;
//   final bool isMessageRead;
//   const _ConversationList({Key? key, required this.name,required this.messageText,required this.imageUrl,required this.time,required this.isMessageRead, required this.id, required this.username}) : super(key: key);
//   @override
//   _ConversationListState createState() => _ConversationListState();
// }
//
// class _ConversationListState extends State<_ConversationList> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: (){
//         // push(context, ChatDetailPage(username: widget.username, receiverId: widget.id,));
//         push(context, MobileChatScreen(name: widget.name, uid: widget.id, isGroupChat: false, profilePic: widget.imageUrl));
//       },
//       child: Container(
//         padding: const EdgeInsets.only(left: 16,right: 16,bottom: 10),
//         child: Row(
//           children: <Widget>[
//             Expanded(
//               child: Row(
//                 children: <Widget>[
//                   CircleAvatar(
//                     backgroundImage: AssetImage(widget.imageUrl),
//                     maxRadius: 30,
//                   ),
//                   const SizedBox(width: 16,),
//                   Expanded(
//                     child: Container(
//                       color: Colors.transparent,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Text(widget.name, style: const TextStyle(fontSize: 16),),
//                           const SizedBox(height: 6,),
//                           Text(widget.messageText,style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Text(widget.time,style: TextStyle(fontSize: 12,fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),),
//           ],
//         ),
//       ),
//     );
//   }
// }