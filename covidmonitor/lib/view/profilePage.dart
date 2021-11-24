import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:covidmonitor/controller/database.dart';
import 'package:covidmonitor/model/userData.dart';
import 'package:covidmonitor/model/constants.dart';
import 'package:numberpicker/numberpicker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  late Future<Image?> image;
  Image? currentImage;

  final _nameEditingController = TextEditingController();
  late Future<Text?> ageText;
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
    ageText = getUserDataAge();
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
                Container(
                  width: 500,
                  height: 300,
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
                        Icons.camera_alt,
                      ),
                    )),
              ],
            )),
        TextFormField(
          controller: _nameEditingController,
          decoration: const InputDecoration(border: null, labelText: 'Nome'),
          onFieldSubmitted: (text) async {
            updateName(text);
          },
        ),
        SizedBox(height: 20),
        // TextFormField(
        //   controller: _ageEditingController,
        //   decoration: const InputDecoration(border: null, labelText: 'Idade'),
        //   keyboardType: TextInputType.number,
        //   onFieldSubmitted: (text) async {
        //     updateAge(text);
        //   },
        // ),
        NumberPicker(
          value: currentAge,
          minValue: 0,
          maxValue: 100,
          onChanged: (value) async {
            // setState(() {
            //   currentAge = value;
            // });
            updateAge(value);
            ageText = setUserDataAge(value);
          },
        ),
        FutureBuilder<Text?>(
            future: ageText,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!;
              }
              return Center(child: CircularProgressIndicator());
            })
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

  void updateName(String name) async {
    UserData userData = await DBProvider.db.getSingleUserData();
    userData.name = name;
    await DBProvider.db.updateUserData(userData);
  }

  void updateAge(int age) async {
    UserData userData = await DBProvider.db.getSingleUserData();
    userData.age = age;
    await DBProvider.db.updateUserData(userData);
  }

  void getUserDataName() async {
    UserData userData = await DBProvider.db.getSingleUserData();
    if (userData.name == null || userData.name == "") {
      return;
    }
    // print(userData.name!);
    _nameEditingController.text = userData.name!;
    setState(() {});
  }

  Future<Text?> getUserDataAge() async {
    UserData userData = await DBProvider.db.getSingleUserData();
    if (userData.age == null) {
      return null;
    }
    // print(userData.age!);
    setState(() {
      currentAge = userData.age!;
    });
    return Text(userData.age!.toString());
  }

  Future<Text?> setUserDataAge(int age) async {
    await DBProvider.db.getSingleUserData();
    setState(() {
      currentAge = age;
    });
    return Text(age.toString());
  }
}
