import 'package:abdelkader_user/controlers/controler.dart';
import 'package:abdelkader_user/models/models.dart';
import 'package:abdelkader_user/screens/home.dart';
import 'package:abdelkader_user/screens/log_in.dart';
import 'package:abdelkader_user/screens/switchPage.dart';
import 'package:abdelkader_user/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Wrapper extends StatefulWidget {


  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
        stream: AuthService().user,
        builder: (context, snapshot) {
          if (snapshot.data == null) {

            return LogIn();
          } else {




            return SwitchPage();
          }
        });
  }
}
