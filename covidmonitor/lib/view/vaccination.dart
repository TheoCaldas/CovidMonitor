import 'package:covidmonitor/controller/notificationService.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:covidmonitor/controller/database.dart';
import 'package:covidmonitor/model/userData.dart';
import 'package:covidmonitor/controller/imageGet.dart';
import 'package:covidmonitor/model/constants.dart';
import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Vacination extends StatefulWidget {
  @override
  _VacinationState createState() => _VacinationState();
}

class _VacinationState extends State<Vacination> {
  late Future<Image?> image;
  Image? currentImage;
  DateTime currentDate = DateTime.now();
  String? vacDate;

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
    getUserDataVacDate();
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return Scaffold(
        body: Center(
            child: Column(
      children: <Widget>[
        SizedBox(height: 20.0),
        Text(
          t!.acTitle,
          style: Constants.theme.headline2,
        ),
        Container(
            width: 350,
            height: 300,
            padding: EdgeInsets.all(10),
            child: Stack(
              children: [
                Center(
                    child: ClipRRect(
                  borderRadius: BorderRadius.circular(40.0),
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
                )),
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
        Row(
          children: [
            Spacer(),
            Text(t!.acLabel + (vacDate ?? "-/-/-")),
            SizedBox(width: 20.0),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Constants.backgroundColor)),
              child: Icon(
                Icons.calendar_today,
              ),
            ),
            Spacer(),
          ],
        )
      ],
    )));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      updateVacDate(formatDate(pickedDate));
      setState(() {
        currentDate = pickedDate;
        vacDate = formatDate(pickedDate);
      });
      await NotificationService.notificationService.cancelAllNotifications();
      NotificationService.notificationService.scheduleThirdDose(pickedDate);
    }
  }

  Future<Image?> chooseImageFromCamera() async {
    final pickedFile = await pickImage(ImageSource.camera);
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

  String formatDate(DateTime date) {
    return date.day.toString() +
        "/" +
        date.month.toString() +
        "/" +
        date.year.toString();
  }

  void getUserDataVacDate() async {
    UserData userData = await DBProvider.db.getSingleUserData();
    if (userData.vacDate == null || userData.vacDate == "") return;
    setState(() {
      vacDate = userData.vacDate;
    });
  }
}
