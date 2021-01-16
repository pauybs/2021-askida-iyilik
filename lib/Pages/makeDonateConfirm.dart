import 'package:flutter/src/widgets/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';
import 'package:uuid/uuid.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:iyilikaskisiapp/Pages/makeDonate.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MakeDonateConfirm extends StatefulWidget {
  String productName1;
  String title;
  String productPiece1;
  String companyName;
  MakeDonateConfirm(
      {this.productName1, this.title, this.productPiece1, this.companyName});

  @override
  makeDonateConfirmScreen createState() => makeDonateConfirmScreen();
}

TextEditingController t1 = TextEditingController();

class makeDonateConfirmScreen extends State<MakeDonateConfirm> {
  var formKey = GlobalKey<FormState>();

  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  String userCode1;
  String compCode;
  String corporateId;
  String uuid = Uuid().v4();
  @override
  Widget build(BuildContext context) {
    print(widget.productName1);
    final MakeDonateConfirm args = ModalRoute.of(context).settings.arguments;
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
    //id ve kodu değişkene aktarıp kod denetimi yaptım ve yeni koleksiyon oluşturdum

    FirebaseFirestore.instance
        .collection('corpCode')
        .doc(widget.companyName)
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> firestoreInfo = documentSnapshot.data();

      setState(() {
        compCode = firestoreInfo['kod'];
      });
        //iki kodun eşitliğini kontrol edip eşitse bağışı veri tabanına ekledim ve belgesi id olan bağışlar oluşturdum.
        if (t1.text != compCode) {
          Alert(

              type: AlertType.warning,
              context: context,
              title: "HATA!",
              desc: "Lütfen Geçerli Bir Onay Kodu Giriniz",
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




          Alert(
              type: AlertType.success,
              context: context,
              title: "Teşekkürler!",
              desc: "Bağışınız başarılı bir şekilde gerçekleşti!",
              buttons: [
                DialogButton(
                    child: Text(
                      "Kapat",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "/donatePage");
                    }),
              ]).show();
          FirebaseFirestore.instance
              .collection("products")
              .doc(uuid)
              .set({
            'productName': widget.productName1,
            'productPiece': widget.productPiece1,
            'companyName': widget.companyName,
            'id': uuid,

          });
        }

    });

    FirebaseFirestore.instance
        .collection("corpCode")
        .doc(widget.companyName)
        .get()
        .then((value) {
      setState(() {
        corporateId = value.data()['id'];
      });
    });

    //id ve kodu değişkene aktarıp kod denetimi yaptım ve yeni koleksiyon oluşturdum


  }
}
