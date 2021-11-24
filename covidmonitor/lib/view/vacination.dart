import 'package:flutter/material.dart';
import 'dart:async';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:covidmonitor/controller/database.dart';
import 'package:covidmonitor/model/userData.dart';
import 'package:covidmonitor/controller/imageGet.dart';
import 'package:covidmonitor/model/constants.dart';
import 'dart:io';

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
    image = getUserDataVacPassImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      children: <Widget>[
        SizedBox(height: 20.0),
        Text(
          "Carteira de Vacinação SUS",
          style: Constants.theme.headline2,
        ),
        Container(
            width: 350,
            height: 300,
            padding: EdgeInsets.all(10),
            child: Stack(
              children: [
                Center(
                  child: FutureBuilder<Image?>(
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
                ),
                Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () async {
                        image = chooseImageFromCamera();
                        setState(() {});
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Constants.backgroundColor)),
                      child: Icon(
                        Icons.edit,
                      ),
                    )),
              ],
            )),
        Text(currentDate.toString()),
        SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () => _selectDate(context),
          child: Text('Select date'),
        ),
      ],
    )));
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
    final cropped = await cropImage(
        pickedFile.path, CropAspectRatio(ratioX: 1.3, ratioY: 1));
    if (cropped == null) return null;
    updateVacPassImagePath(cropped.path);
    return Image.file(cropped);
  }

  Future<Image?> getUserDataVacPassImage() async {
    UserData userData = await DBProvider.db.getSingleUserData();
    if (userData.vacPassImagePath == null || userData.vacPassImagePath == "") {
      return null;
    }
    final File file = File(userData.vacPassImagePath!);
    return Image.file(file);
  }
}
