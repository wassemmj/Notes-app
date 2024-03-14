import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/auth/signup_page.dart';
import 'package:fluttercourse/auth/widget/auth_button.dart';
import 'package:fluttercourse/auth/widget/custom_text_from_field.dart';
import 'package:fluttercourse/auth/widget/logo.dart';
import 'package:fluttercourse/auth/widget/password_from_field.dart';
import 'package:fluttercourse/auth/widget/text_line.dart';
import 'package:fluttercourse/homepage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  GlobalKey<FormState> form = GlobalKey<FormState>();

  bool isLoading = false ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ?  const Center(child: CircularProgressIndicator(color: Colors.blue, strokeWidth: 1),) : SingleChildScrollView(
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
                  "Login".toUpperCase(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Login to continue using the app",
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                PasswordFromField(
                  controller: passwordController,
                  text: 'Password',
                  validator: (value) {
                    if (value == "") {
                      return "can't to be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Container(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () async {
                      if (emailController.text.isNotEmpty) {
                        try {
                          await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text) ;
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.success,
                            animType: AnimType.rightSlide,
                            title: 'success',
                            desc:
                            'go to your email and change your password',
                          ).show();
                        } catch (e) {
                          print(e) ;
                        }
                      } else {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'error',
                          desc:
                          'write your email before ',
                        ).show();
                      }
                    },
                    child: const Text(
                      "Forgot Password ?",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                AuthButton(
                    text: "Login",
                    onPressed: () async {
                      if (form.currentState!.validate()) {
                        try {
                          isLoading = !isLoading ;
                          setState(() {});
                          final credential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                          isLoading = !isLoading ;
                          setState(() {});
                          if (credential.user!.emailVerified) {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => const Homepage(),
                            ));
                          } else {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Error',
                              desc:
                                  'please go to your email and verify your account',
                            ).show();
                          }
                        } on FirebaseAuthException catch (e) {
                          print(e.code);
                          isLoading = !isLoading ;
                          setState(() {});
                          if (e.code == 'invalid-email') {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Error',
                              desc: 'No user found for that email.',
                            ).show();
                          } else if (e.code == 'invalid-credential') {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Error',
                              desc: 'Wrong password provided for that user.',
                            ).show();
                          }
                        }
                      } else {
                        isLoading = false ;
                        setState(() {});
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc: 'Write the all details',
                        ).show();
                      }
                    }),
                const SizedBox(height: 12),
                const TextLine(text: "Or login with"),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        FontAwesomeIcons.facebook,
                        color: Colors.blueAccent,
                        size: 25,
                      ),
                    ),
                    const SizedBox(width: 15),
                    IconButton(
                      onPressed: () {
                        signInWithGoogle();
                      },
                      icon: const Icon(
                        FontAwesomeIcons.google,
                        color: Colors.red,
                        size: 25,
                      ),
                    ),
                    const SizedBox(width: 15),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        FontAwesomeIcons.github,
                        color: Colors.black,
                        size: 25,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "You don't have an account ?",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const SignupPage()));
                      },
                      child: const Text(
                        "Register",
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

  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      return;
    }

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const Homepage(),
        ),
        (route) => false);
  }
}
