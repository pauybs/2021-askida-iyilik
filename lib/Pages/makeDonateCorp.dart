import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:iyilikaskisiapp/Pages/makeDonate.dart';
import 'package:iyilikaskisiapp/Pages/makeDonateConfirm.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:iyilikaskisiapp/Pages/makeDonate.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/src/widgets/text.dart';

import 'package:flutter/rendering.dart';

class MakeDonateCorp extends StatefulWidget {
  final String title;
  MakeDonateCorp(this.title);

  @override
  makeDonateCropScreen createState() => makeDonateCropScreen();
}

// SAYFALARI ÇAĞIRMAK İÇİN KULLANILAN SINIF

class makeDonateCropScreen extends State<MakeDonateCorp> {
  Stream collectionStream =
      FirebaseFirestore.instance.collection('corpCode').snapshots();
  Stream documentStream =
      FirebaseFirestore.instance.collection('corpCode').doc().snapshots();
  var formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  TextEditingController t1 = TextEditingController();

  String productName;
  String productPiece;
  String companyName;
  String userCode;
  String urunAdi;
  String title;
  String _urunAdiVal;
  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('corpCode');
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
                  SizedBox(height: 60),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('corpCode')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return new Text("Lütfen Bekleyiniz...");
                        var length = snapshot.data.docs.length;
                        DocumentSnapshot ds =
                        snapshot.data.docs[length - 1];

                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 0.0, right: 0.0),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey, width: 1.0),
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                              child: new DropdownButton(
                                hint: new Text("İşletme"),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                                elevation: 0,
                                iconSize: 36.0,
                                isExpanded: true,
                                items: snapshot.data.docs
                                    .map((DocumentSnapshot document) {
                                  return DropdownMenuItem(
                                      value: document.data()['companyName'],
                                      child: new Text(
                                          document.data()["companyName"]));
                                }).toList(),
                                value: _urunAdiVal,
                                onChanged: (value) {
                                  setState(() {
                                    _urunAdiVal = value;
                                  });

                                },

                              ),
                            ),
                          ),
                        );
                      }),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.fromLTRB(100, 20, 100, 30),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide(color: Colors.blue[500])),
                      color: Colors.blue[500],
                      textColor: Colors.white,
                      padding: EdgeInsets.all(20.0),
                      onPressed: () {
                        isletmeYolla();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Devam Et", style: TextStyle(fontSize: 20)),
                          Icon(Icons.arrow_right)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void isletmeYolla() {

    if(_urunAdiVal == null){
      Alert(

          type: AlertType.warning,
          context: context,
          title: "HATA!",
          desc: "Lütfen İşletme Seçimi Yapınız",
          buttons: [
            DialogButton(
                child: Text(
                  "Kapat",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ]).show();
    }
    else{
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MakeDonate(title,
                companyName1: _urunAdiVal,

              )));
    }



  }
}
