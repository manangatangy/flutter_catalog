


// ref: https://console.cloud.google.com/firestore/welcome?project=api-9111391984561677101-76037
// https://www.youtube.com/watch?v=DqJ_KjFzL9I
// Actually https://console.firebase.google.com/u/0/?pli=1 is a better interface
// It seems I'm using https://firebase.google.com/pricing/  Blaze plan
// also https://firebase.google.com/support/faq/
// Some GCP docco https://cloud.google.com/resource-manager/docs/how-to
// On the firebase console, there's also some info about using a debug signing certificate SHA-1abstract
// at https://developers.google.com/android/guides/client-auth
// This is where I generated flutter_catalog/android/app/google-services.json


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BandvoteApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BandvotePage(),
    );
  }
}

class BandvotePage extends StatelessWidget {

  Widget _buildItem(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(
              document['name'],
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xffddddff),
            ),
            padding: EdgeInsets.all(10.0),
            child: Text(
              document['votes'].toString() ,
              style: Theme.of(context).textTheme.display1,
            ),
          ),
        ],
      ),
      onTap: () {
        Firestore.instance.runTransaction((transaction) async {
          DocumentSnapshot freshSnap = await transaction.get(document.reference);
          await transaction.update(freshSnap.reference, {
            'votes': freshSnap['votes'] + 1,
          });
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bandvote'),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('bandnames').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text('loading ...');
          return ListView.builder(
            itemExtent: 80.0,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) =>
                _buildItem(context, snapshot.data.documents[index]),
          );
        }

      ),
    );
  }
}
