import 'dart:io';
import 'package:image/image.dart' as Im;
import 'package:image_picker/image_picker.dart';

const String onboard1 = 'assets/images/onboard1.png';
 const String onboard2 = 'assets/images/onboard2.png';
 const String onboard3 = 'assets/images/onboard3.png';


/* Function to compress images before uploading */
Future<File> compressImage(File file) async{
 Im.Image? image = Im.decodeImage(file.readAsBytesSync());
 // Im.Image? compressedImage = Im.copyResize(image!, width: 1080);
 File compressedFile = File('${file.path}_compressed.jpg')
   ..writeAsBytesSync(Im.encodeJpg(image!, quality: 70));
 return compressedFile;
}


 /* Function to select multiple images */
 Future<List<File>> pickImages() async{
  List<File> images = [];
  final ImagePicker picker = ImagePicker();
  final imageFiles = await picker.pickMultiImage();
  if(imageFiles.isNotEmpty){
   for(final image in imageFiles){
    images.add(File(image.path));
   }
  }
  return images;
 }