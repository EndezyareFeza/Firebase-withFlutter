import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auth - Firebase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _imageUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Board"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                child: Text("Google-Sign-in"),
                onPressed: () => _gSignin(),
                color: Colors.red,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                color: Colors.orange,
                child: Text("Sign in with Email"),
                onPressed: () => _signInWithEmail(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                color: Colors.purple,
                child: Text("Create Account"),
                onPressed: () => _createUser(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                color: Colors.lightGreenAccent,
                child: Text("Logout"),
                onPressed: () => _logout(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                color: Colors.deepOrangeAccent,
                child: Text("Sign out"),
                onPressed: () => _signoutemail(),
              ),
            ),
            new Image.network(_imageUrl == null || _imageUrl.isEmpty
                ? "https://picsum.photos/250?image=9"
                : _imageUrl)
          ],
        ),
      ),
    );
  }

  Future<FirebaseUser> _gSignin() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    FirebaseUser user = await _auth.signInWithCredential(credential);

    print("User is: ${user.photoUrl}");

    setState(() {
      _imageUrl = user.photoUrl;
    });
    return user;
  }

  Future _createUser() async {
    FirebaseUser user = await _auth
        .createUserWithEmailAndPassword(
            email: "melayecizirii73@gmail.com", password: "diwan132173")
        .then((userNew) {
      print("User created: ${userNew.displayName}");
      print("Email: ${userNew.email}");
    });
    //print(user.email);
  }

  _logout() {
    setState(() {
      _googleSignIn.signOut();
      _imageUrl = null;
    });
  }

  _signInWithEmail() {
    _auth
        .signInWithEmailAndPassword(
            email: "melayecizirii73@gmail.com", password: "diwan132173")
        .catchError((error) {
      print("Something went wrong! ${error.toString()}");
    }).then((newUser) {
      print("User signed in: ${newUser.email}");
    });
  }

  _signoutemail() {
    _auth.signOut();
  }
}
