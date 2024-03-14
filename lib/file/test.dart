import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/file/chat.dart';
import 'package:http/http.dart' as http;

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {

  getToken() async {
    String? myToken = await FirebaseMessaging.instance.getToken() ;
    print(myToken) ;
  }

  myRequestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  getInit () async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage() ;
    if (initialMessage != null && initialMessage.notification != null) {
      String? title = initialMessage.notification!.title ;
      String? body = initialMessage.notification!.body ;
      if (initialMessage.data['type'] == 'chat') {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const Chat())) ;
      }
    }
  }

  @override
  void initState() {
    getInit() ;
    myRequestPermission();
    super.initState();
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print('=================================');
        print(message.notification!.title);
        print(message.notification!.body);
      }
    }) ;
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.data['type'] == 'chat') {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const Chat())) ;
      }
    }) ;
    getToken() ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: ElevatedButton(
              onPressed: () async => await sendNotificationTopic('hi' , 'how are you' , 'note'),
              child: const Text('send Notification'),
            ),
          ),
          Container(
            child: ElevatedButton(
              onPressed: () async => await FirebaseMessaging.instance.subscribeToTopic('note'),
              child: const Text('subscribe'),
            ),
          ),
          Container(
            child: ElevatedButton(
              onPressed: () async => await FirebaseMessaging.instance.unsubscribeFromTopic('note'),
              child: const Text('unsubscribe'),
            ),
          ),
        ],
      ),
    );
  }

  sendNotification (title , message) async {
    var response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send') ,
      headers: {
        "Accept" : '*/*',
        'Content-Type': 'application/json',
        "Authorization": "key=AAAASJwNays:APA91bH5C-Tg8rjhHDcMYHZWBCKeKa7USr8664CCmKf-uPwLY84TTd_h_m0Nlzw3sFv0wMzP6TnWtOXhUxe3mTBRBiTbPWkWMr-HHtoksp1l5QP8f318l1R0UCnXV_Jdzmd-4fi_d-ZZ"
      } ,
      body: jsonEncode({
        "to": "cNNjIzKHRnW7gafHuA5eUv:APA91bGyUwEfFmaBYbMCNQ0fCabH9yMu187oVEpFf-98gyqHId62i8NnGl2na5w3Nq6kSGjpkMBmg-tpdZ7ykGkVTxGYC1dW4dJFp6MQAOimZLpk8868ospakkHrDNHGbYu2-wJTo2RZ",
        "notification": {
          "title": '$title',
          "body": '$message',
        },
        "data" : {
          'id' : '12' ,
          'name' : 'wassem' ,
          'type' : 'alert' ,
          'm' : 'ww',
        }
      })
    ) ;
    if (response.statusCode >= 200 && response.statusCode < 300) {
      print(response.body) ;
      return response.body ;
    }
    else {
      print("can't send notification");
    }
  }

  sendNotificationTopic (title , message , topic) async {
    var response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send') ,
        headers: {
          "Accept" : '*/*',
          'Content-Type': 'application/json',
          "Authorization": "key=AAAASJwNays:APA91bH5C-Tg8rjhHDcMYHZWBCKeKa7USr8664CCmKf-uPwLY84TTd_h_m0Nlzw3sFv0wMzP6TnWtOXhUxe3mTBRBiTbPWkWMr-HHtoksp1l5QP8f318l1R0UCnXV_Jdzmd-4fi_d-ZZ"
        } ,
        body: jsonEncode({
          "to": "/topics/$topic",
          "notification": {
            "title": '$title',
            "body": '$message',
          },
          "data" : {
            'id' : '12' ,
            'name' : 'wassem' ,
            'type' : 'alert' ,
            'm' : 'ww',
          }
        })
    ) ;
    if (response.statusCode >= 200 && response.statusCode < 300) {
      print(response.body) ;
      return response.body ;
    }
    else {
      print("can't send notification");
    }
  }
}
