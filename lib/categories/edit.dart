import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../auth/widget/auth_button.dart';
import '../auth/widget/custom_text_from_field.dart';
import '../homepage.dart';

class Edit extends StatefulWidget {
  const Edit({super.key, required this.name, required this.docId});

  final String name ;
  final String docId ;

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {

  GlobalKey<FormState> form = GlobalKey<FormState>();

  CollectionReference categories =
  FirebaseFirestore.instance.collection('categories');

  var nameController = TextEditingController();

  // set = update if document exists
  // set = add if document doesn't exists
  // set you choose id of item you add

  Future editCategory() async {
    if (form.currentState!.validate()) {
      try {
        // var response = await categories.doc(widget.docId).update({
        //   'name': nameController.text,
        // }) ;
        var response = await categories.doc(widget.docId).set({
          'name': nameController.text,
          // 'id' : FirebaseAuth.instance.currentUser!.uid
        } , SetOptions(merge: true)) ;
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Homepage(),), (route) => false);
      } catch (e) {
        print(e) ;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    nameController.text =  widget.name ;
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
        title: const Text('Edit Category'),
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
                text: "Edit Category",
                onPressed: () {
                  editCategory();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
