import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/auth/widget/auth_button.dart';
import 'package:fluttercourse/auth/widget/custom_text_from_field.dart';
import 'package:fluttercourse/note/view_note.dart';
import 'package:fluttercourse/users/view_user.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  GlobalKey<FormState> form = GlobalKey<FormState>();

  var nameController = TextEditingController();
  var ageController = TextEditingController();
  var phoneController = TextEditingController();
  var moneyController = TextEditingController();

  // CollectionReference categories =
  // FirebaseFirestore.instance.collection('categories').doc(widget.catId).collection('note');

  Future addCategory() async {
    CollectionReference notes =
    FirebaseFirestore.instance.collection('user');
    if (form.currentState!.validate()) {
      try {
        DocumentReference response = await notes.add({
          'phone': phoneController.text,
          'name': nameController.text,
          'age': ageController.text,
          'price': moneyController.text,
        }) ;
        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Homepage(),));
        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ViewUser(),));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
      ),
      body: SingleChildScrollView(
        child: Form(
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
                CustomTextFromField(
                  controller: phoneController,
                  text: "Enter Phone",
                  validator: (value) {
                    if (value == "") {
                      return "Phone is required";
                    }
                    return null;
                  },
                ),
                CustomTextFromField(
                  controller: ageController,
                  text: "Enter Age",
                  validator: (value) {
                    if (value == "") {
                      return "Age is required";
                    }
                    return null;
                  },
                ),
                CustomTextFromField(
                  controller: moneyController,
                  text: "Enter Money",
                  validator: (value) {
                    if (value == "") {
                      return "Age is required";
                    }
                    return null;
                  },
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
      ),
    );
  }
}
