import 'package:flutter/material.dart';
import 'dart:async';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:covidmonitor/controller/database.dart';
import 'package:covidmonitor/model/userData.dart';
import 'package:covidmonitor/controller/imageGet.dart';

class Vacination extends StatefulWidget {
  @override
  _VacinationState createState() => _VacinationState();
}

class _VacinationState extends State<Vacination> {
  late Future<Image?> image;
  Image? currentImage;
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
            image = chooseImageFromCamera();
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

  Future<Image?> chooseImageFromCamera() async {
    final pickedFile = await pickImage(ImageSource.gallery);
    if (pickedFile == null) return null;
    updateVacPassImagePath(pickedFile.path);
    final cropped =
        await cropImage(pickedFile.path, CropAspectRatio(ratioX: 1, ratioY: 1));
    if (cropped == null) return null;
    return Image.file(cropped);
  }

  Future<Image?> mockImage() async {
    await DBProvider.db.getSingleUserData();
    return null;
  }
}
