import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart';

import 'package:image_picker/image_picker.dart';

class Files extends StatefulWidget {
  const Files({super.key});

  @override
  State<Files> createState() => _FilesState();
}

class _FilesState extends State<Files> {
  File? f;
  String? url ;

  getImage() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? file =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      f = File(file.path);
      var imageName = basename(file.path) ;
      var referenceStorage = FirebaseStorage.instance.ref('images/$imageName');
      await referenceStorage.putFile(f!);
      url = await referenceStorage.getDownloadURL() ;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('image picker'),
      ),
      body: Container(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () async => await getImage(),
                child: const Text('Get Image')),
            url != null
                ? Image.network(
                    url!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
