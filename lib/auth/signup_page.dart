import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/auth/widget/auth_button.dart';
import 'package:fluttercourse/auth/widget/custom_text_from_field.dart';
import 'package:fluttercourse/auth/widget/logo.dart';
import 'package:fluttercourse/auth/widget/password_from_field.dart';
import 'package:fluttercourse/homepage.dart';

import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  var nameController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  GlobalKey<FormState> form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const RangeMaintainingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Logo(),
                Text(
                  "Signup".toUpperCase(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Signup to continue using the app",
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 15),
                CustomTextFromField(
                  controller: nameController,
                  text: 'Name',
                  validator: (value) {
                    if (value == "") {
                      return "can't to be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                CustomTextFromField(
                  controller: emailController,
                  text: 'Email',
                  validator: (value) {
                    if (value == "") {
                      return "can't to be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                PasswordFromField(
                  controller: passwordController,
                  text: 'Password',
                  validator: (value) {
                    if (value == "") {
                      return "can't to be empty" ;
                    }
                    return null ;
                  },
                ),
                const SizedBox(height: 15),
                AuthButton(
                    text: "Signup",
                    onPressed: () async {
                      if (form.currentState!.validate()) {
                        try {
                          final credential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                          FirebaseAuth.instance.currentUser!.sendEmailVerification();
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ));
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Error',
                              desc: 'The password provided is too weak.',
                            ).show();
                          } else if (e.code == 'email-already-in-use') {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Error',
                              desc: 'The account already exists for that email.',
                            ).show();
                          }
                        } catch (e) {
                          print(e);
                        }
                      } else {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc: 'write with all details',
                        ).show();
                      }
                    }),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "You already have an account ?",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
