
import 'package:abdelkader_user/models/models.dart';
import 'package:abdelkader_user/screens/workerTransactions.dart';
import 'package:abdelkader_user/services/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

const textinputDecoration = InputDecoration(
    contentPadding: EdgeInsets.all(4.0),
    fillColor: Colors.white,
    filled: true,
    hintStyle: TextStyle(
      color: Colors.black,
    ),
    prefixIcon: Icon(
      Icons.attach_money,
      color: Colors.blue,
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
        width: 2.0,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
        width: 2.0,
      ),
    ));

class Transaction_Card extends StatelessWidget {
  final TR data;

  Transaction_Card({this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [


              data.workerId != null ?

              Text(
                '${data.name} a payé ${data.workerName}',
                style: TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.bold),
              ) : SizedBox(),

              SizedBox(
                height: 5,
              ),

              Text(
                data.description,
                overflow: TextOverflow.ellipsis,
                maxLines: 20,
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),


              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text( double.parse(data.somme.toString()).toInt().toString() + ' Da',style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(
                      data.time,
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionsController extends GetxController {
  var description = ''.obs;
  var somme = '0'.obs;
  var currentMoney = 0.obs;
  var loading = false.obs;

  var checkBoxValue = false.obs;
  var selectedWorker = Workerr(name: 'unselected');
  TextEditingController descriptionTextfield = TextEditingController();
  TextEditingController sommeTextfield = TextEditingController();
}

Future<void> showMyDialog(
    TR transaction, BuildContext context, ChefData chefData) async {
  final _formKey1 = GlobalKey<FormState>();

  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
  final TransactionsController transactionsController =
  Get.put(TransactionsController());

  var uuid = Uuid();
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      transactionsController.currentMoney(transaction.argent.toInt());
      transactionsController.descriptionTextfield.text =
          transaction.description ?? '';
      transactionsController.sommeTextfield.text =
          transaction.somme.toInt().toString() ?? 0.toString();
      return AlertDialog(
        title: Text('Ajouter une transaction'),
        content:
        GetX<TransactionsController>(builder: (transactionsController) {
          return SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                transactionsController.loading.value ? Center(child: CircularProgressIndicator())  :   Form(
                  key: _formKey1,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: transactionsController.descriptionTextfield,
                        decoration: textinputDecoration.copyWith(
                          hintText: 'descripton',
                          prefixIcon: Icon(
                            Icons.description,
                            color: Colors.blue,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (val) =>
                        val.isEmpty ? 'Entrer une description svp' : null,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: transactionsController.sommeTextfield,
                        keyboardType: TextInputType.number,
                        decoration: textinputDecoration.copyWith(
                          hintText: '0',
                          prefixIcon: Icon(
                            Icons.attach_money,
                            color: Colors.blue,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (val) =>
                        val.isEmpty && val.length==1 ? 'Entrer un numero svp' : null,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text('Payer un travailleur'),
                          Checkbox(
                              value: transactionsController.checkBoxValue.value,
                              activeColor: Colors.green,
                              onChanged: (bool newValue) {
                                transactionsController.checkBoxValue(newValue);
                                print(transactionsController.checkBoxValue.value);
                              }),
                        ],
                      ),
                      transactionsController.checkBoxValue.value ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Selectionner un travailleur:'),
                          SizedBox(height: 5,),
                          StreamBuilder<List<Workerr>>(
                              stream: DatabaseService().workers,
                              builder: (context, snapshot) {
                                if(snapshot.hasData)
                                {



                                  List<Workerr> list = snapshot.data;
                                  transactionsController.selectedWorker.name = '';

                                  transactionsController.selectedWorker.uid = null;




                                  list.add(transactionsController.selectedWorker);
                                  return  DropdownButtonFormField(
                                    value: transaction.workerId != null ? transaction.workerName : transactionsController.selectedWorker.name ,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(4.0),
                                      fillColor: Colors.white,
                                      filled: true,
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: Colors.blue,
                                      ),
                                      hintStyle: TextStyle(
                                        color: Colors.black,
                                      ),

                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    items: snapshot.data.map((worker) {
                                      return DropdownMenuItem(
                                        value: worker.name,
                                        child: Text(
                                          worker.name,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      print(val);

                                      for(int i=0;i<list.length;i++)
                                      {
                                        if(list[i].name==val)
                                        {

                                          print('true');
                                          transactionsController.selectedWorker.name = val;
                                          transactionsController.selectedWorker.uid = list[i].uid;
                                        }
                                      }


                                    },
                                  );


                                }else
                                {
                                  return SizedBox();
                                }

                              }),
                        ],
                      ) : SizedBox()
                    ],
                  ),
                )
              ],
            ),
          );
        }),
        actions: <Widget>[
          RaisedButton(
              color: Colors.green,
              child:
              transaction.uid == null ? Text('Ajouter') : Text('Modifier'),
              onPressed: () async {

                if (_formKey1.currentState.validate()) {
                  transactionsController.loading(true);
                  transactionsController.currentMoney((double.parse(
                      transactionsController.sommeTextfield.text) +
                      transactionsController.currentMoney.value -
                      transaction.somme)
                      .toInt());

                  await DatabaseService(uid: chefData.uid).updateUserData(
                      chefData.uid,
                      chefData.name,
                      chefData.email,
                      chefData.numTlf,
                      transactionsController.currentMoney.value.toDouble() ??
                          chefData.argent,
                      chefData.deleted);


                  if(transaction.workerName != transactionsController.selectedWorker.name)
                  {
                    await DatabaseService(uid: transaction.workerId)
                        .deleteWorkersTransaction(transaction.uid);
                  }


                  await DatabaseService(uid: chefData.uid)
                      .updateUserTransaction(
                    transaction.uid == null ? uuid.v4() : transaction.uid,
                    chefData.name,
                    transactionsController.descriptionTextfield.text,
                    dateFormat.format(DateTime.now()),
                    transactionsController.currentMoney.value.toDouble() ??
                        chefData.argent,
                    double.parse(transactionsController.sommeTextfield.text),
                    transactionsController.selectedWorker,
                    chefData.deleted,
                  );





                  transactionsController.sommeTextfield.text = '0';
                  transactionsController.descriptionTextfield.text = '';
                  transactionsController.selectedWorker.name = '';
                  transactionsController.selectedWorker.uid = null;
                  transactionsController.loading(false);
                  Get.back();
                }
              }),
          transaction.uid != null
              ? RaisedButton(
              color: Colors.red,
              child: Text('Suprimer'),
              onPressed: () async {
                await DatabaseService(uid: chefData.uid)
                    .deleteTransaction(transaction.uid);
                await DatabaseService(uid: transaction.workerId)
                    .deleteWorkersTransaction(transaction.uid);
                Navigator.of(context).pop();
              })
              : SizedBox(),
        ],
      );
    },
  );
}


class Worker_card extends StatelessWidget {
  final Workerr data;

  Worker_card({this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          trailing: Icon(Icons.chevron_right),
          leading: CircleAvatar(
            radius: 25.0,
            backgroundImage: AssetImage('assets/61205.png'),
            backgroundColor: Colors.white,
          ),
          title: Text(
            data.name,
          ),
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WorkerTransactions(uid: data.uid,)));
          },
        ),
      ),
    );
  }
}
