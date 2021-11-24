import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:covidmonitor/controller/database.dart';
import 'package:covidmonitor/model/userData.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  late Future<Image?> image;
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Center(
              child: ClipOval(
            child: FutureBuilder<Image?>(
              future: image,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!;
                } else {
                  return defaultImage;
                }
              },
            ),
          )),
          padding: EdgeInsets.all(100.0),
        ),
        ElevatedButton(
          onPressed: () async {
            image = chooseImageFromGalery();
            setState(() {});
          },
          child: Icon(Icons.camera_alt, color: Colors.white),
        )
      ],
    );
  }

  Future<XFile?> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    return _picker.pickImage(source: ImageSource.gallery);
  }

  void updateProfileImagePath(XFile xFile) async {
    UserData userData = await DBProvider.db.getSingleUserData();
    userData.profileImagePath = xFile.path;
    await DBProvider.db.updateUserData(userData);
  }

  Future<Image?> chooseImageFromGalery() async {
    final XFile? xFile = await pickImage();
    if (xFile == null) return null;
    updateProfileImagePath(xFile);
    final File file = File(xFile.path);
    return Image.file(file);
  }

  Future<Image?> getUserDataProfileImage() async {
    UserData userData = await DBProvider.db.getSingleUserData();
    if (userData.profileImagePath == null) {
      return null;
    }
    final File file = File(userData.profileImagePath!);
    return Image.file(file);
  }
}
