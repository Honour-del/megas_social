
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:megas/core/utils/constants/consts.dart';
import 'package:megas/core/utils/custom_widgets/app_bar.dart';


import 'package:photo_view/photo_view.dart';

class ImageViewScreen extends StatefulWidget {
  final ImageProviderCategory imageProviderCategory;
  final String imagePath;

  const ImageViewScreen(
      {Key? key, required this.imageProviderCategory, required this.imagePath})
      : super(key: key);

  @override
  _ImageViewScreenState createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(context, "Photo view", false, true, widget: SizedBox.shrink(), color: Colors.black),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: PhotoView(
            imageProvider: _getParticularImage(),
            enableRotation: true,
            initialScale: null,
            loadingBuilder: (context, event) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorBuilder: (context, obj, stackTrace) => const Center(
                child: Text(
                  'Image not Found',
                  style: TextStyle(
                    fontSize: 23.0,
                    color: Colors.red,
                    // fontFamily: 'Lora',
                    letterSpacing: 1.0,
                  ),
                )),
          ),
        ),
      ),
    );
  }



  _getParticularImage() {
    switch (widget.imageProviderCategory) {
      case ImageProviderCategory.FileImage:
        return FileImage(File(widget.imagePath));

      case ImageProviderCategory.ExactAssetImage:
        return ExactAssetImage(widget.imagePath);

      case ImageProviderCategory.NetworkImage:
        return NetworkImage(widget.imagePath);
    }
  }
}