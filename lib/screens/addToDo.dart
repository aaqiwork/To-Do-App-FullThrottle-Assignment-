import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/models/ToDoModel.dart';
import 'package:flutter/services.dart';

class AddToDo extends StatefulWidget {
  static const routeName = '/instructor-list';
  @override
  _AddToDoState createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
  String uid = '';
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        uid = user.uid;
      });
    });
  }

// the function which calls the edit/update or delete function to firebase database
  void _editUpdate(String title, String description, bool update, String id,
      BuildContext ctx) async {
    if (update) {
      try {
        await Firestore.instance
            .collection('todo')
            .document(uid)
            .collection('List')
            .document(id)
            .updateData({
          'title': title,
          'description': description,
          'date': DateTime.now(),
        });
        Navigator.of(context).pop();
      } on PlatformException catch (err) {
        var message = 'An error occured, please check you credentials!';
        if (err.message != null) {
          message = err.message;
        }
        Scaffold.of(ctx).showSnackBar(SnackBar(
            content: Text(message), backgroundColor: Theme.of(ctx).errorColor));

        Navigator.of(context).pop();
      } catch (err) {
        print(err);
        Navigator.of(context).pop();
      }
    } else {
      try {
        await Firestore.instance
            .collection('todo')
            .document(uid)
            .collection('List')
            .document(id)
            .delete();

        Navigator.of(context).pop();
      } on PlatformException catch (err) {
        var message = 'An error occured, please check you credentials!';
        if (err.message != null) {
          message = err.message;
        }
        Scaffold.of(ctx).showSnackBar(SnackBar(
            content: Text(message), backgroundColor: Theme.of(ctx).errorColor));

        Navigator.of(context).pop();
      } catch (err) {
        print(err);
        Navigator.of(context).pop();
      }
    }
  }

  void _submitQA(String question, String answer, bool edit, String id,
      BuildContext ctx) async {
    try {
      await Firestore.instance
          .collection('todo')
          .document(uid)
          .collection('List')
          .add({
        'title': question,
        'description': answer,
        'date': DateTime.now(),
      });
      Navigator.of(context).pop();
    } on PlatformException catch (err) {
      var message = 'An error occured, please check you credentials!';
      if (err.message != null) {
        message = err.message;
      }
      Scaffold.of(ctx).showSnackBar(SnackBar(
          content: Text(message), backgroundColor: Theme.of(ctx).errorColor));

      Navigator.of(context).pop();
    } catch (err) {
      print(err);
      Navigator.of(context).pop();
    }
  }

  final _formKey = GlobalKey<FormState>();
  String title;
  String description;
  DateTime date;
  String id = '';
  bool edit;

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    if (isValid) {
      _formKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      _submitQA(title.trim(), description.trim(), edit, id, context);
    }
  }

  void _tryEditUpdate(bool update) {
    final isValid = _formKey.currentState.validate();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState.save();
      _editUpdate(title.trim(), description.trim(), update, id, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    final ToDoModel current = ModalRoute.of(context).settings.arguments;
    title = current.title != null ? current.title : null;
    if (title != null) {
      id = current.id;
    }
    edit = current.title != null ? true : false;
    description = current.description != '' ? current.description : '';
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: _isLoading
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  child: Center(child: CircularProgressIndicator()))
              : Container(
                  padding: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height-100,
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 0.5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey[400]),
                              ),
                              child: TextFormField(
                                onEditingComplete: () => node.nextFocus(),
                                style: TextStyle(color: Colors.black),
                                maxLines: 1,
                                autocorrect: true,
                                initialValue: title,
                                //textCapitalization: TextCapitalization.words,
                                enableSuggestions: true,
                                key: ValueKey('title'),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter the Title';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                    hoverColor: Colors.grey[400],
                                    focusColor: Colors.grey[400],
                                    fillColor: Colors.grey[400],
                                    labelStyle: TextStyle(color: Colors.black),
                                    counterStyle:
                                        TextStyle(color: Colors.grey[400]),
                                    labelText: 'Enter Title here'),
                                onSaved: (value) {
                                  title = value;
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, top: 10, bottom: 1),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey[400]),
                              ),
                              child: TextFormField(
                                onEditingComplete: () => node.unfocus(), 
                                key: ValueKey('description'),
                                maxLines: 18,
                                initialValue: description,
                                autocorrect: true,
                                keyboardType: TextInputType.text,
                                //textCapitalization: TextCapitalization.words,
                                enableSuggestions: true,
                                validator: (value) {
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Enter a Description here',
                                  hoverColor: Colors.black,
                                  focusColor: Colors.black,
                                  fillColor: Colors.black,
                                  labelStyle: TextStyle(color: Colors.black),
                                ),
                                onSaved: (value) {
                                  description = value;
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            edit
                                ? Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () => _tryEditUpdate(true),
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 10, right: 6),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            height: 40,
                                            child: Text('Update',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => _tryEditUpdate(false),
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 6, right: 10),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            height: 40,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            child: Text('Delete',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: _trySubmit,
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      height: 40,
                                      child: Text('Save',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                          ]),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
