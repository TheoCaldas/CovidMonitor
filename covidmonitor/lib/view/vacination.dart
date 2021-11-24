import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:covidmonitor/controller/database.dart';
import 'package:covidmonitor/model/userData.dart';
import 'package:covidmonitor/model/constants.dart';

class Vacination extends StatefulWidget {
  @override
  _VacinationState createState() => _VacinationState();
}

class _VacinationState extends State<Vacination> {
  // final picker = ImagePicker();
  // File? _selectedImage;
  late Future<Image?> image;
  Image? currentImage;
  // bool _inProcess = false;
  DateTime currentDate = DateTime.now();

  var defaultImage = SizedBox.fromSize(
    size: Size.fromRadius(50),
    child: FittedBox(
      child: Icon(Icons.file_copy),
    ),
  );

  @override
  void initState() {
    super.initState();
    image = mockImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(currentDate.toString()),
        SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () => _selectDate(context),
          child: Text('Select date'),
        ),
        FutureBuilder<Image?>(
          future: image,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              currentImage = snapshot.data!;
              return snapshot.data!;
            } else if (currentImage != null) {
              return currentImage!;
            } else {
              return defaultImage;
            }
          },
        ),
        ElevatedButton(
          onPressed: () {
            image = getImage(ImageSource.camera);
            setState(() {});
          },
          child: Text('Camera'),
        ),
      ],
    ));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
      });
  }

  Future<Image?> getImage(ImageSource src) async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: src);
    if (pickedFile != null) {
      File? cropped = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxHeight: 700,
        maxWidth: 700,
        compressFormat: ImageCompressFormat.jpg,
        iosUiSettings: IOSUiSettings(
          title: 'Cortar Imagem',
        ),
      );
      if (cropped != null) {
        return Image.file(cropped);
      }
    }
    return null;
  }

  Future<Image?> mockImage() async {
    await DBProvider.db.getSingleUserData();
    return null;
  }
}
