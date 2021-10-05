import 'package:abdelkader_user/constants/color.dart';
import 'package:abdelkader_user/models/chef.dart';
import 'package:abdelkader_user/models/chefData.dart';
import 'package:abdelkader_user/screens/log_in.dart';
import 'package:abdelkader_user/screens/switchPage.dart';
import 'package:abdelkader_user/services/authentication.dart';
import 'package:abdelkader_user/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Chef>(
        stream: AuthService().user,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return LogIn();
          } else {
            return StreamBuilder<ChefData>(
                stream:  DataBaseController(uid: snapshot.data.uid).chefData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (!snapshot.data.deleted) {
                      return SwitchPage();
                    } else {
                      return Scaffold(
                        body: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/error404.svg', height: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.4,),
                                SizedBox(height: 15,),
                                Text(
                                  'Ce compte est desactivé', style: TextStyle(
                                    color: Colors.red, fontSize: 22
                                ),),
                                SizedBox(height: 15,),
                                ElevatedButton(
                                  style: ButtonStyle(
                                      foregroundColor: MaterialStateProperty
                                          .all<Color>(
                                          Colors.white),
                                      backgroundColor: MaterialStateProperty
                                          .all<Color>(
                                          primaryColor),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                10),
                                          ))),
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.5,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Text(
                                      'Déconnecter',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                  onPressed: () async {
                                    await AuthService().signOut();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }
            );
          }
        });
  }
}
