import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/note/view_note.dart';

import '../auth/widget/auth_button.dart';
import '../auth/widget/custom_text_from_field.dart';
import '../homepage.dart';

class EditNote extends StatefulWidget {
  const EditNote({super.key, required this.oldName, required this.catId, required this.docId, required this.catName});

  final String oldName ;
  final String catId ;
  final String catName ;
  final String docId ;

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {

  GlobalKey<FormState> form = GlobalKey<FormState>();

  var nameController = TextEditingController();

  // set = update if document exists
  // set = add if document doesn't exists
  // set you choose id of item you add

  Future editNote() async {
    CollectionReference notes =
    FirebaseFirestore.instance.collection('categories').doc(widget.catId).collection('note');
    if (form.currentState!.validate()) {
      try {
        // var response = await categories.doc(widget.docId).update({
        //   'name': nameController.text,
        // }) ;
        var response = await notes.doc(widget.docId).set({
          'note': nameController.text,
          // 'id' : FirebaseAuth.instance.currentUser!.uid
        } , SetOptions(merge: true)) ;
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewNote(name: widget.catName, catId: widget.catId),));
      } catch (e) {
        print(e) ;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    nameController.text =  widget.oldName ;
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose() ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
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
              AuthButton(
                text: "Edit Note",
                onPressed: () {
                  editNote();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
