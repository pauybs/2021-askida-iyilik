import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iyilikaskisiapp/Pages/donateDetail.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DonatePage extends StatefulWidget {
  final String title;
  DonatePage(this.title);

  @override
  donateScreen createState() => donateScreen();
}

// SAYFALARI ÇAĞIRMAK İÇİN KULLANILAN SINIF

class donateScreen extends State<DonatePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  Stream collectionStream =
      FirebaseFirestore.instance.collection('products').snapshots();
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');
  FirebaseAuth _auth = FirebaseAuth.instance;
  String companyName;
  String productName;
  String productPiece;
  String sendCompanyName;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
        isLoading: _isLoading,
        child: Scaffold(
            primary: true,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              actions: <Widget>[
                RaisedButton.icon(
                  label: Text(
                    "Çıkış Yap",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                  icon: Icon(
                    Icons.exit_to_app,
                    size: 32,
                    color: Colors.white,
                  ),
                  onPressed: _userCikis,
                )
              ],
              title: Text("Güncel Bağışlar"),
            ),
            body: Center(
              child: Container(
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/donate1.jpg"),
                      fit: BoxFit.none,
                    )),
                child: new Column(
                  children: [
                    Expanded(
                        flex: 3,
                        child: Container(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: products.snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text('Bir şeyler yanlış gitti!');
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text("Yükleniyor...");
                              }

                              return Center(
                                child: Scrollbar(
                                  child: ListView(
                                    padding: EdgeInsets.all(7),
                                    children: snapshot.data.docs
                                        .map((DocumentSnapshot document) {
                                      return Card(
                                        elevation: 5,
                                        child: InkWell(
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => Akureyri(
                                                      title: document
                                                          .data()['companyName'],
                                                      subtitle: document.data()[
                                                      'productName'],
                                                      productPiece: document
                                                          .data()[('productPiece')],
                                                        idd: document
                                                            .data()[('id')]))),
                                            splashColor: Colors.blue.withAlpha(30),
                                            child: ListTile(
                                              title: new Text(
                                                  document.data()['companyName']),
                                              subtitle: new Text(document
                                                  .data()[('productPiece')]+ " Adet  " +
                                                  document.data()['productName']),

                                              trailing:
                                              Icon(Icons.keyboard_arrow_right),
                                            )),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          ),
                        )),
                    new Container(
                      padding: EdgeInsets.fromLTRB(0, 30, 0, 40),
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: BorderSide(color: Colors.blue[500])),
                        color: Colors.blue[500],
                        textColor: Colors.white,
                        padding: EdgeInsets.all(20.0),
                        onPressed: () {
                          Navigator.pushNamed(context, "/makeDonateCorp");
                        },
                        child: Text(
                          "Bağış Yap".toUpperCase(),
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )

        ),
    );

  }

  void _userCikis() async {
    setState(() {
      _isLoading = true;
    });
    await _auth
        .signOut()
        .then((value) => Navigator.pushNamed(context, "/"))
        .catchError((onError) {
      Alert(
          type: AlertType.warning,
          context: context,
          title: "ÇIKIŞ YAPILAMADI!",
          buttons: [
            DialogButton(
              child: Text(
                "KAPAT",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              onPressed: () => Navigator.pop(context),
            )
          ]).show();
      setState(() {
        _isLoading = false;
      });
    });
  }
}
