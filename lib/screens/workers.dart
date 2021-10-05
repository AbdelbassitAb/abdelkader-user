import 'package:abdelkader_user/components/workerCard.dart';
import 'package:abdelkader_user/constants/color.dart';
import 'package:abdelkader_user/controlers/controler.dart';
import 'package:abdelkader_user/controlers/transactionControler.dart';
import 'package:abdelkader_user/models/chef.dart';
import 'package:abdelkader_user/models/chefData.dart';
import 'package:abdelkader_user/models/worker.dart';
import 'package:abdelkader_user/services/authentication.dart';
import 'package:abdelkader_user/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class Workers extends StatefulWidget {
  @override
  _WorkersState createState() => _WorkersState();
}

class _WorkersState extends State<Workers> {
  final TransactionsController transactionsController =
      Get.put(TransactionsController());

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
    return Scaffold(
      // backgroundColor: secondaryColor,

      appBar: AppBar(
        title: Text('Travailleurs'),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: StreamBuilder<ChefData>(
          stream: DataBaseController(uid: uid).chefData,
          builder: (context, snapshot) {
            if(snapshot.hasData){
              if(!snapshot.data.deleted){
                return StreamBuilder<List<Workerr>>(
                    stream: DataBaseController().workers,
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? snapshot.data.length == 0
                          ? Center(
                        child: Text('Pas de travailleur trouvé'),
                      )
                          : ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Worker_card(data: snapshot.data[index]);
                        },
                      )
                          : Center(
                        child: CircularProgressIndicator(),
                      );
                    });
              }else {
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
                );;
              }
            }else {
              return Center(child: CircularProgressIndicator());
            }

          }),
    );
  }
}
