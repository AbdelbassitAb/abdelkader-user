import 'package:abdelkader_user/controlers/controler.dart';
import 'package:abdelkader_user/models/models.dart';
import 'package:abdelkader_user/screens/constant.dart';
import 'package:abdelkader_user/services/authentication.dart';
import 'package:abdelkader_user/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
        stream: DatabaseService(uid: uid).userData,
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

            return Scaffold(
                appBar: AppBar(
                  title: Text(snapshot.data.name ?? ''),
                  centerTitle: true,
                  actions: <Widget>[
                    FlatButton.icon(
                      icon: Icon(Icons.person),
                      label: Text('Déconnecter'),
                      onPressed: () async {
                        await _auth.signOut();
                      },
                    ),
                  ],
                ),
                body: StreamBuilder<List<TR>>(
                    stream: DatabaseService(uid: uid).transactions,
                    builder: (context, snapshot2) {
                      if (snapshot.hasData) {
                        if (snapshot2.data != null) {
                          if (snapshot2.data.length != 0) {

                            snapshot2.data.sort((a,b) {
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
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      showMyDialog(
                                          TR(
                                              somme: 0,
                                              argent: snapshot.data.argent),
                                          context,
                                          chefData);
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
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      showMyDialog(
                                          TR(
                                              somme: 0,
                                              argent: snapshot.data.argent),
                                          context,
                                          chefData);
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
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
        });
  }
}
