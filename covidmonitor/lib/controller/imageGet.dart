import 'dart:async';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

Future<XFile?> pickImage(ImageSource src) async {
  final ImagePicker _picker = ImagePicker();
  return _picker.pickImage(source: src);
}

Future<File?> cropImage(String path, CropAspectRatio cropRatio) async {
  return await ImageCropper.cropImage(
    sourcePath: path,
    aspectRatio: cropRatio,
    compressQuality: 100,
    maxHeight: 700,
    maxWidth: 700,
    compressFormat: ImageCompressFormat.jpg,
    iosUiSettings: IOSUiSettings(
      title: 'Cortar Imagem',
    ),
  );
}
