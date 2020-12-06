import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/models/ToDoModel.dart';
import 'package:todo/widgets/todoCard.dart';

class ToDoList extends StatelessWidget {
  final String id;
  ToDoList(this.id);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/white-bg2.jpg'))),
      child: FutureBuilder(
          future: FirebaseAuth.instance.currentUser(),
          builder: (ctx, futureSnapshot) {
            if (futureSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            // the data is stored in firebase in a docuemnt of the user's uid created at time
            //of signup and in that document collections are stored
            return StreamBuilder(
                stream: Firestore.instance
                    .collection('todo')
                    .document(id)
                    .collection('List')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final docs = snapshot.data.documents;
                  // sorting data
                  List<dynamic> sortedDocs = sortCards(docs);
                  return sortedDocs.length == 0
                      ? Container(
                          child: Center(
                              child: Text('No Items available',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20))))
                      : Column(children: [
                          // the data is passed to ToDoCard in the form of ToDo Model
                          Expanded(
                            child: ListView.builder(
                                itemCount: sortedDocs.length,
                                itemBuilder: (ctx, i) => ToDoCard(
                                    i % 4,
                                    ToDoModel(
                                        id: sortedDocs[i].documentID,
                                        title: sortedDocs[i]['title'],
                                        description: sortedDocs[i]
                                            ['description'],
                                        date: sortedDocs[i]['date'].toDate()))),
                          ),
                        ]);
                });
          }),
    );
  }
}

// sorting the cards based on the time and date from recent to oldest and then returning accordingly.
List<dynamic> sortCards(List<dynamic> classes) {
  for (int i = 0; i < classes.length; i++) {
    classes.sort((a, b) {
      if (a['date'].toDate().isBefore(b['date'].toDate())) {
        return 1;
      } else
        return 0;
    });
  }
  return classes;
}
