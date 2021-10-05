import 'package:abdelkader_user/components/showDialogueMethode.dart';
import 'package:abdelkader_user/components/transactionCard.dart';
import 'package:abdelkader_user/constants/color.dart';
import 'package:abdelkader_user/controlers/controler.dart';
import 'package:abdelkader_user/models/chefData.dart';
import 'package:abdelkader_user/models/transactions.dart';
import 'package:abdelkader_user/services/authentication.dart';
import 'package:abdelkader_user/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final UserController userController = Get.put(UserController());
  final AuthService _auth = AuthService();

  String uid;

  void getData() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    uid = user.uid;
  }

  @override
  void initState() {
    getData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ChefData>(
        stream: DataBaseController(uid: uid).chefData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ChefData chefData = ChefData(
              uid: snapshot.data.uid,
              name: snapshot.data.name,
              deleted: snapshot.data.deleted,
              numTlf: snapshot.data.numTlf,
              argent: snapshot.data.argent,
              email: snapshot.data.email,
            );
            if (!snapshot.data.deleted) {
              return Scaffold(
                  appBar: AppBar(
                    backgroundColor: primaryColor,
                    title: Text(snapshot.data.name ?? ''),
                    actions: <Widget>[
                      FlatButton.icon(
                        icon: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Déconnecter',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          await _auth.signOut();
                        },
                      ),
                    ],
                  ),
                  body: StreamBuilder<List<TR>>(
                      stream: DataBaseController(uid: uid)
                          .transactionQuery('name', snapshot.data.name),
                      builder: (context, snapshot2) {
                        if (snapshot.hasData) {
                          if (snapshot2.data != null) {
                            if (snapshot2.data.length != 0) {
                              snapshot2.data.sort((a, b) {
                                return b.time.compareTo(a.time);
                              });
                              return Stack(children: [
                                ListView.builder(
                                    itemCount: snapshot2.data.length,
                                    itemBuilder: (context, index) {
                                      return Transaction_Card(
                                          data: snapshot2.data[index]);
                                    }),
                                Positioned(
                                    right: 20,
                                    bottom: 20,
                                    child: FloatingActionButton(
                                      backgroundColor: primaryColor,
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                      onPressed: () async {
                                        await showModalBottomSheet<dynamic>(
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            context: context,
                                            builder: (context) {
                                              return Container(
                                                decoration: new BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: new BorderRadius
                                                            .only(
                                                        topLeft: const Radius
                                                            .circular(25.0),
                                                        topRight: const Radius
                                                            .circular(25.0))),
                                                child: Wrap(children: [
                                                  AddTransaction(
                                                    transaction: TR(
                                                        somme: 0,
                                                        argent: snapshot
                                                            .data.argent),
                                                    context: context,
                                                    chefData: chefData,
                                                  )
                                                ]),
                                              );
                                            });

                                        /* showMyDialog(
              TR(somme: 0, argent: this.widget.money), context, chefData);*/
                                      },
                                    ))
                              ]);
                            } else {
                              return Stack(children: [
                                Center(
                                  child: Text('Pas de transaction trouvée'),
                                ),
                                Positioned(
                                    right: 20,
                                    bottom: 20,
                                    child: FloatingActionButton(
                                      backgroundColor: primaryColor,
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                      onPressed: () async {
                                        await showModalBottomSheet<dynamic>(
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            context: context,
                                            builder: (context) {
                                              return Container(
                                                decoration: new BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: new BorderRadius
                                                            .only(
                                                        topLeft: const Radius
                                                            .circular(25.0),
                                                        topRight: const Radius
                                                            .circular(25.0))),
                                                child: Wrap(children: [
                                                  AddTransaction(
                                                    transaction: TR(
                                                        somme: 0,
                                                        argent: snapshot
                                                            .data.argent),
                                                    context: context,
                                                    chefData: chefData,
                                                  )
                                                ]),
                                              );
                                            });

                                        /* showMyDialog(
              TR(somme: 0, argent: this.widget.money), context, chefData);*/
                                      },
                                    ))
                              ]);
                            }
                          } else {
                            return Center(
                              child: Text('Pas de transaction trouvée'),
                            );
                          }
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }));
            } else {
              return Scaffold(
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/error404.svg', height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.4,),
                        SizedBox(height: 15,),
                        Text('Ce compte est desactivé',style: TextStyle(
                          color: Colors.red,fontSize: 22
                        ),),
                        SizedBox(height: 15,),
                        ElevatedButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  primaryColor),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ))),
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.5,
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: Text(
                              'Déconnecter',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          onPressed: () async {
                            await _auth.signOut();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          } else {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
        });
  }
}
