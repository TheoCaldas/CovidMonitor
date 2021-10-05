import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final ImagePicker _picker = ImagePicker();
        final XFile? xFile =
            await _picker.pickImage(source: ImageSource.gallery);
        if (xFile != null) {
          final File file = File(xFile.path);
          setState(() {});
        }
      },
      child: Icon(Icons.add, color: Colors.white),
    );
  }
}
