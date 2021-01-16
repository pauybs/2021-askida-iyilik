import 'package:flutter/src/widgets/text.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';

import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:rflutter_alert/rflutter_alert.dart';

class DonateConfirm extends StatefulWidget {
  String id;
  String title;

  String companyName1;
  DonateConfirm(
      {this.id, this.title, this.companyName1});

  @override
  makeDonateConfirmScreen createState() => makeDonateConfirmScreen();
}

TextEditingController t1 = TextEditingController();

class makeDonateConfirmScreen extends State<DonateConfirm> {
  var formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  String userCode1;
  String compCode;
  String corporateId;

  @override
  Widget build(BuildContext context) {
    print(widget.id);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.all(20.0),
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/kayitEkran.jpg"),
          fit: BoxFit.cover,
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 100,
                  ),
                  TextFormField(
                    controller: t1,
                    onSaved: (x) {
                      setState(() {
                        userCode1 = x;
                      });
                    },
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 50, color: Colors.grey),
                    obscureText: false,
                    decoration: InputDecoration(
                        hintText: "Kod",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 50,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          kodDenetim();
                        },
                        color: Colors.blue[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        hoverColor: Colors.black,
                        child: Text(
                          "Onayla",
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  kodDenetim() {
    CollectionReference users = FirebaseFirestore.instance.collection('products');

    FirebaseFirestore.instance
        .collection('corpCode')
        .doc(widget.companyName1)
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> firestoreInfo = documentSnapshot.data();

      setState(() {
        compCode = firestoreInfo['kod'];
      });
    });
    if (compCode == t1.text) {
      users
          .doc(widget.id)
          .delete()
          .then((value) => Navigator.pushNamed(context, "/donatePage"))
          .catchError((error) => print("Askıdan alma başarısız: $error"));
    }

  }


}
