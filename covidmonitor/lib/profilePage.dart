import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  var image = Image.asset("assets/logo.png");

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: image,
          ),
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
          child: Icon(Icons.add, color: Colors.white),
        )
      ],
    );
  }
}
