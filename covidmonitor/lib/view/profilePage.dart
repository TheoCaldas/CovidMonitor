import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
            final ImagePicker _picker = ImagePicker();
            final XFile? xFile =
                await _picker.pickImage(source: ImageSource.gallery);
            if (xFile != null) {
              final File file = File(xFile.path);
              image = Image.file(file);
              setState(() {});
            }
          },
          child: Icon(Icons.camera_alt, color: Colors.white),
        )
      ],
    );
  }
}
