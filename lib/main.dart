import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:rac_outreach/DisplayPage.dart';
import 'package:rac_outreach/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isusersignedin = false;
  bool isoutreach;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadoutreach().then((_) {
      setState(() {});
    });

  }

  Future<void> loadoutreach() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    isoutreach = pref.getBool('isoutreach');
    // FirebaseAuth.instance.authStateChanges().listen((user) {
    //   if (user == null) {
    //     print('User is currently signed out!');
    //   } else {
    //     isusersignedin = true;
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      // home: (FirebaseAuth.instance.currentUser == null ||
      //         isoutreach == null ||
      //         !isusersignedin)
      //     ? HomePage()
      //     : DisplayPage(isoutreach),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.connectionState ==ConnectionState.waiting){
            return Scaffold(body: Center(child: CircularProgressIndicator(),));
          }
          print(isoutreach);
          if (snapshot.hasData) {
            print(snapshot.data);
            if(isoutreach!=null){

              return DisplayPage(isoutreach);
            }
           else{

             return HomePage();
            }
          }
          return HomePage();
        },
      ),
    );
  }
}
