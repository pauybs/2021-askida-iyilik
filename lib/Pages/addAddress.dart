import 'package:firebase_auth/firebase_auth.dart';
import 'package:iyilikaskisiapp/Pages/corporateCode.dart';

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iyilikaskisiapp/Pages/donateConfirm.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'corporateLogin.dart';

class AddAdress extends StatefulWidget {
  final String title;
  AddAdress({this.title});
  @override
  addAdress createState() => addAdress();
}

class addAdress extends State<AddAdress> {
  var formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseStorage = FirebaseFirestore.instance;

  TextEditingController t2 = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String cn;
  String ad;
  String adres;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        padding: EdgeInsets.all(20.0),
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/urunEkleme.jpg"),
          fit: BoxFit.cover,
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 160),
                  TextFormField(
                    controller: t2,
                    onSaved: (x) {
                      setState(() {
                        adres = x;
                      });
                    },
                    validator: (x) {
                      if (x.isEmpty) {
                        return 'Bu alan Boş Bırakılamaz!';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.comment_bank_outlined,
                        color: Colors.blue,
                      ),
                      errorStyle: TextStyle(fontSize: 18),
                      labelText: "İşletme Adresiniz",
                      labelStyle: TextStyle(fontSize: 20, color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(height: 30),
                  RaisedButton(
                    onPressed: adresEkle,
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    hoverColor: Colors.black,
                    child: Text(
                      "Onayla",
                      style: TextStyle(color: Colors.white, fontSize: 24),
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



  void adresEkle() {

    if (_formKey.currentState.validate()) {

      FirebaseFirestore.instance
          .collection('company')
          .doc(_auth.currentUser.email)
          .get()
          .then((value) {
        setState(() {
          FirebaseFirestore.instance
              .collection('adresses')
              .doc(value.data()['companyName'])
              .set({'adres':t2.text});
        });
      });

      Alert(
          type: AlertType.success,
          context: context,
          title: "ADRES GÜNCELLENDİ",
          desc: "Adresiniz Başarıyla Güncellendi",
          buttons: [
            DialogButton(
              child: Text(
                "KAPAT",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CorporateCode())),
            )
          ]).show();

    } else {
      return null;
    }
  }
}
