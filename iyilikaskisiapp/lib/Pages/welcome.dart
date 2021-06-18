import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

class WelcomeUser extends StatefulWidget {
  final String title;
  WelcomeUser(this.title);

  @override
  _WelcomeUser createState() => _WelcomeUser();
}

class _WelcomeUser extends State<WelcomeUser> {
  var formKey = GlobalKey<FormState>();

  FirebaseAuth _auth = FirebaseAuth.instance;

  String email;
  String password;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          padding: EdgeInsets.all(20.0),
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/welcomeEkran.jpg"),
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
                      Row(

                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/loginUser");
                            },
                            color: Colors.blue[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 100),
                            hoverColor: Colors.black,
                            child: Text(
                              "Bireysel",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 24),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, "/corporateLoginUser");
                            },
                            color: Colors.blue[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 93),
                            hoverColor: Colors.black,
                            child: Text(
                              "Kurumsal",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 24),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
