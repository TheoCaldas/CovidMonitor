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
  Image? currentImage;
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
            width: 500,
            height: 300,
            padding: EdgeInsets.all(50),
            child: FittedBox(
              fit: BoxFit.fitHeight,
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
    return Image.file(file, width: 100, height: 100);
  }

  Future<Image?> getUserDataProfileImage() async {
    UserData userData = await DBProvider.db.getSingleUserData();
    if (userData.profileImagePath == null || userData.profileImagePath == "") {
      return null;
    }
    final File file = File(userData.profileImagePath!);
    return Image.file(file, width: 100, height: 100);
  }
}
