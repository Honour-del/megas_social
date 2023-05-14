import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/core/utils/constants/color_to_hex.dart';
import 'package:megas/core/utils/constants/images.dart';
import 'package:megas/core/utils/constants/size_config.dart';
import 'package:megas/core/utils/custom_widgets/app_bar.dart';
import 'package:megas/src/controllers/chat.dart';
import 'package:megas/src/models/chat.dart';
import 'package:megas/src/views/chat/chat_list/chat_list.dart';


//// Chat list page
class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({Key? key}) : super(key: key);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  //
  bool isEmpty = true;
  @override
  Widget build(BuildContext context) {
    final data  = ref.watch(chatProvider);
    emptyList(){
      return Center(
        child: Container(
          height: getProportionateScreenHeight(158),//280
          width: getProportionateScreenWidth(250),//158
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: Colors.grey,
                width: 5
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 20,),
              Align(
                alignment: Alignment.topCenter,
                child: Text('Chat list is empty',
                  style: TextStyle(
                    color: primary_color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Spacer(),

              Align(
                alignment: Alignment.topCenter,
                child: Text('Chat list will be\n displayed here',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: primary_color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 25,),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: appBar(context, 'Chats', false, true),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16,left: 16,right: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(Icons.search,color: Colors.grey.shade600, size: 20,),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey.shade100
                      )
                  ),
                ),
              ),
            ),
            data.when(data: (chat)=> !isEmpty ? Align(
                alignment: Alignment.center,
                child: emptyList()) : ListView.builder(
              itemCount: chat.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 16),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
                return ConversationList(
                  id: chat[index].id as String,
                  name: chat[index].user!.name,
                  username: chat[index].user!.username,
                  messageText: chat[index].messages as String,
                  imageUrl: chat[index].user!.avatarUrl,
                  time: chat[index].lastMessageSendAt as String,
                  isMessageRead: (index == 0 || index == 3)?true:false,
                );
              },
            ),
                error: (error,_) => throw error.toString(),
                loading: ()=> CircularProgressIndicator()
            ),
          ],
        ),
      ),
    );
  }
}