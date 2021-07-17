import 'package:flutter/material.dart';


class TaskListTile extends StatelessWidget {
  String text;
  Function deletetask;

  TaskListTile({this.text, this.deletetask});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3))
      ]),
      child: ListTile(
        title: Text(text),
        trailing: IconButton(onPressed: deletetask, icon: Icon(Icons.close)),
      ),
    );
  }
}

// #25C598