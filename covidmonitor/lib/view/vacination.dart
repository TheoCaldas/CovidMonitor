import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Vacination extends StatefulWidget {
  @override
  _VacinationState createState() => _VacinationState();
}

class _VacinationState extends State<Vacination> {
  final picker = ImagePicker();
  File? _selectedImage;
  bool _inProcess = false;
  DateTime currentDate = DateTime.now();

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

  getImage(ImageSource src) async {
    this.setState(() {
      _inProcess = true;
    });
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
          title: 'Camera',
        ),
      );
      setState(() {
        if (_selectedImage != null) {
          print("oi");
          _selectedImage = cropped;
          _inProcess = false;
        }
      });
    } else {
      setState(() {
        _inProcess = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (_inProcess)
          ? Container(
              color: Colors.white,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
              child: SizedBox(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(
                  strokeWidth: 5.0,
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(currentDate.toString()),
                    SizedBox(
                      height: 20.0,
                    ),
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: Text('Select date'),
                    ),
                  ],
                ),
                _selectedImage != null
                    ? Image.file(
                        _selectedImage!,
                        width: 250,
                        height: 250,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 250,
                        height: 250,
                        child: Icon(
                          Icons.camera_alt,
                          size: 200,
                          color: Colors.grey,
                        ),
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        getImage(ImageSource.camera);
                      },
                      child: Text('Camera'),
                    ),
                  ],
                )
              ],
            ),
    );
  }
}
