import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/auth/widget/auth_button.dart';
import 'package:fluttercourse/auth/widget/custom_text_from_field.dart';
import 'package:fluttercourse/note/view_note.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key, required this.catId, required this.name});

  final String  catId ;
  final String name ;

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  GlobalKey<FormState> form = GlobalKey<FormState>();

  var nameController = TextEditingController();

  // CollectionReference categories =
  // FirebaseFirestore.instance.collection('categories').doc(widget.catId).collection('note');

  Future addCategory() async {
    CollectionReference notes =
    FirebaseFirestore.instance.collection('categories').doc(widget.catId).collection('note');
    if (form.currentState!.validate()) {
      try {
        DocumentReference response = await notes.add({
          'note': nameController.text,
          'url' : url ?? 'none' ,
        }) ;
        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Homepage(),));
        Navigator.of(context as BuildContext).push(MaterialPageRoute(builder: (context) => ViewNote(name: widget.name, catId: widget.catId),));
      } catch (e) {
        print(e) ;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose() ;
  }

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
        title: const Text('Add Notes'),
      ),
      body: Form(
        key: form,
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              CustomTextFromField(
                controller: nameController,
                text: "Enter Name",
                validator: (value) {
                  if (value == "") {
                    return "Name is required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),
              InkWell(
                onTap: () async {
                  await getImage() ;
                },
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: url ==null ? Colors.blue : Colors.green,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    url ==null ? 'upload image' : 'uploaded',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              AuthButton(
                text: "Add Nate",
                onPressed: () {
                  addCategory();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
