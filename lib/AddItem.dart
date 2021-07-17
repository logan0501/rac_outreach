import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'TaskListTile.dart';

class AddItem extends StatefulWidget {
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {

  FirebaseFirestore dataref = FirebaseFirestore.instance;
  String newtask,task="";
  SharedPreferences prefs;
  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textEditingController.dispose();
  }


  Future<void> loaddata() async {
    prefs = await SharedPreferences.getInstance();
    task = prefs.getString('data');

  }


  @override
  Widget build(BuildContext context) {
    print("hello"+task);
    return Center(
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(

          children: [
            FutureBuilder(builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.waiting){
                return TaskListTile(text:'loading');
              }
              return TaskListTile(
                text: task??"hello",
                deletetask: () async{
                  setState(() {

                    task='';
                  });
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString('data',task);
                  String name = await FirebaseFirestore.instance.collection('outreach').doc(FirebaseAuth.instance.currentUser.uid).get().then((value){
                    if(value.exists){
                      print("Exists");
                    }
                    return value.data()['name'].toString();
                  });
                  await dataref.collection('tasks').doc(FirebaseAuth.instance.currentUser.uid).set({'taskname':newtask,'name':name});
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sucessfully Added')));

                },
              );
            },
            future: loaddata(),
            ),

            SizedBox(
              height: 40,
            ),
            Expanded(
              child: TextField(
                controller: _textEditingController,
                onChanged: (val) {
                  newtask = val;
                },
                decoration: InputDecoration(
                    hintText: 'Enter Your Current Work',
                    suffixIcon: TextButton(
                      onPressed: ()async {
                        setState((){
                          task=newtask;

                          _textEditingController.clear();

                        });
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString('data',task);
                        print("data set");
                        String name = await FirebaseFirestore.instance.collection('outreach').doc(FirebaseAuth.instance.currentUser.uid).get().then((value){
                          if(value.exists){
                            print("Exists");
                          }
                          return value.data()['name'].toString();
                        });
                        await dataref.collection('tasks').doc(FirebaseAuth.instance.currentUser.uid).set({'taskname':newtask,'name':name});
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sucessfully Added')));
                        },
                      child: Icon(Icons.add),
                    )),
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }


}

