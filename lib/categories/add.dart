import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/auth/widget/auth_button.dart';
import 'package:fluttercourse/auth/widget/custom_text_from_field.dart';
import 'package:fluttercourse/homepage.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  GlobalKey<FormState> form = GlobalKey<FormState>();

  var nameController = TextEditingController();

  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');

  Future addCategory() async {
    if (form.currentState!.validate()) {
      try {
        DocumentReference response = await categories.add({
          'id' : FirebaseAuth.instance.currentUser!.uid,
          'name': nameController.text,
        }) ;
        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Homepage(),));
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Homepage(),), (route) => false);
      } catch (e) {
        print(e) ;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
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
                  text: "Add Category",
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
