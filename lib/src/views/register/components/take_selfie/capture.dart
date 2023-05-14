import 'dart:io';
import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/core/utils/constants/consts.dart';
import 'package:megas/core/utils/constants/regex.dart';
import 'package:megas/src/controllers/auth.dart';
import 'package:megas/src/services/auth/auths_impl.dart';
import 'package:megas/src/views/home/navigation.dart';


class CaptureImage extends ConsumerStatefulWidget {
  const CaptureImage({Key? key}) : super(key: key);

  @override
  ConsumerState<CaptureImage> createState() => _CaptureImageState();
}

class _CaptureImageState extends ConsumerState<CaptureImage> {
  File? _capturedImage;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context){
        if(_capturedImage != null){
          return Center(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Image.file(
                  _capturedImage!,
                  width: double.maxFinite,
                  fit: BoxFit.fitWidth,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () => setState(() {
                          _capturedImage = null;
                        }),
                        child: Text(
                          'Capture again',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700
                          ),
                        ),
                    ),

                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          loading = true;
                        });
                        uploadImage();
                        setState(() {
                          loading = false;
                        });
                        showSnackBar(context, text: 'Profile pic successfully uploaded');
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                            builder: (context) => Nav()), (route) => false);
                      },
                      child: Text(
                          'Upload',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                    ),
                  ],
                ),
                if(loading)
                  kProgressIndicator
              ],
            ),
          );
        }
        return SmartFaceCamera(
          autoCapture: true,
          defaultCameraLens: CameraLens.front,
          onCapture: (File? image){
            setState(() { _capturedImage = image;});
          },
          messageBuilder: (context, face){
            if(face == null){
              return _message('Place your face in the camera');
            }
            if(!face.wellPositioned){
              return _message('Center your face in the square');
            }
            return const SizedBox.shrink();
          },
        );
      }),
    );
  }


  void uploadImage() async{
    final uid = ref.watch(authProviderK);
    await ref.read(authControllerProvider).uploadProfilePic(url: _capturedImage!,
      uid: uid,
    );
  }

  Widget _message(String msg) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
    child: Align(
      alignment: Alignment.center,
      child: Text(msg,
        style: const TextStyle(
          fontSize: 14,
          height: 1.5,
          color: Colors.white,
          fontWeight: FontWeight.w400
        ),
      ),
    ),
  );
}
