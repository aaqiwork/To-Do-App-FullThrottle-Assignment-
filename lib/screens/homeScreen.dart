import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/models/ToDoModel.dart';
import 'package:todo/screens/addToDo.dart';
import 'package:todo/widgets/todoList.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String uid = '';
  @override
  void initState() {
    super.initState();
// getting the user Id from firebase so as to collect the user details
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        uid = user.uid;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('To Do'), centerTitle: true),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightBlueAccent,
          elevation: 12,
          // floating button when pressed navigates to add To do screen
          onPressed: () => Navigator.of(context)
              .pushNamed(AddToDo.routeName, arguments: ToDoModel()),
          tooltip: 'Add ',
          child: Icon(Icons.add),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // To do list is the widget whcih shows the list of all the to do items
          child: ToDoList(uid),
        ));
  }
}
