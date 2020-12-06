import 'package:flutter/material.dart';
import 'package:todo/models/ToDoModel.dart';
import 'package:intl/intl.dart';
import 'package:todo/screens/addToDo.dart';

class ToDoCard extends StatelessWidget {
  //different color cards for design
  final List<Color> greenCard = [
    Colors.green[300],
    Colors.green[200],
    Colors.green[300],
  ];
  final List<Color> orangeCard = [
    Colors.orange[300],
    Colors.orange[300],
    Colors.orange[300],
  ];
  final List<Color> purpleCard = [
    Colors.purple[200],
    Colors.purple[200],
    Colors.purple[200],
  ];
  final List<Color> blueCard = [
    Colors.lightBlueAccent,
    Colors.lightBlueAccent[100],
    Colors.lightBlueAccent,
  ];
  final ToDoModel current;
  final int color;
  ToDoCard(this.color, this.current);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Navigating to Add to Do when clicked on the current card
      onTap: () {
        Navigator.of(context).pushNamed(AddToDo.routeName, arguments: current);
      },
      child: Container(
          margin: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 4),
                  blurRadius: 4,
                  color: Colors.black26,
                ),
              ],
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                  //deciding color of card
                  colors: color == 0
                      ? blueCard
                      : color == 1
                          ? orangeCard
                          : color == 2 ? purpleCard : greenCard)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(current.title,
                              // overflow criteria handled
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                        ),
                        Text(
                            current.date.day == DateTime.now().day &&
                                    current.date.month ==
                                        DateTime.now().month &&
                                    current.date.year == DateTime.now().year
                                ? DateFormat.jm().format(current.date)
                                : DateFormat('E MMM dd').format(current.date),
                            // date formatting to time when the date is today otherwise showing date in complete form
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ]),
                  current.description != ''
                      ? Text(current.description,
                          textAlign: TextAlign.justify,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 16))
                      : SizedBox()
                  // Showing text of description only if the description is present.
                  // Only max 3 lines is shown and it is justified
                ]),
          )),
    );
  }
}
