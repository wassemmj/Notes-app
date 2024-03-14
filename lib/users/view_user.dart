import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/homepage.dart';
import 'package:fluttercourse/users/add_user.dart';

class ViewUser extends StatefulWidget {
  const ViewUser({super.key});

  @override
  State<ViewUser> createState() => _ViewUserState();
}

class _ViewUserState extends State<ViewUser> {
  List<QueryDocumentSnapshot> data = [];

  // filter .where
  // order .orderBy
  // .limit(2)
  // .startAt(['30']) .startAfter(['20'])
  // .endAt(['30']) .endBefore(['20'])

  // getData() async {
  //   data.clear();
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //       .collection('user').get();
  //   querySnapshot.docs.forEach((element) {
  //     data.add(element);
  //   });
  // }

  Stream queryStream = FirebaseFirestore.instance
      .collection('user').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'users',
        ),
        actions: [
          IconButton(
            onPressed: () {
              CollectionReference users = FirebaseFirestore.instance.collection('user');
              DocumentReference doc1 = FirebaseFirestore.instance.collection('user').doc("1");
              DocumentReference doc2  = FirebaseFirestore.instance.collection('user').doc("3");
              WriteBatch batch = FirebaseFirestore.instance.batch();
              batch.delete(doc1, ) ;
              batch.set(doc2, {
                'name' : 'mohammed3' ,
                'age' : '202' ,
                'phone' : '55555555565' ,
                'price' : '505' ,
              }) ;
              batch.commit() ;
            },
            icon: const Icon(
              Icons.add,
              color: Colors.blue,
            ),
          ),
        ],
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
        child: StreamBuilder(
            stream: queryStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                      color: Colors.blue, strokeWidth: 1),
                );
              }
              var data = snapshot.data!.docs ;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onLongPress: () {
                      FirebaseFirestore
                          .instance
                          .collection('user')
                          .doc(data[index].id).delete() ;
                    },
                    onTap: () {
                      DocumentReference documentReference = FirebaseFirestore
                          .instance
                          .collection('user')
                          .doc(data[index].id);
                      FirebaseFirestore.instance
                          .runTransaction((transaction) async {
                        DocumentSnapshot snapshot =
                            await transaction.get(documentReference);
                        if (snapshot.exists) {
                          var snapshotData = snapshot.data();
                          if (snapshotData is Map) {
                            int money = int.parse(snapshotData['price']) + 100;
                            transaction.update(documentReference, {
                              'price': "$money",
                            });
                          }
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Card(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data[index]['name'],
                                    maxLines: 2,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'age : ${data[index]['age']}',
                                        maxLines: 2,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.black38,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      Text(
                                        'phone : ${data[index]['phone']}',
                                        maxLines: 2,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.black38,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              data[index]['price'],
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
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
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const AddUser()));
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

// batch i can do more write function inside in the same time
// set , update , delete
