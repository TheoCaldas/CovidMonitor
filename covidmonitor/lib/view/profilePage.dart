import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:covidmonitor/controller/database.dart';
import 'package:covidmonitor/model/userData.dart';
import 'package:covidmonitor/model/constants.dart';
import 'package:numberpicker/numberpicker.dart';
import 'dart:io';
import 'package:covidmonitor/controller/imageGet.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  late Future<Image?> image;
  Image? currentImage;

  final _nameEditingController = TextEditingController();
  int currentAge = 0;

  var defaultImage = SizedBox.fromSize(
    size: Size.fromRadius(50),
    child: FittedBox(
      child: Icon(Icons.person),
    ),
  );

  @override
  void initState() {
    super.initState();
    image = getUserDataProfileImage();
    getUserDataName();
    getUserDataAge();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: 500,
            height: 300,
            padding: EdgeInsets.all(50),
            child: Stack(
              children: [
                Center(
                  child: ClipOval(
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
                ),
                Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () async {
                        image = chooseImageFromGalery();
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
        Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: TextFormField(
            controller: _nameEditingController,
            decoration: const InputDecoration(border: null, labelText: 'Nome'),
            onFieldSubmitted: (text) async {
              updateName(text);
            },
          ),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Spacer(),
            Text("Idade: "),
            NumberPicker(
              value: currentAge,
              minValue: 0,
              maxValue: 100,
              onChanged: (value) async {
                updateAge(value);
                setState(() {
                  currentAge = value;
                });
              },
            ),
            Spacer(),
          ],
        )
      ],
    );
  }

  Future<Image?> chooseImageFromGalery() async {
    final pickedFile = await pickImage(ImageSource.gallery);
    if (pickedFile == null) return null;
    final cropped =
        await cropImage(pickedFile.path, CropAspectRatio(ratioX: 1, ratioY: 1));
    if (cropped == null) return null;
    updateProfileImagePath(cropped.path);
    return Image.file(cropped);
  }

  Future<Image?> getUserDataProfileImage() async {
    UserData userData = await DBProvider.db.getSingleUserData();
    if (userData.profileImagePath == null || userData.profileImagePath == "") {
      return null;
    }
    final File file = File(userData.profileImagePath!);
    return Image.file(file);
  }

  void getUserDataName() async {
    UserData userData = await DBProvider.db.getSingleUserData();
    if (userData.name == null || userData.name == "") {
      return;
    }
    _nameEditingController.text = userData.name!;
    setState(() {});
  }

  void getUserDataAge() async {
    UserData userData = await DBProvider.db.getSingleUserData();
    if (userData.age == null) {
      return;
    }
    setState(() {
      currentAge = userData.age!;
    });
  }
}
