

import 'package:abdelkader_user/constants/color.dart';
import 'package:abdelkader_user/models/worker.dart';
import 'package:abdelkader_user/screens/workerTransactions.dart';
import 'package:flutter/material.dart';

class Worker_card extends StatelessWidget {
  final Workerr data;

  Worker_card({this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ]),
        child: Card(
          //color: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          child: ListTile(

            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            trailing: Icon(Icons.chevron_right,color: primaryColor,size: 30,),
            leading: CircleAvatar(
              radius: 25.0,
              backgroundImage: AssetImage('assets/user.png'),
              backgroundColor: Colors.white,
            ),
            title: Text(
              data.name,
              style: TextStyle(fontSize: 20,color: primaryColor),
            ),

            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WorkerTransactions(uid: data.uid,)));
            },
          ),
        ),
      ),
    );
  }
}