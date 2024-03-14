import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/auth/login_page.dart';
import 'package:fluttercourse/auth/signup_page.dart';
import 'package:fluttercourse/homepage.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(message.notification!.title);
  print(message.notification!.body);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform
    // name: 'jk',
    options: const FirebaseOptions(
      apiKey: "AIzaSyCIouWaKUoLSDyIj8W09SJpcbqWIEbyr2k",
      appId: "1:311855770411:android:699073af2b7392146ab36e",
      messagingSenderId: "311855770411",
      projectId: "fluttercourse-7d4e5",
      // storageBucket: "gs://fluttercourse-7d4e5.appspot.com",
    ),
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.blue,
        appBarTheme: AppBarTheme(
          color: Colors.grey[50],
          titleTextStyle: const TextStyle(
            color: Colors.blue,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(
            color: Colors.blue ,
          )
        ),
        useMaterial3: true,
      ),
      home: (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser!.emailVerified) ? const Homepage() : const LoginPage(),
      routes: {
        "signup" : (context) => const SignupPage(),
      },
    );
  }
}
