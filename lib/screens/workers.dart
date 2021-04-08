
import 'package:abdelkader_user/models/models.dart';
import 'package:abdelkader_user/screens/constant.dart';
import 'package:abdelkader_user/services/database.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Workers extends StatefulWidget {
  @override
  _WorkersState createState() => _WorkersState();
}

class _WorkersState extends State<Workers> {


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('Travailleurs'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Workerr>>(
          stream: DatabaseService().workers,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? Stack(
              children: <Widget>[
                snapshot.data.length==0 ? Center(child: Text('Pas de travailleur trouvé'),) :
                ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Worker_card(data: snapshot.data[index]);
                  },
                ),

              ],
            )
                : Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
