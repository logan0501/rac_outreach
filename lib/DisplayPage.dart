import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rac_outreach/AddItem.dart';
import 'package:rac_outreach/HomePage.dart';
import 'package:rac_outreach/ViewDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisplayPage extends StatefulWidget {
  bool isoutreach;
  DisplayPage(this.isoutreach);
  @override
  _DisplayPageState createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {

  int _currentindex = 0;
  final List<Widget> _children = [AddItem(), ViewFDetails()];

   @override
  Widget build(BuildContext context) {
  print('recieved value'+widget.isoutreach.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MAKE AN IMPACT',
          textAlign: TextAlign.center,
        ),
        leading: IconButton(
          icon: Icon(Icons.transit_enterexit),
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false);
          },
        ),
      ),
      body: Center(
        child: widget.isoutreach ? _children[_currentindex] : ViewFDetails(),
      ),
      bottomNavigationBar: widget.isoutreach
          ? BottomNavigationBar(
              onTap: (value) {
                setState(() {
                  _currentindex = value;
                });
              },
              currentIndex: _currentindex,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.add), label: 'Add Task'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.mail),
                  label: 'Messages',
                ),
              ],
            )
          : null,
    );
  }
}
