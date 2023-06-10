import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:megas/core/utils/constants/color_to_hex.dart';
import 'package:megas/core/utils/constants/navigator.dart';
import 'package:megas/core/utils/constants/regex.dart';
import 'package:megas/core/utils/constants/size_config.dart';
import 'package:megas/core/utils/custom_widgets/alert_dialog.dart';
import 'package:megas/core/utils/custom_widgets/app_bar.dart';
import 'package:megas/src/controllers/chat_controller.dart';
import 'package:megas/src/models/chat_contact.dart';
import 'package:megas/src/views/chat/screens/mobile_chat_screen.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {


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
                child: Text("Chat's  will be\n displayed here",
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
      appBar: appBar(context, 'Chats', true, false),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16,right: 16, bottom: 20),
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
          SizedBox(height: 2,),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: StreamBuilder<List<ChatContact>>(
                  stream: ref.watch(chatControllerProvider).chatContacts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return kProgressIndicator;
                    }
                    if (snapshot.data!.isEmpty) {
                      return emptyList();
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var chatContactData = snapshot.data![index];

                        return Padding(
                          padding: EdgeInsets.only(bottom: 8.0, left: getProportionateScreenWidth(20), right: getProportionateScreenWidth(20),),
                          child: InkWell(
                            onLongPress: (){
                              showDialog<void>(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertBox(
                                      titleText: 'Wanna delete this chat?',
                                      del: (){
                                        final del = ref.read(chatControllerProvider);
                                        del.deleteChat(chatContactData.contactId); // TODO
                                        Navigator.pop(context);
                                      },
                                      edit: (){},
                                    );
                                  });
                            },
                            onTap: () {
                              push(context, MobileChatScreen(name: chatContactData.name, uid: chatContactData.contactId,
                                  isGroupChat: false, profilePic: chatContactData.profilePic));
                            },
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(12, 13, 12, 11),
                              margin:
                              EdgeInsets.symmetric(vertical: getProportionateScreenHeight(10)),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.15),
                                      blurRadius: 5,
                                    ),
                                  ]),
                              child: ListTile(
                                title: Text(
                                  chatContactData.name,
                                  style: const TextStyle(
                                    // fontSize: 18,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    chatContactData.lastMessage,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    chatContactData.profilePic,
                                  ),
                                  radius: 30,
                                ),
                                trailing: Text(
                                  DateFormat.Hm()
                                      .format(chatContactData.timeSent),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
