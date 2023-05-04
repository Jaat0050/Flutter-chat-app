import 'package:chat_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future signInFunction() async {
    //signin(get authentication and credentials) from google account and check user (google accounts)
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      //user does not choose any account just go back
      return;
    }
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    //firebase can access account and store data
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

//succellfully signed in and now store data in firebase

    //getting data from database
    DocumentSnapshot userExist =
        await firestore.collection('users').doc(userCredential.user!.uid).get();

    //checking if user already exists
    if (userExist.exists) {
      // ignore: avoid_print
      print("user already exists");
    } else {
      //updating data base
      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': userCredential.user!.email,
        'name': userCredential.user!.displayName,
        'image': userCredential.user!.photoURL,
        'uid': userCredential.user!.uid,
        'date': DateTime.now(),
      });
    }

    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MyApp(),
        ),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 232, 250, 234),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 100,
              ),
              child: Text(
                "Flutter Chat App",
                style: TextStyle(
                    color: Colors.green[800],
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/I1.jpg"),
                      colorFilter:
                          ColorFilter.mode(Colors.green, BlendMode.color),
                      fit: BoxFit.cover),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(50),
              child: ElevatedButton(
                onPressed: () async {
                  await signInFunction();
                },
                style: ButtonStyle(
                  backgroundColor: const MaterialStatePropertyAll(Colors.black),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Image(
                      image: AssetImage("images/G1.jpg"),
                      height: 36,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Sign in with Google",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
