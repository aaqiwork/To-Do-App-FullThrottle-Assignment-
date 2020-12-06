import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/widgets/authForm.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(
      String email, String password, bool isLogin, BuildContext ctx) async {
    try {
      setState(() {
        _isLoading = true;
      });
      AuthResult authResult;
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        Firestore.instance
            .collection('todo')
            .document(authResult.user.uid)
            .collection('List')
            .add({
          'date': DateTime.now(),
          'title': 'Welcome to To Do App',
          'description':
              'You can enter all your to do list by clicking the below floating button and edit by clicking me',
        });
        Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({
          'id': authResult.user.uid,
          'email': email,
          'joined_date': new DateTime.now(),
        });
      }
    } on PlatformException catch (err) {
      var message = 'An error occured, please check you credentials!';
      if (err.message != null) {
        message = err.message;
      }
      Scaffold.of(ctx).showSnackBar(SnackBar(
          content: Text(message), backgroundColor: Theme.of(ctx).errorColor));
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/login-bg.jpg'),
            ),
          ),
          child: AuthForm(_submitAuthForm, _isLoading)),
    );
  }
}
