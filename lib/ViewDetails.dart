import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class ViewFDetails extends StatefulWidget {
  @override
  _ViewFDetailsState createState() => _ViewFDetailsState();
}

class _ViewFDetailsState extends State<ViewFDetails> {
  final _outreachsStream = FirebaseFirestore.instance.collection('tasks').snapshots();
  


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _outreachsStream,
            builder: ( context,  snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              return  Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: snapshot.data.docs.map((document)  {

                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;


                    return  ListTile(
                      title: Text(data['name']),
                      subtitle: Text(data['taskname']??"Available"),
                      trailing: IconButton(icon: Icon(Icons.call),),
                    );
                  }).toList(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
