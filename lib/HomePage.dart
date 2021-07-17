import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:rac_outreach/DisplayPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String email,password;
  bool progress=false;
  bool isoutreach=false;
  FirebaseAuth user = FirebaseAuth.instance;
  FirebaseFirestore data =  FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: !progress ?Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              style: TextStyle(
                fontSize: 20,
              ),

              onChanged: (val) {

                email=val;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',

              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              style: TextStyle(
                fontSize: 20,
              ),
              obscureText: true,
              onChanged: (val) {

                password=val;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',

              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(onPressed: ()async{
            setState(() {
              progress = true;
            });
            try{
              final userval = await user.signInWithEmailAndPassword(email: email.toString().trim(), password: password.toString().trim());
              final currentuser = user.currentUser;

              data.collection('outreach').doc(currentuser.uid).get().then((value) async{

                if(value.exists) {
                    isoutreach=true;
                    final prefs = await SharedPreferences.getInstance();
                    print('outreach val'+isoutreach.toString());
                    await prefs.setBool('isoutreach', isoutreach);
                    setState(() {
                      progress=false;

                    });
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DisplayPage(true),), (route) => false);

                }else{
                  isoutreach=false;
                  final prefs = await SharedPreferences.getInstance();
                  print('outreach val'+isoutreach.toString());
                  await prefs.setBool('isoutreach', isoutreach);
                  setState(() {
                    progress=false;

                  });

                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DisplayPage(false),), (route) => false);
                }
              });
            }catch(e){
              setState(() {
                progress=false;
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Some Error Occured")));
            }


            },
            child: Text('Login'),
            style:ButtonStyle(
              backgroundColor:MaterialStateProperty.all(Colors.blueAccent),
            ) ,

          )
        ],
      ):Center(child: CircularProgressIndicator()),

    );
  }
}

