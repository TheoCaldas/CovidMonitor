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
  Image? image;
  var defaultImage = SizedBox.fromSize(
    size: Size.fromRadius(50),
    child: FittedBox(
      child: Icon(Icons.person),
    ),
  );

  @override
  void initState() {
    super.initState();
    //UserData userData = DBProvider.db.getSingleUserData();
    //print(userData.profileImagePath);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Center(
              child: ClipOval(
            child: (image == null) ? defaultImage : image,
          )),
          padding: EdgeInsets.all(100.0),
        ),
        ElevatedButton(
          onPressed: () async {
            UserData userData = await DBProvider.db.getSingleUserData();
            print(userData.profileImagePath);

            final XFile? xFile = await pickImage();
            if (xFile != null) {
              updateProfileImagePath(xFile);
              setImageByFile(xFile);
            }
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

  void setImageByFile(XFile xFile) {
    final File file = File(xFile.path);
    image = Image.file(file);
    setState(() {});
  }
}
