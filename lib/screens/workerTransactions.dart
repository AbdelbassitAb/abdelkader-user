
import 'package:abdelkader_user/models/models.dart';
import 'package:abdelkader_user/screens/constant.dart';
import 'package:abdelkader_user/services/database.dart';
import 'package:flutter/material.dart';

class WorkerTransactions extends StatefulWidget {
  final String uid;

  WorkerTransactions({this.uid});

  @override
  _WorkerTransactionsState createState() => _WorkerTransactionsState();
}

class _WorkerTransactionsState extends State<WorkerTransactions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('Transactions'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Stack(
          children: [
            StreamBuilder<List<TR>>(
                stream:
                DatabaseService(uid: this.widget.uid).workerTransactions,
                builder: (context, snapshot) {
                  return




                    snapshot.hasData
                      ? snapshot.data.length != 0
                      ? ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Transaction_Card(
                          data: snapshot.data[index]);
                    },
                  )
                      : Center(
                    child: Text('Pas de transaction trouvée'),
                  )
                      : Center(child: CircularProgressIndicator());
                })
          ],
        ));
  }
}
