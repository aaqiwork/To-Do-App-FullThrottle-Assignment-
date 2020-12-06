import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading);
  final bool isLoading;

  final void Function(
      String email, String password, bool isLogin, BuildContext ctx) submitFn;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = false;
  var _userEmail = '';

  var _password = '';

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(_userEmail.trim(), _password.trim(), _isLogin, context);
    }
  }

  void forgotPassword(BuildContext ctx) async {
    FocusScope.of(context).unfocus();
    _formKey.currentState.save();
    if (_userEmail.isEmpty ||
        !_userEmail.contains('@') ||
        !_userEmail.contains('.')) {
      Scaffold.of(ctx).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Please enter a valid email address',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          )));
    } else {
      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
      try {
        await _firebaseAuth.sendPasswordResetEmail(email: _userEmail.trim());
        Scaffold.of(ctx).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'An email has been sent to you email address to reset your password',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            )));
      } catch (error) {
        Scaffold.of(ctx).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              error.message,
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Center(
      child: Card(
        elevation: 0,
        //shadowColor: Colors.grey,
        color: Colors.transparent,
        margin: EdgeInsets.all(20),
        child: Container(
          height: MediaQuery.of(context).size.height / 1.8,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/logo.png',
                          fit: BoxFit.contain, height: 100),
                      Text('To Do Do',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.blue, fontWeight:FontWeight.bold)),
                      TextFormField(
                        style: TextStyle(color: Colors.black),
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        enableSuggestions: true,
                        key: ValueKey('email'),
                        // validation of email checkign if it contains @ and .co in it
                        validator: (value) {
                          if (value.isEmpty ||
                              !value.contains('@') ||
                              !value.contains(".co")) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        onEditingComplete: () => node.nextFocus(),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Email Address',
                            labelStyle: TextStyle(color: Colors.black),
                            icon: Icon(
                              Icons.email,
                              color: Colors.black,
                            )),
                        onSaved: (value) {
                          _userEmail = value;
                        },
                      ),
                      TextFormField(
                        onEditingComplete: () => node.unfocus(),
                        style: TextStyle(color: Colors.black),
                        key: ValueKey('password'),
                        validator: (value) {
                          if (value.isEmpty || value.length < 7) {
                            return 'Password must be atleast 7 characters long';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.black),
                            icon: Icon(Icons.lock, color: Colors.black)),
                        onSaved: (value) {
                          _password = value;
                        },
                        obscureText: true,
                      ),
                      SizedBox(height: 22),
                      if (!widget.isLoading)
                        GestureDetector(
                          onTap: _trySubmit,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.lightBlue,
                                borderRadius: BorderRadius.circular(20)),
                            alignment: Alignment.center,
                            height: 40,
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Text(_isLogin ? 'Login' : 'Signup',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      FlatButton(
                        textColor: Colors.black,
                        child: !widget.isLoading
                            // based on login value it is showing the text accordingly and
                            //switching the screen and showns loading if clicked until redirected
                            ? Text(
                                _isLogin
                                    ? 'Create new Account'
                                    : 'I already have an account',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )
                            : CircularProgressIndicator(),
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                      ),
                      _isLogin
                          ? FlatButton(
                              textColor: Theme.of(context).primaryColor,
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                forgotPassword(context);
                              },
                            )
                          : SizedBox(),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
