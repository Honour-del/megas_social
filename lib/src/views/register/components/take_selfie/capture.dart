import 'dart:io';
import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/core/utils/constants/consts.dart';
import 'package:megas/core/utils/constants/general_provider.dart';
import 'package:megas/core/utils/constants/regex.dart';
import 'package:megas/core/utils/custom_widgets/buttons.dart';
import 'package:megas/src/controllers/auth.dart';
import 'package:megas/src/views/home/navigation.dart';


class CaptureImage extends ConsumerStatefulWidget {
  final String name;
  final String email;
  final String password;
  const CaptureImage({Key? key, required this.name, required this.email, required this.password}) : super(key: key);

  @override
  ConsumerState<CaptureImage> createState() => _CaptureImageState();
}

class _CaptureImageState extends ConsumerState<CaptureImage> {
  File? _capturedImage;
  bool loading = false;
  String username = '';
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
                    FlatButtonCustom(
                        onTap: () => setState(() {
                          _capturedImage = null;
                        }),
                        width: MediaQuery.of(context).size.width * 0.35,
                        label: 'Capture again',
                    ),
                    // TODO
                    FlatButtonCustom(
                      onTap: () {
                        ref
                            .read(loadingProvider.notifier)
                            .state = true;
                        setState(() {
                          loading = true;
                        });
                        signUpandUploadImage();
                        setState(() {
                          loading = false;
                        });
                        ref
                            .read(loadingProvider.notifier)
                            .state = false;
                        showSnackBar(context, text: 'Profile pic successfully uploaded');

                      },
                      label: 'Upload',
                      width: MediaQuery.of(context).size.width * 0.35,
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


  void signUpandUploadImage() async{
    ref
        .read(loadingProvider.notifier)
        .state = true;
    final auth = await ref.read(authControllerProvider.notifier);
    username = widget.name.split('').first;
    // username = widget.name.split('').first;
    // final _file = await compressImage(file);
    final response = await auth.register(email: widget.email,
      password: widget. password,
      name: widget.name,
      photoUrl: _capturedImage!
    );
    //// after login function is completed
    // final uid = ref.watch(authProviderK);
    // await ref.read(authControllerProvider).uploadProfilePic(url: _capturedImage!,
    //   uid: uid,
    // );
    response.fold((e) {
      //// if error is detected loading will stop and this task will come to live
      setState(() {
        loading = false;
      });
      ref
          .read(loadingProvider.notifier)
          .state = false;
      showSnackBar(context, text: 'Error: $e');
      debugPrint('Error: $e');
    }, (status) async {
      setState(() {
        loading = false;
      });
      ref
          .read(loadingProvider.notifier)
          .state = false;
      showSnackBar(
          context, text: "Sign Up successful!");
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
          builder: (context) => Nav()), (route) => false);

    });
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
