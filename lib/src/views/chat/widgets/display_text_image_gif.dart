import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:megas/src/services/message_enum.dart';
import 'package:megas/src/views/chat/widgets/video_player_item.dart';



class DisplayTextImageGIF extends StatelessWidget {
  final String message;
  final MessageEnum type;
  const DisplayTextImageGIF({
    Key? key,
    required this.message,
    required this.type,
  }) : super(key: key);

  @override
  build(BuildContext context) {
    bool isPlaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();

    if (type == MessageEnum.text) {
      return Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          );
    } else {
      if (type == MessageEnum.audio) {
        return StatefulBuilder(builder: (context, setState) {
                return IconButton(
                  constraints: const BoxConstraints(
                    minWidth: 100,
                  ),
                  onPressed: () async {
                    if (isPlaying) {
                      await audioPlayer.pause();
                      setState(() {
                        isPlaying = false;
                      });
                    } else {
                      await audioPlayer.play(UrlSource(message));
                      setState(() {
                        isPlaying = true;
                      });
                    }
                  },
                  icon: Icon(
                    isPlaying ? Icons.pause_circle : Icons.play_circle,
                  ),
                );
              });
      } else {
        if (type == MessageEnum.video) {
          return VideoPlayerItem(
                    videoUrl: message,
                  );
        } else {
          if (type == MessageEnum.gif) {
            return Image.network(
                        message,
                      );
          } else {
            return SizedBox(
              height: 200,
              child: Image.network(message),
            );
          }
        }
      }
    }
  }
}
