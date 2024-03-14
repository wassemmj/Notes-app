import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/auth/login_page.dart';
import 'package:fluttercourse/categories/add.dart';
import 'package:fluttercourse/categories/edit.dart';
import 'package:fluttercourse/file/file.dart';
import 'package:fluttercourse/file/test.dart';
import 'package:fluttercourse/note/view_note.dart';
import 'package:fluttercourse/users/view_user.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<QueryDocumentSnapshot> data = [];

  getData() async {
    data.clear();
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('categories').where("id" , isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
    data.addAll(querySnapshot.docs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Categories',
        ),
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ViewUser(),
                ),
              );
            },
            icon: const Icon(Icons.person),
          ),
          IconButton(
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Test(),
                ),
              );
            },
            icon: const Icon(Icons.notification_add),
          ),
          IconButton(
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Files(),
                ),
              );
            },
            icon: const Icon(Icons.image),
          ),
          IconButton(
            onPressed: () async {
              GoogleSignIn google = GoogleSignIn();
              google.disconnect();
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
                (route) => false,
              );
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                    color: Colors.blue, strokeWidth: 1),
              );
            }
            return GridView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onLongPress: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.rightSlide,
                      title: 'Error',
                      desc: 'choose what you want ?? ',
                      btnCancelText: 'delete',
                      btnOkText: 'update',
                      btnOkOnPress: () async{
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Edit(name: data[index]['name'], docId: data[index].id),));
                       } ,
                      btnCancelOnPress: () async {
                        await FirebaseFirestore.instance.collection("categories").doc(data[index].id).delete();
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Homepage(),), (route) => false);
                      }
                    ).show();
                  },
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ViewNote(name: data[index]['name'], catId: data[index].id,))),
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/folder.png',
                            height: 100,
                          ),
                          Text(data[index]['name'])
                        ],
                      ),
                    ),
                  ),
                );
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 160,
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const Add()));
        },
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

/*
FirebaseAuth.instance.currentUser!.sendEmailVerification() ;
 */
