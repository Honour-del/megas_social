// ignore_for_file: avoid_print
import 'dart:io';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:animations/animations.dart';
import 'package:circle_list/circle_list.dart';
import 'package:dio/dio.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:megas/core/utils/constants/consts.dart';
import 'package:megas/core/utils/constants/native_calling.dart';
import 'package:megas/core/utils/constants/navigator.dart';
import 'package:megas/core/utils/constants/regex.dart';
import 'package:megas/core/utils/custom_widgets/image_preview.dart';
import 'package:megas/src/controllers/chat.dart';
import 'package:megas/src/local_database/objectbox_chat.dart';
import 'package:megas/src/local_database/sflite_database.dart';
import 'package:megas/src/models/chat.dart';
import 'package:megas/src/models/message.dart';
import 'package:megas/src/models/previous.dart';
import 'package:megas/src/services/auth/auths_impl.dart';
import 'package:megas/src/services/shared_prefernces.dart';
import 'package:megas/src/views/chat/chat_list/message_model.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:record/record.dart';


/* In this file I used "chatId" as username since it is unique */

//Chatting screen
// myKey.

final TextEditingController typedText = TextEditingController();
double chatBoxHeight = 0.0;
bool isLoading = false;
bool writeTextPresent = false;
bool showEmojiPicker = false;
final List<Map<String, String>> allConversationMessages = [];
final List<ChatMessageTypes> chatMessageCategoryHolder = [];

class ChatDetailPage extends ConsumerStatefulWidget{
  final String username;

  ChatDetailPage({Key? key, required this.username}): super(key: key);

  @override
  ChatDetailPageState createState() => ChatDetailPageState();
}

class ChatDetailPageState extends ConsumerState<ChatDetailPage> {
  String? wallpaper;
  ImagePicker _imagePicker = ImagePicker();
  WallPaper wallPapers = WallPaper();
  File? _image;
  bool get isMounted {
    return mounted;
  }

  String get currency => '';


  late final Dio? client;
  // final LocalDatabase _localDatabase = LocalDatabase();
  final NativeCallback _nativeCallback = NativeCallback();
  final List<bool> _conversationMessageHolder = [];
  final Preferences prefs = Preferences();
  final ScrollController _scrollController = ScrollController(
    initialScrollOffset: 0.0,
  );
  late Directory audioDirectory;
  final FToast _fToast = FToast();
  final AudioPlayer _justAudioPlayer = AudioPlayer();
  /// For Audio Player
  IconData _iconData = Icons.play_arrow_rounded;
  String _hintText = "Type Here...";
  String _totalDuration = '0:00';
  String _loadingTime = '0:00';
  late Directory _audioDirectory;

  final Record _record = Record();

  /// Some Integer Value Initialized
  late double _currAudioPlayingTime;
  int _lastAudioPlayingIndex = 0;

  double _audioPlayingSpeed = 1.0;

  Future _setImage() async {
    try {
      final save = ref.read(chatRepositoryProvider);
      final XFile? pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
      if(pickedFile == null) return;
      final imageTemp = File(pickedFile.path);
      setState(() {
        _image = imageTemp;
      });
      print('this works successfully');
      var imageData = ChatWallPaper(
        image: _image!.path,
      );
      save.addNewWallpaper(imageData);
      print('wallpaper set successfully');
    } on PlatformException catch (e) {
      throw('Failed to pick image: $e');
    }
  }

Future<void> localImage() async{
    // ChatWallPaper imageData = ChatWallPaper();
    final image = ref.read(localWallpaper);
    final url = await image;
    // final url = await _localDatabase.localImage();
    /*
    this function will only be called every time wallpaper condition changed
    on the database
     */
    url.when(data: (data){
      setState(() {
        wallpaper = data?.image;
        // wallpaper = imageData.image;
        print(wallpaper);
        // wallpaper = url[0]['Chat_Wallpaper'];
      });
    },
        error: (error, _) {
          return Text(error.toString());
        },
        loading: () => kProgressIndicator
    );
}

  Future deleteImage() async {
    // await _localDatabase.deleteWallpaper();
    ChatWallPaper wallPaperToDelete = ChatWallPaper();
     ref.read(chatRepositoryProvider).
    deleteWallpaper(wallPaperToDelete);
  }

  @override

  void initState(){
    super.initState();
    localImage();
    print('yes');
  }

  Widget build(BuildContext context) {
    // final provider2 = ref.watch(chatServiceProvider);
    chatBoxHeight = MediaQuery.of(context).size.height - 160;
    return WillPopScope(
      onWillPop: () async {
        if (showEmojiPicker) {
          if (mounted) {
            setState(() {
              showEmojiPicker = false;
              chatBoxHeight += 300;
            });
          }
          return false;
        }
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            actions: [
              PopupMenuButton(itemBuilder: (context){
                return [
                  PopupMenuItem(
                    value: 0,
                    child: Text(
                    'Set wallpaper',
                  ),),

                  PopupMenuItem(
                    value: 1,
                    child: Text(
                      'Remove wallpaper',
                    ),),];
                },
                onSelected: (value){
                  if(value == 0){
                    print('set wallpaper');
                    _setImage();
                  }else if(value == 1){
                    print('remove wallpaper');
                  }
                },
              ),
            ],
            flexibleSpace: SafeArea(
              child: Container(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back,color: Colors.black,),
                    ),
                    const SizedBox(width: 2,),
                   const CircleAvatar(
                      // backgroundImage: NetworkImage("<https://randomuser.me/api/portraits/men/5.jpg>"),
                      maxRadius: 20,
                    ),
                    const SizedBox(width: 12,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("Kriss Benwat",style: TextStyle( fontSize: 16 ,fontWeight: FontWeight.w600),),
                          const SizedBox(height: 6,),
                          Text("Online",style: TextStyle(color: Colors.grey.shade600, fontSize: 13),),
                        ],
                      ),
                    ),
                    IconButton(icon: Icon(Icons.settings,color: Colors.black54,),
                      onPressed: (){},
                    ),
                  ],
                ),
              ),
            ),
          ),
        body: Container(
          decoration: wallpaper != null ? BoxDecoration(
            // backgroundBlendMode: BlendMode.darken,
            image: DecorationImage(image: AssetImage(wallpaper!))
          ) : null,
          child: LoadingOverlay(
            isLoading: isLoading,
            color: Colors.black54,
            child: SizedBox(
              width: double.maxFinite,
              height: double.maxFinite,
              //margin: EdgeInsets.all(12.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    width: double.maxFinite,
                    height: chatBoxHeight,
                    padding: const EdgeInsets.only(top: 20.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemCount: allConversationMessages.length,
                      itemBuilder: (itemBuilderContext, index) {
                        if (chatMessageCategoryHolder[index] ==
                            ChatMessageTypes.Text) {
                          return textConversationManagement(
                              itemBuilderContext, index);
                        } else if (chatMessageCategoryHolder[index] ==
                            ChatMessageTypes.Image) {
                          return mediaConversationManagement(
                              itemBuilderContext, index);
                        } else if (chatMessageCategoryHolder[index] ==
                            ChatMessageTypes.Video) {
                          return mediaConversationManagement(
                              itemBuilderContext, index);
                        } else if (chatMessageCategoryHolder[index] ==
                            ChatMessageTypes.Document) {
                          return documentConversationManagement(
                              itemBuilderContext, index);
                        } else if (chatMessageCategoryHolder[index] ==
                            ChatMessageTypes.Location) {
                          return locationConversationManagement(
                              itemBuilderContext, index);
                        } else if (chatMessageCategoryHolder[index] ==
                            ChatMessageTypes.Audio) {
                          return audioConversationManagement(
                              itemBuilderContext, index);
                        }
                        return const Center();
                      },
                    ),
                  ),
                  bottomInsertionPortion(context, widget.username),
                  showEmojiPicker
                      ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 300.0,
                    child: EmojiPicker(
                      onEmojiSelected: (category, emoji) {
                        if (mounted) {
                          setState(() {
                            typedText.text += emoji.emoji;
                            typedText.text.isEmpty
                                ? writeTextPresent = false
                                : writeTextPresent = true;
                          });
                        }
                      },
                      onBackspacePressed: () {
                        // Backspace-Button tapped logic
                        // Remove this line to also remove the button in the UI
                      },
                      config: const Config(
                          columns: 7,
                          emojiSizeMax: 32.0,
                          verticalSpacing: 0,
                          horizontalSpacing: 0,
                          initCategory: Category.RECENT,
                          bgColor: Color(0xFFF2F2F2),
                          indicatorColor: Colors.blue,
                          iconColor: Colors.grey,
                          iconColorSelected: Colors.blue,
                          // progressIndicatorColor: Colors.blue,
                          showRecentsTab: true,
                          recentsLimit: 28,
                          noRecents: Text("No Recents", style: TextStyle(
                              fontSize: 20, color: Colors.black26),),
                          categoryIcons: CategoryIcons(),
                          buttonMode: ButtonMode.MATERIAL),
                    ),
                  )
                      : const SizedBox()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  takePermissionForStorage() async {
    var status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      {
        showToast("Thanks For Allowing The Storage Permission", _fToast,
            toastColor: Colors.green, fontSize: 16.0);

        makeDirectoryForRecordings();
      }
    } else {
      showToast("Some Problem Might Have Disrupt Storage Permission", _fToast,
          toastColor: Colors.green, fontSize: 16.0);
    }
  }

  makeDirectoryForRecordings() async {
    final Directory? directory = await getExternalStorageDirectory();

    audioDirectory = await Directory('${directory!.path}/Recordings/')
        .create(); // This directory will create Once in whole Application
  }

  manageIncomingLocationMessages(var locationMessage,{
    required String userName,
  }) async {
    final saveMe = ref.read(chatRepositoryProvider);

    var message = LocalMessage(
      userName: userName,
            actualMessage: locationMessage.keys.first.toString(),
            chatMessageTypes: ChatMessageTypes.Location,
            messageHolderType: MessageHolderType.ConnectedUsers,
            messageDateLocal: DateTime.now().toString().split(" ")[0],
            sendAt: locationMessage.values.first.toString() as DateTime);

    await saveMe.addNewMessage(message); /// save the message content with MessageM format

  }


  manageIncomingTextMessages( BuildContext context,{var textMessage, required String userName}) async {
    final saveMe = ref.read(chatRepositoryProvider);

    var message = LocalMessage(
        userName: userName,
            actualMessage: textMessage.keys.first.toString(),
            chatMessageTypes: ChatMessageTypes.Text,
            messageHolderType: MessageHolderType.ConnectedUsers,
            messageDateLocal: DateTime.now().toString().split(" ")[0],
            sendAt: textMessage.values.first.toString() as DateTime);

    await saveMe.addNewMessage(message); /// save the message content with MessageM format
    if (mounted) {
      setState(() {
    allConversationMessages.add({
      textMessage.keys.first.toString():
      textMessage.values.first.toString(),
    });
    chatMessageCategoryHolder.add(ChatMessageTypes.Text);
    _conversationMessageHolder.add(true);
      });
    }

    if (mounted) {
    setState(() {
    _scrollController.jumpTo(
      _scrollController.position.maxScrollExtent +
          amountToScroll(ChatMessageTypes.Text, context)+30.0,
    );
      });
    }
  }


  manageIncomingMediaMessages( BuildContext context,
      {var mediaMessage, required ChatMessageTypes chatMessageTypes}) async {
    String refName = "";
    String extension = "";
    late String thumbnailFileRemotePath;

    String videoThumbnailLocalPath = "";

    String actualFileRemotePath = chatMessageTypes == ChatMessageTypes.Video ||
        chatMessageTypes == ChatMessageTypes.Document
        ? mediaMessage.keys.first.toString().split("+")[0]
        : mediaMessage.keys.first.toString();

    if (chatMessageTypes == ChatMessageTypes.Image) {
      refName = "/Images/";
      extension = '.png';
    } else if (chatMessageTypes == ChatMessageTypes.Video) {
      refName = "/Videos/";
      extension = '.mp4';
      thumbnailFileRemotePath =
      mediaMessage.keys.first.toString().split("+")[1];
    } else if (chatMessageTypes == ChatMessageTypes.Document) {
      refName = "/Documents/";
      extension = mediaMessage.keys.first.toString().split("+")[1];
    } else if (chatMessageTypes == ChatMessageTypes.Audio) {
      refName = "/Audio/";
      extension = '.mp3';
    }



    final Directory? directory = await getExternalStorageDirectory();
    print('Directory Path: ${directory!.path}');

    final storageDirectory = await Directory(directory.path + refName)
        .create(); // Create New Folder about the desire location

    final String mediaFileLocalPath =
        "${storageDirectory.path}${DateTime.now().toString().split(" ").join("")}$extension";

    if (chatMessageTypes == ChatMessageTypes.Video) {
      final storageDirectory = await Directory("${directory.path}/.Thumbnails/")
          .create(); // Create New Folder about the desire location

      videoThumbnailLocalPath =
      "${storageDirectory.path}${DateTime.now().toString().split(" ").join("")}.png";
    }

    try {
      print("Media Saved Path: $mediaFileLocalPath");

      await client
          ?.download(actualFileRemotePath, mediaFileLocalPath)
          .whenComplete(() async {
        if (chatMessageTypes == ChatMessageTypes.Video) {
          await client
              ?.download(thumbnailFileRemotePath, videoThumbnailLocalPath)
              .whenComplete(() async {
            await storeAndShowIncomingMessageData(
                mediaFileLocalPath:
                "$videoThumbnailLocalPath+$mediaFileLocalPath",
                chatMessageTypes: chatMessageTypes,
                mediaMessage: mediaMessage);
          });
        } else {
          await storeAndShowIncomingMessageData(
              mediaFileLocalPath: mediaFileLocalPath,
              chatMessageTypes: chatMessageTypes,
              mediaMessage: mediaMessage);
        }
      });
    } catch (e) {
      print("Error in Media Downloading: ${e.toString()}");
    }finally{
      // if (mounted) {
      //   setState(() {
      _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent +
            amountToScroll(chatMessageTypes, actualMessageKey: mediaFileLocalPath, context),
      );
      //   });
      // }
    }
  }


  Future<void> storeAndShowIncomingMessageData(
      {required String mediaFileLocalPath,
        String? userName,
        required ChatMessageTypes chatMessageTypes,
        required var mediaMessage}) async {
    try {
      final saveMe = ref.read(chatRepositoryProvider);
      // await _localDatabase.insertMessageInUserTable(
      //     userName: userName!,
      //     actualMessage: mediaFileLocalPath,
      //     chatMessageTypes: chatMessageTypes,
      //     messageHolderType: MessageHolderType.ConnectedUsers,
      //     messageDateLocal: DateTime.now().toString().split(" ")[0],
      //     messageTimeLocal: mediaMessage.values.first.toString()
      // );
      var message = LocalMessage(
        userName: userName,
        actualMessage: mediaFileLocalPath,
        chatMessageTypes: chatMessageTypes,
        messageHolderType: MessageHolderType.ConnectedUsers,
        messageDateLocal: DateTime.now().toString().split(" ")[0],
        sendAt: mediaMessage.values.first.toString() as DateTime,
      );
      await saveMe.addNewMessage(message); /// save the message content with MessageM format

      if (mounted) {
        setState(() {
      allConversationMessages.add({
        mediaFileLocalPath: mediaMessage.values.first.toString(),
      });
      chatMessageCategoryHolder.add(chatMessageTypes);
      _conversationMessageHolder.add(true);
        });
      }
    } catch (e) {
      print("Error in Store And Show Message: ${e.toString()}");
    } finally {
      if (mounted) {
      setState(() {
        isLoading = false;
      });
      }
    }
  }

  loadPreviousStoredMessages( BuildContext context,{required String userName}) async {
    double positionToScroll = 100.0;
    final saveMe = ref.watch(localMessageProvider);
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      // List<PreviousMessageStructure> storedPreviousMessages
      // = await _localDatabase.getAllPreviousMessages(userName);

      List<PreviousMessageStructure> storedPreviousMessages =
      await saveMe as List<PreviousMessageStructure>;

      for (int i = 0; i < storedPreviousMessages.length; i++) {
        final PreviousMessageStructure previousMessage =
        storedPreviousMessages[i];

        if (mounted) {
          setState(() {
        allConversationMessages.add({
          previousMessage.actualMessage: previousMessage.messageTime,
        });
        chatMessageCategoryHolder.add(previousMessage.messageType);
        _conversationMessageHolder.add(previousMessage.messageHolder);

        positionToScroll += amountToScroll(previousMessage.messageType,
            actualMessageKey: previousMessage.actualMessage, context);
          });
        }
      }
    } catch (e) {
      print("Previous Message Fetching Error in ChatScreen: ${e.toString()}");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      final provider = ref.read(chatProvider.notifier);
      if (mounted) {
        setState(() {
      print("Position to Scroll: $positionToScroll");
      _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent + positionToScroll,
      );
        });
      }
      // await _fetchIncomingMessages();
      await provider.getMessages(widget.username);
    }
  }

  double amountToScroll(ChatMessageTypes chatMessageTypes, BuildContext context,
      {String? actualMessageKey}) {
    switch (chatMessageTypes) {
      case ChatMessageTypes.None:
        return 10.0 + 30.0;
      case ChatMessageTypes.Text:
        return 10.0 + 30.0;
      case ChatMessageTypes.Image:
        return MediaQuery.of(context).size.height * 0.6;
      case ChatMessageTypes.Video:
        return MediaQuery.of(context).size.height * 0.6;
      case ChatMessageTypes.Document:
        return actualMessageKey!.contains('.pdf')
            ? MediaQuery.of(context).size.height * 0.6
            : 70.0 + 30.0;

      case ChatMessageTypes.Audio:
        return 70.0 + 30.0;
      case ChatMessageTypes.Location:
        return MediaQuery.of(context).size.height * 0.6;
    }
  }


  void addSelectedMediaToChat(String path, BuildContext context, String userName,
      {ChatMessageTypes chatMessageTypeTake = ChatMessageTypes.Image,
        String thumbnailPath = ''}) {
    Navigator.pop(context);

    print('Thumbnail Path: $thumbnailPath    ${File(path).path}');

    final String messageTime =
        "${DateTime.now().hour}:${DateTime.now().minute}";

    if (mounted) {
      setState(() {
    allConversationMessages.add({
      chatMessageTypeTake == ChatMessageTypes.Image
          ? File(path).path
          : "$thumbnailPath+${File(path).path}": messageTime,
    });

    chatMessageCategoryHolder.add(
        chatMessageTypeTake == ChatMessageTypes.Image
            ? ChatMessageTypes.Image
            : ChatMessageTypes.Video);

    _conversationMessageHolder.add(false);
    });
    }

    if (mounted) {
      setState(() {
    _scrollController.jumpTo(
      _scrollController.position.maxScrollExtent +
          amountToScroll(chatMessageTypeTake, context),
    );
      });
    }

    if (chatMessageTypeTake == ChatMessageTypes.Image) {
      sendImage(File(path).path, userName);
    } else {
      sendVideo(videoPath: File(path).path, thumbnailPath: thumbnailPath, userName);
    }
  }

  void voiceAndAudioSend(recordedFilePath, BuildContext context,
      {String audioExtension = '.mp3', required String userName}) async {
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
     final provider =  ref.watch(chatProvider.notifier);
     final saveMe =  ref.watch(chatRepositoryProvider);

    if (_justAudioPlayer.duration != null) {
      if (mounted) {
        setState(() {
      _justAudioPlayer.stop();
      _iconData = Icons.play_arrow_rounded;
        });
      }
    }

    await _justAudioPlayer.setFilePath(recordedFilePath);

    if (_justAudioPlayer.duration!.inMinutes > 20) {
      showToast(
          "Audio File Duration Can't be greater than 20 minutes", _fToast);
    } else {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      final String messageTime =
          "${DateTime.now().hour}:${DateTime.now().minute}";

      final String? downloadedVoicePath = await provider.uploadMediaToStorage(file: recordedFilePath);

      if (downloadedVoicePath != null) {
        final provider = ref.watch(chatProvider.notifier);
        await provider.sendMessage(
            chatMessageTypes: ChatMessageTypes.Audio,
            username: userName,
            sendMessageData: {
              ChatMessageTypes.Audio.toString(): {
                downloadedVoicePath.toString(): messageTime
              }
            });

        if (mounted) {
          setState(() {
        allConversationMessages.add({
          recordedFilePath: messageTime,
        });
        chatMessageCategoryHolder.add(ChatMessageTypes.Audio);
        _conversationMessageHolder.add(false);
          });
        }

        if (mounted) {
          setState(() {
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent +
              amountToScroll(ChatMessageTypes.Audio, context)+30.0,
        );
        });
        }

        // await _localDatabase.insertMessageInUserTable(
        //     userName: userName,
        //     actualMessage: recordedFilePath.toString(),
        //     chatMessageTypes: ChatMessageTypes.Audio,
        //     messageHolderType: MessageHolderType.Me,
        //     messageDateLocal: DateTime.now().toString().split(" ")[0],
        //     messageTimeLocal: messageTime);

        var message = LocalMessage(
          userName: userName,
          actualMessage: recordedFilePath.toString(),
          chatMessageTypes: ChatMessageTypes.Audio,
          messageHolderType: MessageHolderType.Me,
          messageDateLocal: DateTime.now().toString().split(" ")[0],
          sendAt: messageTime as DateTime,
        );
        await saveMe.addNewMessage(message); /// save the message content with MessageM format
      }

      if (mounted) {
      setState(() {
      isLoading = false;
        });
      }
    }
  }


  Future<void> sendImage(imageFilePath, String userName) async {
    final provider = ref.read(chatProvider.notifier);
    final saveMe = ref.read(chatRepositoryProvider);
    if (mounted) {
      setState(() {
        isLoading = true;
        // final provider = ref.watch(chatProvider.notifier);
      });
    }

    final String messageTime =
        "${DateTime.now().hour}:${DateTime.now().minute}";

    final String? downloadedImagePath = await provider.uploadMediaToStorage(file: imageFilePath);

    if (downloadedImagePath != null) {
      final provider = ref.watch(chatProvider.notifier);
      await provider.sendMessage(
          chatMessageTypes: ChatMessageTypes.Image,
          username: userName,
          sendMessageData: {
            ChatMessageTypes.Image.toString(): {
              downloadedImagePath.toString(): messageTime
            }
          });

    //   await _localDatabase.insertMessageInUserTable(
    //       userName: userName,
    //       actualMessage: imageFilePath,
    //       chatMessageTypes: ChatMessageTypes.Image,
    //       messageHolderType: MessageHolderType.Me,
    //       messageDateLocal: DateTime.now().toString().split(" ")[0],
    //       messageTimeLocal: messageTime);

      var message = LocalMessage(
        userName: userName,
        actualMessage: imageFilePath,
        chatMessageTypes: ChatMessageTypes.Image,
        messageHolderType: MessageHolderType.Me,
        messageDateLocal: DateTime.now().toString().split(" ")[0],
        sendAt: messageTime as DateTime,
      );
      await saveMe.addNewMessage(message); /// save the message content with MessageM format
    }

      if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> sendVideo(String userName,
      {required videoPath, required thumbnailPath,}) async {
    final provider = ref.watch(chatProvider.notifier);
    final saveMe = ref.watch(chatRepositoryProvider);
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    final String messageTime =
        "${DateTime.now().hour}:${DateTime.now().minute}";

    final String? downloadedVideoPath = await
    provider.uploadVideoToStorage(file: videoPath);

    final String? downloadedVideoThumbnailPath = await
    provider.uploadVideoToStorage(file: thumbnailPath);

    if (downloadedVideoPath != null) {
      await provider.sendMessage(
          username: userName,
          sendMessageData: {
            ChatMessageTypes.Video.toString(): {
              "${downloadedVideoPath.toString()}+${downloadedVideoThumbnailPath.toString()}":
              messageTime
            }
          },
          chatMessageTypes: ChatMessageTypes.Video);

      // await _localDatabase.insertMessageInUserTable(
      //     userName: userName,
      //     actualMessage: downloadedVideoPath.toString() +
      //         downloadedVideoThumbnailPath.toString(),
      //     chatMessageTypes: ChatMessageTypes.Video,
      //     messageHolderType: MessageHolderType.Me,
      //     messageDateLocal: DateTime.now().toString().split(" ")[0],
      //     messageTimeLocal: messageTime);

      var message = LocalMessage(
        userName: userName,
        actualMessage: downloadedVideoPath.toString()
            + downloadedVideoThumbnailPath.toString(),
        chatMessageTypes: ChatMessageTypes.Video,
        messageHolderType: MessageHolderType.Me,
        messageDateLocal: DateTime.now().toString().split(" ")[0],
        sendAt: messageTime as DateTime,
      );
      await saveMe.addNewMessage(message); /// save the message content with MessageM format
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> checkingForIncomingMessages(Map<String, dynamic>? docs, String userName) async {
    // final Map<String, dynamic> connectionsList =
    // docs![_firestoreFieldConstants.connections];

    List<dynamic>? getIncomingMessages =
    [userName]; /// this wont work
    // connectionsList[_connectionEmail];

    if (getIncomingMessages != null) {
      // await
      // removeOldMessages(connectionEmail: _connectionEmail)
      // .whenComplete(() {
      for ( var everyMessage in getIncomingMessages) {
        if (everyMessage.keys.first.toString() ==
            ChatMessageTypes.Text.toString()) {
          Future.microtask(() {
            manageIncomingTextMessages(everyMessage.values.first, userName: userName);
          });
        } else if (everyMessage.keys.first.toString() ==
            ChatMessageTypes.Audio.toString()) {
          Future.microtask(() {
            manageIncomingMediaMessages(
                everyMessage.values.first, chatMessageTypes: ChatMessageTypes.Audio);
          });
        } else if (everyMessage.keys.first.toString() ==
            ChatMessageTypes.Image.toString()) {
          Future.microtask(() {
            manageIncomingMediaMessages(
                everyMessage.values.first, chatMessageTypes: ChatMessageTypes.Image);
          });
        } else if (everyMessage.keys.first.toString() ==
            ChatMessageTypes.Video.toString()) {
          Future.microtask(() {
            manageIncomingMediaMessages(
                everyMessage.values.first, chatMessageTypes: ChatMessageTypes.Video);
          });
        } else if (everyMessage.keys.first.toString() ==
            ChatMessageTypes.Location.toString()) {
          Future.microtask(() {
            manageIncomingLocationMessages(everyMessage.values.first, userName: userName);
          });
        } else if (everyMessage.keys.first.toString() ==
            ChatMessageTypes.Document.toString()) {
          Future.microtask(() {
            manageIncomingMediaMessages(
                everyMessage.values.first, chatMessageTypes: ChatMessageTypes.Document);
          });
        }
      }
      // });
    }
  }





  /////[

  // ]//////

  Future<void> takeLocationInput(BuildContext context, userName) async {
    try {
      final saveMe = ref.watch(chatRepositoryProvider);
      final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);

      final Marker marker = Marker(
          markerId: const MarkerId('locate'),
          zIndex: 1.0,
          draggable: true,
          position: LatLng(position.latitude, position.longitude));

      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: Colors.black26,
            actions: [
              FloatingActionButton(
                child: const Icon(Icons.send),
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  final provider = ref.read(chatProvider.notifier);
                  if (mounted) {
                    setState(() {
                      isLoading = true;
                    });
                  }

                  final String messageTime =
                      "${DateTime.now().hour}:${DateTime.now().minute}";

                  await provider.sendMessage(
                      chatMessageTypes: ChatMessageTypes.Location,
                      username: userName,
                      sendMessageData: {
                        ChatMessageTypes.Location.toString(): {
                          "${position.latitude}+${position.longitude}":
                          messageTime,
                        },
                      });

                  if (mounted) {
                    setState(() {
                      allConversationMessages.add({
                        "${position.latitude}+${position.longitude}":
                        messageTime,
                      });

                      chatMessageCategoryHolder
                          .add(ChatMessageTypes.Location);
                      _conversationMessageHolder.add(false);
                    });
                  }

                  if (mounted) {
                    setState(() {
                      _scrollController.jumpTo(
                        _scrollController.position.maxScrollExtent +
                            amountToScroll(ChatMessageTypes.Location, context),
                      );
                    });
                  }

                  // await _localDatabase.insertMessageInUserTable(
                  //     userName: userName,
                  //     actualMessage:
                  //     "${position.latitude}+${position.longitude}",
                  //     chatMessageTypes: ChatMessageTypes.Location,
                  //     messageHolderType: MessageHolderType.Me,
                  //     messageDateLocal:
                  //     DateTime.now().toString().split(" ")[0],
                  //     messageTimeLocal: messageTime);

                  var message = LocalMessage(
                    userName: userName,
                    actualMessage: "${position.latitude}+${position.longitude}",
                    chatMessageTypes: ChatMessageTypes.Location,
                    messageHolderType: MessageHolderType.Me,
                    messageDateLocal: DateTime.now().toString().split(" ")[0],
                    sendAt: messageTime as DateTime,
                  );
                  await saveMe.addNewMessage(message); /// save the message content with MessageM format


                  if (mounted) {
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
              ),
            ],
            content: FittedBox(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
                child: GoogleMap(
                  mapType: MapType.hybrid,
                  markers: {marker},
                  initialCameraPosition: CameraPosition(
                    target: LatLng(position.latitude, position.longitude),
                    zoom: 18.4746,
                  ),
                ),
              ),
            ),
          ));
    } catch (e) {
      print('Map Show Error: ${e.toString()}');
      showToast('Map Show Error', _fToast,
          toastColor: Colors.red, fontSize: 16.0);
    }
  }

  Widget audioConversationManagement(
      BuildContext itemBuilderContext, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onLongPress: () async {},
          child: Container(
            margin: _conversationMessageHolder[index]
                ? EdgeInsets.only(
              right: MediaQuery.of(itemBuilderContext).size.width / 3,
              left: 5.0,
              top: 5.0,
            )
                : EdgeInsets.only(
              left: MediaQuery.of(itemBuilderContext).size.width / 3,
              right: 5.0,
              top: 5.0,
            ),
            alignment: _conversationMessageHolder[index]
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Container(
              height: 70.0,
              width: 250.0,
              decoration: BoxDecoration(
                color: _conversationMessageHolder[index]
                    ? const Color.fromRGBO(60, 80, 100, 1)
                    : const Color.fromRGBO(102, 102, 255, 1),
                borderRadius: _conversationMessageHolder[index]
                    ? const BorderRadius.only(
                  topRight: Radius.circular(40.0),
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                )
                    : const BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 20.0,
                  ),
                  GestureDetector(
                    onLongPress: () => chatMicrophoneOnLongPressAction(),
                    onTap: () => chatMicrophoneOnTapAction(index),
                    child: Icon(
                      index == _lastAudioPlayingIndex
                          ? _iconData
                          : Icons.play_arrow_rounded,
                      color: const Color.fromRGBO(10, 255, 30, 1),
                      size: 35.0,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                              top: 26.0,
                            ),
                            child: LinearPercentIndicator(
                              percent: _justAudioPlayer.duration == null
                                  ? 0.0
                                  : _lastAudioPlayingIndex == index
                                  ? _currAudioPlayingTime /
                                  _justAudioPlayer
                                      .duration!.inMicroseconds
                                      .ceilToDouble() <=
                                  1.0
                                  ? _currAudioPlayingTime /
                                  _justAudioPlayer
                                      .duration!.inMicroseconds
                                      .ceilToDouble()
                                  : 0.0
                                  : 0,
                              backgroundColor: Colors.black26,
                              progressColor:
                              _conversationMessageHolder[index]
                                  ? Colors.lightBlue
                                  : Colors.amber,
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 7.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _lastAudioPlayingIndex == index
                                          ? _loadingTime
                                          : '0:00',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      _lastAudioPlayingIndex == index
                                          ? _totalDuration
                                          : '',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: GestureDetector(
                      child: _lastAudioPlayingIndex != index
                          ? CircleAvatar(
                        radius: 23.0,
                        backgroundColor:
                        _conversationMessageHolder[index]
                            ? const Color.fromRGBO(60, 80, 100, 1)
                            : const Color.fromRGBO(102, 102, 255, 1),
                        backgroundImage: const ExactAssetImage(
                          "assets/images/google.png",  //the G image at the image of dialog box
                        ),
                      )
                          : Text(
                        '${_audioPlayingSpeed.toString().contains('.0') ? _audioPlayingSpeed.toString().split('.')[0] : _audioPlayingSpeed}x',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 18.0),
                      ),
                      onTap: () {
                        print('Audio Play Speed Tapped');
                        if (mounted) {
                          setState(() {
                            if (_audioPlayingSpeed != 3.0) {
                              _audioPlayingSpeed += 0.5;
                            } else {
                              _audioPlayingSpeed = 1.0;
                            }

                            _justAudioPlayer.setSpeed(_audioPlayingSpeed);
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        _conversationMessageTime(
            allConversationMessages[index].values.first, index),
      ],
    );
  }

  void voiceTake(String userName,BuildContext context) async {
    if (!await Permission.microphone.status.isGranted) {
      final microphoneStatus = await Permission.microphone.request();
      if (microphoneStatus != PermissionStatus.granted) {
        showToast(
            "Microphone Permission Required To Record Voice", _fToast);
      }
    } else {
      if (await _record.isRecording()) {
        if (mounted) {
          setState(() {
            _hintText = 'Type Here...';
          });
        }
        final String? recordedFilePath = await _record.stop();

        voiceAndAudioSend(recordedFilePath.toString(), userName: userName, context);
      } else {
        if (mounted) {
          setState(() {
            _hintText = 'Recording....';
          });
        }

        await _record
            .start(
          path: '${_audioDirectory.path}${DateTime.now()}.aac',
        )
            .then((value) => print("Recording"));
      }
    }
  }

  void chatMicrophoneOnTapAction(int index) async {
    try {
      _justAudioPlayer.positionStream.listen((event) {
        if (mounted) {
          setState(() {
            _currAudioPlayingTime = event.inMicroseconds.ceilToDouble();
            _loadingTime =
            '${event.inMinutes} : ${event.inSeconds > 59 ? event.inSeconds % 60 : event.inSeconds}';
          });
        }
      });

      _justAudioPlayer.playerStateStream.listen((event) {
        if (event.processingState == ProcessingState.completed) {
          _justAudioPlayer.stop();
          if (mounted) {
            setState(() {
              _loadingTime = '0:00';
              _iconData = Icons.play_arrow_rounded;
            });
          }
        }
      });

      if (_lastAudioPlayingIndex != index) {
        await _justAudioPlayer
            .setFilePath(allConversationMessages[index].keys.first);

        if (mounted) {
          setState(() {
            _lastAudioPlayingIndex = index;
            _totalDuration =
            '${_justAudioPlayer.duration!.inMinutes} : ${_justAudioPlayer.duration!.inSeconds > 59 ? _justAudioPlayer.duration!.inSeconds % 60 : _justAudioPlayer.duration!.inSeconds}';
            _iconData = Icons.pause;
            _audioPlayingSpeed = 1.0;
            _justAudioPlayer.setSpeed(_audioPlayingSpeed);
          });
        }

        await _justAudioPlayer.play();
      } else {
        print(_justAudioPlayer.processingState);
        if (_justAudioPlayer.processingState == ProcessingState.idle) {
          await _justAudioPlayer
              .setFilePath(allConversationMessages[index].keys.first);

          if (mounted) {
            setState(() {
              _lastAudioPlayingIndex = index;
              _totalDuration =
              '${_justAudioPlayer.duration!.inMinutes} : ${_justAudioPlayer.duration!.inSeconds}';
              _iconData = Icons.pause;
            });
          }

          await _justAudioPlayer.play();
        } else if (_justAudioPlayer.playing) {
          if (mounted) {
            setState(() {
              _iconData = Icons.play_arrow_rounded;
            });
          }

          await _justAudioPlayer.pause();
        } else if (_justAudioPlayer.processingState == ProcessingState.ready) {
          if (mounted) {
            setState(() {
              _iconData = Icons.pause;
            });
          }

          await _justAudioPlayer.play();
        } else if (_justAudioPlayer.processingState ==
            ProcessingState.completed) {}
      }
    } catch (e) {
      print('Audio Playing Error');
      showToast('May be Audio File Not Found', _fToast);
    }
  }


  Widget _conversationMessageTime(String time, int index) {
    return Container(
      alignment: _conversationMessageHolder[index]
          ? Alignment.centerLeft
          : Alignment.centerRight,
      margin: _conversationMessageHolder[index]
          ? const EdgeInsets.only(
        left: 5.0,
        bottom: 5.0,
        top: 5.0,
      )
          : const EdgeInsets.only(
        right: 5.0,
        bottom: 5.0,
        top: 5.0,
      ),
      child: _timeReFormat(time),
    );
  }

  Widget _timeReFormat(String willReturnTime) {
    if (int.parse(willReturnTime.split(':')[0]) < 10) {
      willReturnTime = willReturnTime.replaceRange(
          0, willReturnTime.indexOf(':'), '0${willReturnTime.split(':')[0]}');
    }

    if (int.parse(willReturnTime.split(':')[1]) < 10) {
      willReturnTime = willReturnTime.replaceRange(
          willReturnTime.indexOf(':') + 1,
          willReturnTime.length,
          '0${willReturnTime.split(':')[1]}');
    }

    return Text(
      willReturnTime,
      style: const TextStyle(color: Colors.lightBlue),
    );
  }


  void chatMicrophoneOnLongPressAction() async {
    if (_justAudioPlayer.playing) {
      await _justAudioPlayer.stop();

      if (mounted) {
        setState(() {
          print('Audio Play Completed');
          _justAudioPlayer.stop();
          if (mounted) {
            setState(() {
              _loadingTime = '0:00';
              _iconData = Icons.play_arrow_rounded;
              _lastAudioPlayingIndex = -1;
            });
          }
        });
      }
    }
  }


  Future<void> pickFileFromStorage(context, String userName) async {
    List<String> allowedExtensions = [
      'pdf',
      'doc',
      'docx',
      'ppt',
      'pptx',
      'c',
      'cpp',
      'py',
      'text'
    ];

    try {
      if (!await Permission.storage.isGranted) takePermissionForStorage();

      final provider = ref.read(chatProvider.notifier);
      final saveMe = ref.read(chatRepositoryProvider);
      final FilePickerResult? filePickerResult =
      await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
      );

      if (filePickerResult != null && filePickerResult.files.length > 0) {
        Navigator.pop(context);

        filePickerResult.files.forEach((file) async {
          print(file.path);

          if (allowedExtensions.contains(file.extension)) {
            if (mounted) {
              setState(() {
                isLoading = true;
              });
            }

            final String messageTime =
                "${DateTime.now().hour}:${DateTime.now().minute}";

            final String? downloadedDocumentPath =
            provider.uploadMediaToStorage(file: file.path as File
            ) as String?;

            if (downloadedDocumentPath != null) {
              await provider.sendMessage(
                  chatMessageTypes: ChatMessageTypes.Document,
                  username: widget.username,
                  sendMessageData: {
                    ChatMessageTypes.Document.toString(): {
                      "${downloadedDocumentPath.toString()}+.${file.extension}":
                      messageTime
                    }
                  });

              if (mounted) {
                setState(() {
                  allConversationMessages.add({
                    File(file.path.toString()).path: messageTime,
                  });

                  chatMessageCategoryHolder
                      .add(ChatMessageTypes.Document);
                  _conversationMessageHolder.add(false);
                });
              }

              if (mounted) {
                setState(() {
                  _scrollController.jumpTo(
                    _scrollController.position.maxScrollExtent +
                        amountToScroll(ChatMessageTypes.Document, context),
                  );
                });
              }
              var message = LocalMessage(
                userName: userName,
                actualMessage: File(file.path.toString()).path.toString(),
                chatMessageTypes: ChatMessageTypes.Document,
                messageHolderType: MessageHolderType.Me,
                messageDateLocal: DateTime.now().toString().split(" ")[0],
                sendAt: messageTime as DateTime,
              );
              await saveMe.addNewMessage(message); /// save the message content with MessageM format
            }

              if (mounted) {
              setState(() {
                isLoading = false;
              });
            }
          } else {
            showToast(
              'Not Supporting Document Format',
              _fToast,
              toastColor: Colors.red,
              fontSize: 16.0,
            );
          }
        });
      }
    } catch (e) {
      showToast(
        'Some Error Happened',
        _fToast,
        toastColor: Colors.red,
        fontSize: 16.0,
      );
    }
  }


  Widget documentConversationManagement(
      BuildContext itemBuilderContext, int index) {
    return Column(
      children: [
        Container(
            height:
            allConversationMessages[index].keys.first.contains('.pdf')
                ? MediaQuery.of(itemBuilderContext).size.height * 0.3
                : 70.0,
            margin: _conversationMessageHolder[index]
                ? EdgeInsets.only(
              right: MediaQuery.of(itemBuilderContext).size.width / 3,
              left: 5.0,
              top: 30.0,
            )
                : EdgeInsets.only(
              left: MediaQuery.of(itemBuilderContext).size.width / 3,
              right: 5.0,
              top: 15.0,
            ),
            alignment: _conversationMessageHolder[index]
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: allConversationMessages[index]
                    .keys
                    .first
                    .contains('.pdf')
                    ? Colors.white
                    : _conversationMessageHolder[index]
                    ? const Color.fromRGBO(60, 80, 100, 1)
                    : const Color.fromRGBO(102, 102, 255, 1),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: allConversationMessages[index]
                  .keys
                  .first
                  .contains('.pdf')
                  ? Stack(
                children: [
                  const Center(
                      child: Text(
                        'Loading Error',
                        style: TextStyle(
                          fontFamily: 'Lora',
                          color: Colors.red,
                          fontSize: 20.0,
                          letterSpacing: 1.0,
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: PdfView(
                      path:
                      allConversationMessages[index].keys.first,
                    ),
                  ),
                  Center(
                    child: GestureDetector(
                      child: const Icon(
                        Icons.open_in_new_rounded,
                        size: 40.0,
                        color: Colors.blue,
                      ),
                      onTap: () async {
                        final OpenResult openResult = await OpenFile.open(
                            allConversationMessages[index]
                                .keys
                                .first);

                        openFileResultStatus(openResult: openResult);
                      },
                    ),
                  ),
                ],
              )
                  : GestureDetector(
                onTap: () async {
                  final OpenResult openResult = await OpenFile.open(
                      allConversationMessages[index].keys.first);

                  openFileResultStatus(openResult: openResult);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      width: 20.0,
                    ),
                    FaIcon(FontAwesomeIcons.file, color: Colors.white),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Expanded(
                      child: Text(
                        allConversationMessages[index]
                            .keys
                            .first
                            .split("/")
                            .last,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Lora',
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
        _conversationMessageTime(
            allConversationMessages[index].values.first, index),
      ],
    );
  }


  Widget textConversationManagement(
      BuildContext itemBuilderContext, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          margin: _conversationMessageHolder[index]
              ? EdgeInsets.only(
            right: MediaQuery.of(itemBuilderContext).size.width / 3,
            left: 5.0,
          )
              : EdgeInsets.only(
            left: MediaQuery.of(itemBuilderContext).size.width / 3,
            right: 5.0,
          ),
          alignment: _conversationMessageHolder[index]
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: _conversationMessageHolder[index]
                  ? const Color.fromRGBO(60, 80, 100, 1)
                  : const Color.fromRGBO(102, 102, 255, 1),
              elevation: 0.0,
              padding: const EdgeInsets.all(10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: _conversationMessageHolder[index]
                      ? const Radius.circular(0.0)
                      : const Radius.circular(20.0),
                  topRight: _conversationMessageHolder[index]
                      ? const Radius.circular(20.0)
                      : const Radius.circular(0.0),
                  bottomLeft: const Radius.circular(20.0),
                  bottomRight: const Radius.circular(20.0),
                ),
              ),
            ),
            child: Text(
              allConversationMessages[index].keys.first,
              style: const TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            onPressed: () {},
            onLongPress: () {},
          ),
        ),
        _conversationMessageTime(
            allConversationMessages[index].values.first, index),
      ],
    );
  }

  Widget mediaConversationManagement(
      BuildContext itemBuilderContext, int index) {
    return Column(
      children: [
        Container(
            height: MediaQuery.of(itemBuilderContext).size.height * 0.3,
            margin: _conversationMessageHolder[index]
                ? EdgeInsets.only(
              right: MediaQuery.of(itemBuilderContext).size.width / 3,
              left: 5.0,
              top: 30.0,
            )
                : EdgeInsets.only(
              left: MediaQuery.of(itemBuilderContext).size.width / 3,
              right: 5.0,
              top: 15.0,
            ),
            alignment: _conversationMessageHolder[index]
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: OpenContainer(
              openColor: const Color.fromRGBO(60, 80, 100, 1),
              closedColor: _conversationMessageHolder[index]
                  ? const Color.fromRGBO(60, 80, 100, 1)
                  : const Color.fromRGBO(102, 102, 255, 1),
              middleColor: const Color.fromRGBO(60, 80, 100, 1),
              closedElevation: 0.0,
              closedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              transitionDuration: const Duration(
                milliseconds: 400,
              ),
              // transitionType: ContainerTransitionType.fadeThrough,
              openBuilder: (context, openWidget) {
                return ImageViewScreen(
                  imagePath: chatMessageCategoryHolder[index] ==
                      ChatMessageTypes.Image
                      ? allConversationMessages[index].keys.first
                      : allConversationMessages[index]
                      .keys
                      .first
                      .split("+")[0],
                  imageProviderCategory: ImageProviderCategory.FileImage,
                );
              },
              closedBuilder: (context, closeWidget) => Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: PhotoView(
                      imageProvider: FileImage(File(
                          chatMessageCategoryHolder[index] ==
                              ChatMessageTypes.Image
                              ? allConversationMessages[index].keys.first
                              : allConversationMessages[index]
                              .keys
                              .first
                              .split("+")[0])),
                      loadingBuilder: (context, event) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorBuilder: (context, obj, stackTrace) => const Center(
                          child: Text(
                            'Image not Found',
                            style: TextStyle(
                              fontSize: 23.0,
                              color: Colors.red,
                              fontFamily: 'Lora',
                              letterSpacing: 1.0,
                            ),
                          )),
                      enableRotation: true,
                      minScale: PhotoViewComputedScale.covered,
                    ),
                  ),
                  if (chatMessageCategoryHolder[index] ==
                      ChatMessageTypes.Video)
                    Center(
                      child: IconButton(
                        iconSize: 100.0,
                        icon: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          print(
                              "Opening Path is: ${allConversationMessages[index].keys.first.split("+")[1]}");

                          final OpenResult openResult = await OpenFile.open(allConversationMessages[index]
                              .keys
                              .first
                              .split("+")[1]);

                          openFileResultStatus(openResult: openResult);
                        },
                      ),
                    ),
                ],
              ),
            )),
        _conversationMessageTime(
            allConversationMessages[index].values.first.split("+")[0],
            index),
      ],
    );
  }


  void openFileResultStatus({required OpenResult openResult}) {
    if (openResult.type == ResultType.permissionDenied) {
      showToast('Permission Denied to Open File', _fToast,
          toastColor: Colors.red, fontSize: 16.0);
    } else if (openResult.type == ResultType.noAppToOpen) {
      showToast('No App Found to Open', _fToast,
          toastColor: Colors.amber, fontSize: 16.0);
    } else if (openResult.type == ResultType.error) {
      showToast('Error in Opening File', _fToast,
          toastColor: Colors.red, fontSize: 16.0);
    } else if (openResult.type == ResultType.fileNotFound) {
      showToast('Sorry, File Not Found', _fToast,
          toastColor: Colors.red, fontSize: 16.0);
    }
  }

  Widget locationConversationManagement(
      BuildContext itemBuilderContext, int index) {
    return Column(children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        height: MediaQuery.of(itemBuilderContext).size.height * 0.3,
        margin: _conversationMessageHolder[index]
            ? EdgeInsets.only(
          right: MediaQuery.of(itemBuilderContext).size.width / 3,
          left: 5.0,
          top: 30.0,
        )
            : EdgeInsets.only(
          left: MediaQuery.of(itemBuilderContext).size.width / 3,
          right: 5.0,
          top: 15.0,
        ),
        alignment: _conversationMessageHolder[index]
            ? Alignment.centerLeft
            : Alignment.centerRight,
        child: GoogleMap(
          mapType: MapType.hybrid,
          markers: {
            Marker(
                markerId: const MarkerId('locate'),
                zIndex: 1.0,
                draggable: true,
                position: LatLng(
                    double.parse(allConversationMessages[index]
                        .keys
                        .first
                        .split('+')[0]),
                    double.parse(allConversationMessages[index]
                        .keys
                        .first
                        .split('+')[1])))
          },
          initialCameraPosition: CameraPosition(
            target: LatLng(
                double.parse(allConversationMessages[index]
                    .keys
                    .first
                    .split('+')[0]),
                double.parse(allConversationMessages[index]
                    .keys
                    .first
                    .split('+')[1])),
            zoom: 17.4746,
          ),
        ),
      ),
      _conversationMessageTime(
          allConversationMessages[index].values.first, index),
    ]);
  }

  Widget bottomInsertionPortion(BuildContext context, String userName) {
    return Container(
      width: double.maxFinite,
      height: 80.0,
      decoration: const BoxDecoration(
          color: Color.fromRGBO(25, 39, 52, 1),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.emoji_emotions_outlined,
              color: Colors.amber,
            ),
            onPressed: () {
              print('Clicked Emoji');
              if (mounted) {
                setState(() {
              SystemChannels.textInput.invokeMethod('TextInput.hide');
              showEmojiPicker = true;
              chatBoxHeight -= 300;
                });
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0, left: 10.0),
            child: GestureDetector(
              onTap: (){
                _differentChatOptions(context, userName);
              },
              child: FaIcon(
                FontAwesomeIcons.link,
                color: Colors.lightBlue,
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              width: double.maxFinite,
              height: 60.0,
              child: TextField(
                controller: typedText,
                style: const TextStyle(color: Colors.white),
                maxLines: 100,
                decoration: InputDecoration(
                  hintText: _hintText,
                  hintStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlue, width: 2.0),
                  ),
                ),
                onTap: () {
                  if (mounted) {
                    setState(() {
                      chatBoxHeight += 300;
                      showEmojiPicker = false;
                    });
                  }
                },
                onChanged: (writeText) {
                  bool isEmpty = false;
                  writeText.isEmpty ? isEmpty = true : isEmpty = false;

                  if (mounted) {
                    setState(() {
                      writeTextPresent = !isEmpty;
                    });
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: GestureDetector(
              onTap: (){
                writeTextPresent ? _sendText(userName) : voiceTake(userName, context);
              },
              child: writeTextPresent
                  ? const Icon(
                Icons.send,
                color: Colors.green,
                size: 30.0,
              )
                  : const Icon(
                Icons.keyboard_voice_rounded,
                color: Colors.green,
                size: 30.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendText(String userName) async {
    final provider = ref.read(chatProvider.notifier);
    final saveMe = ref.read(chatRepositoryProvider);
    String? uid = ref.read(authProviderK).value?.uid;
    if (writeTextPresent) {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      final String messageTime =
          "${DateTime.now().hour}:${DateTime.now().minute}";

      await provider.sendMessage(
          username: userName,
          sendMessageData: {
              "sendAt": messageTime,
              "message": typedText.text,
              "from": uid!,
          },
          chatMessageTypes: ChatMessageTypes.Text);

      if (mounted) {
        setState(() {
          allConversationMessages.add({
            typedText.text: messageTime,
          });
          chatMessageCategoryHolder.add(ChatMessageTypes.Text);
          _conversationMessageHolder.add(false);
        });
      }

      if (mounted) {
        setState(() {
          _scrollController.jumpTo(
            _scrollController.position.maxScrollExtent +
                amountToScroll(ChatMessageTypes.Text, context)+30.0,
          );
        });
      }

      var message = LocalMessage(
        userName: userName,
        actualMessage: typedText.text,
        chatMessageTypes: ChatMessageTypes.Text,
        messageHolderType: MessageHolderType.Me,
        messageDateLocal: DateTime.now().toString().split(" ")[0],
        sendAt: messageTime as DateTime,
      );
      await saveMe.addNewMessage(message); /// save the message content with MessageM format

      if (mounted) {
        setState(() {
          typedText.clear();
          isLoading = false;
          writeTextPresent = false;
        });
      }
    }
  }


  void _differentChatOptions(BuildContext context, String userName) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          elevation: 0.3,
          backgroundColor: const Color.fromRGBO(34, 48, 60, 0.5),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2.7,
            child: Center(
              child: CircleList(
                initialAngle: 55,
                outerRadius: MediaQuery.of(context).size.width / 3.2,
                innerRadius: MediaQuery.of(context).size.width / 10,
                showInitialAnimation: true,
                innerCircleColor: const Color.fromRGBO(34, 48, 60, 1),
                outerCircleColor: const Color.fromRGBO(0, 0, 0, 0.1),
                origin: const Offset(0, 0),
                rotateMode: RotateMode.allRotate,
                centerWidget: const Center(
                  child: Text(
                    "G",
                    style: TextStyle(
                      color: Colors.lightBlue,
                      fontSize: 45.0,
                    ),
                  ),
                ),
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: Colors.blue,
                          width: 3,
                        )),
                    child: GestureDetector(
                      onTap: () async {
                        // final provider = ref.watch(chatProvider.notifier);
                        final pickedImage = await ImagePicker().pickImage(
                            source: ImageSource.camera, imageQuality: 50);
                        if (pickedImage != null) {
                          addSelectedMediaToChat(pickedImage.path, context, userName);
                        }
                      },
                      onLongPress: () async {
                        // final provider = ref.watch(chatProvider.notifier);
                        final XFile? pickedImage = await ImagePicker()
                            .pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 50);
                        if (pickedImage != null) {
                          addSelectedMediaToChat(pickedImage.path, context, userName);
                        }
                      },
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.lightGreen,
                      ),
                    ),
                  ),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: Colors.blue,
                          width: 3,
                        )),
                    child: GestureDetector(
                      onTap: () async {
                        if (mounted) {
                          setState(() {
                            isLoading = true;
                          });
                        }

                        final pickedVideo = await ImagePicker().pickVideo(
                            source: ImageSource.camera,
                            maxDuration: const Duration(seconds: 15));

                        if (pickedVideo != null) {
                          // final provider = ref.watch(chatProvider.notifier);
                          final String thumbnailPathTake =
                          await _nativeCallback.getTheVideoThumbnail(
                              videoPath: pickedVideo.path);

                          addSelectedMediaToChat(pickedVideo.path,
                              chatMessageTypeTake: ChatMessageTypes.Video,
                              thumbnailPath: thumbnailPathTake, context, userName);
                        }

                        if (mounted) {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      onLongPress: () async {
                        if (mounted) {
                          setState(() {
                            isLoading = true;
                          });
                        }

                        final pickedVideo = await ImagePicker().pickVideo(
                            source: ImageSource.gallery,
                            maxDuration: const Duration(seconds: 15));

                        if (pickedVideo != null) {
                          // final provider = ref.watch(chatProvider.notifier);
                          final String thumbnailPathTake =
                          await _nativeCallback.getTheVideoThumbnail(
                              videoPath: pickedVideo.path);

                          addSelectedMediaToChat(pickedVideo.path,
                              chatMessageTypeTake: ChatMessageTypes.Video,
                              thumbnailPath: thumbnailPathTake, context, userName);
                        }

                        if (mounted) {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      child: const Icon(
                        Icons.video_collection,
                        color: Colors.lightGreen,
                      ),
                    ),
                  ),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: Colors.blue,
                          width: 3,
                        )),
                    child: GestureDetector(
                      onTap: () async {
                        // final provider = ref.read(chatServiceProvider);
                        await pickFileFromStorage(context, userName);
                      },
                      child: const Icon(
                        Icons.document_scanner_outlined,
                        color: Colors.lightGreen,
                      ),
                    ),
                  ),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: Colors.blue,
                          width: 3,
                        )),
                    child: GestureDetector(
                      onTap: () async {
                        // final provider = ref.read(chatProvider.notifier);
                        final PermissionStatus locationPermissionStatus =
                        await Permission.location.request();
                        if (locationPermissionStatus ==
                            PermissionStatus.granted) {
                          await takeLocationInput(context, userName);
                        } else {
                          showToast(
                              "Location Permission Required", _fToast);
                        }
                      },
                      child: const Icon(
                        Icons.location_on_rounded,
                        color: Colors.lightGreen,
                      ),
                    ),
                  ),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: Colors.blue,
                          width: 3,
                        )),
                    child: GestureDetector(
                      child: const Icon(
                        Icons.music_note_rounded,
                        color: Colors.lightGreen,
                      ),
                      onTap: () async {
                        const List<String> allowedExtensions = [
                          'mp3',
                          'm4a',
                          'wav',
                          'ogg',
                        ];

                        final FilePickerResult? audioFilePickerResult =
                        await FilePicker.platform.pickFiles(
                          type: FileType.audio,
                        );

                        popcontext(context);

                        if (audioFilePickerResult != null) {
                          audioFilePickerResult.files.forEach((element) {
                            // final provider = ref.read(chatServiceProvider);
                            print('Name: ${element.path}');
                            print('Extension: ${element.extension}');
                            if (allowedExtensions
                                .contains(element.extension)) {
                              voiceAndAudioSend(element.path.toString(), userName: userName, context,
                                  audioExtension: '.${element.extension}');
                            } else {
                              voiceAndAudioSend(element.path.toString(), userName: userName, context);
                            }
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}