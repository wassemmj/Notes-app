import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/homepage.dart';
import 'package:fluttercourse/note/add_note.dart';
import 'package:fluttercourse/note/edit_note.dart';

class ViewNote extends StatefulWidget {
  const ViewNote({super.key, required this.name, required this.catId});

  final String name;
  final String catId;

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  List<QueryDocumentSnapshot> data = [];

  getData() async {
    data.clear();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.catId)
        .collection('note')
        .get();
    data.addAll(querySnapshot.docs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const Homepage(),
              ),
              (route) => false);
          return Future.value(false);
        },
        child: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                      color: Colors.blue, strokeWidth: 1),
                );
              }
              return ListView.builder(
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
                          btnOkOnPress: () async {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditNote(
                                oldName: data[index]['note'],
                                docId: data[index].id,
                                catId: widget.catId,
                                catName: widget.name,
                              ),
                            ));
                          },
                          btnCancelOnPress: () async {
                            if (data[index]['url']!='none') {
                              FirebaseStorage.instance.refFromURL(data[index]['url']).delete() ;
                            }
                            await FirebaseFirestore.instance
                                .collection("categories")
                                .doc(widget.catId)
                                .collection('note')
                                .doc(data[index].id)
                                .delete();
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ViewNote(
                                name: widget.name,
                                catId: widget.catId,
                              ),
                            ));
                          }).show();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Card(
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: [
                              data[index]['url'] == 'none'
                                  ? Container()
                                  : Image.network(
                                      data[index]['url'],
                                      width: 50,
                                      height: 50,
                                    ),
                              Text(
                                data[index]['note'],
                                maxLines: 2,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => AddNote(
                    catId: widget.catId,
                    name: widget.name,
                  )));
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
