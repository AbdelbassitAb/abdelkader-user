
import 'package:abdelkader_user/constants/color.dart';
import 'package:abdelkader_user/controlers/transactionControler.dart';
import 'package:abdelkader_user/models/chantier.dart';
import 'package:abdelkader_user/models/chefData.dart';
import 'package:abdelkader_user/models/transactions.dart';
import 'package:abdelkader_user/models/worker.dart';
import 'package:abdelkader_user/services/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

import 'inputDecoration.dart';

class DescriptionTextField extends StatelessWidget {
  final TransactionsController transactionsController;

  DescriptionTextField(this.transactionsController);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: transactionsController.descriptionTextfield,
      decoration: textinputDecoration.copyWith(
          labelText: 'Description',
          prefixIcon: Icon(
            Icons.textsms_outlined,
            color: primaryColor,
          )),
      validator: (val) => val.isEmpty ? 'Entrer une description svp' : null,
      onChanged: (val) {
        print(transactionsController.chantier.value);
      },
    );
  }
}

class MoneyTextField extends StatelessWidget {
  final TransactionsController transactionsController;

  MoneyTextField(this.transactionsController);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: transactionsController.sommeTextfield,
      keyboardType: TextInputType.number,
      decoration: textinputDecoration.copyWith(
        labelText: 'somme',
      ),
      validator: (val) => val.isEmpty ? 'entrer une somme svp' : null,
    );
  }
}



class WorkersDropDownField extends StatelessWidget {
  final TR transaction;
  final TransactionsController transactionsController;
  final AsyncSnapshot<List<Workerr>> snapshot;
  final List<Workerr> list;
  Function onChanged;

  WorkersDropDownField(this.transaction, this.transactionsController,
      this.snapshot, this.list, this.onChanged);

  @override
  Widget build(BuildContext context) {

    bool exist = false;
    for(Workerr element in snapshot.data){
      if(element.name == ''){
        exist = true;
      }
    }
    if(exist == false){
      snapshot.data.add(Workerr(name: '',uid: ''));
    }




    return DropdownButtonFormField(
      value: transactionsController.workerName.value != ''
          ? transactionsController.workerName.value
          : ''/*snapshot.data[0].name*/,
      decoration: textinputDecoration.copyWith(
        prefixIcon: Icon(
          Icons.groups,
          color: primaryColor,
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
      onChanged: onChanged,
    );
  }
}

class TypeDropDownField extends StatelessWidget {
  final TransactionsController transactionsController;
  final List<String> list;
  final TR transaction;

  TypeDropDownField(
    this.list,
    this.transactionsController,
    this.transaction,
  );

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: transaction.type != null ? transaction.type : list[0],
      decoration: textinputDecoration.copyWith(
        prefixIcon: Icon(
          Icons.list,
          color: primaryColor,
        ),
      ),
      items: list.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type),
        );
      }).toList(),
      onChanged: (val) {
        transactionsController.type(val);
      },
    );
  }
}

class ChantierDropDownField extends StatelessWidget {
  final TransactionsController transactionsController;
  final List<Chantier> list;
  final TR transaction;

  ChantierDropDownField(
      this.list, this.transactionsController, this.transaction,);

  @override
  Widget build(BuildContext context) {

    bool exist = false;
    for(Chantier element in list){
      if(element.name == ''){
        exist = true;
      }
    }
    if(exist == false){
      list.add(Chantier(name: ''));
    }

  /*  transactionsController.chantier(
        transaction.chantier != null &&
            transaction.chantier != ''
            ? transaction.chantier
            : list[0].name);*/



    return DropdownButtonFormField(
      value: transactionsController.chantier.value != '' ? transactionsController.chantier.value : '',
      decoration: textinputDecoration.copyWith(
        prefixIcon: Icon(
          Icons.place_outlined,
          color: primaryColor,
        ),
      ),
      items: list.map((chantier) {
        return DropdownMenuItem(
          value: chantier.name,
          child: Text(chantier.name),
        );
      }).toList(),
      onChanged:(val) {
        transactionsController.chantier(val);
        print(transactionsController.chantier.value);
      },
    );
  }
}

class AddEditButton extends StatelessWidget {
  final TR transaction;
  final TransactionsController transactionsController;
  final ChefData chefData;
  final GlobalKey<FormState> _formKey1;
  final DateFormat dateFormat;
  final Uuid uuid;

  AddEditButton(this.transaction, this.transactionsController, this.chefData,
      this._formKey1, this.dateFormat, this.uuid);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ))),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            transaction.uid == null ? 'Ajouter' : 'Modifier',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        onPressed: () async {
          if (_formKey1.currentState.validate()) {
            transactionsController.loading(true);
            transactionsController.currentMoney(
                (-double.parse(transactionsController.sommeTextfield.text) +
                        transactionsController.currentMoney.value -
                        transaction.somme)
                    .toInt());



            await DataBaseController(uid: chefData.uid).updateUserData(
                chefData.uid,
                chefData.name,
                chefData.email,
                chefData.numTlf,
                transactionsController.currentMoney.value.toDouble() ??
                    chefData.argent,
                chefData.deleted);

            print(transactionsController.chantier.value);

            await DataBaseController(uid: chefData.uid).updateUserTransaction(
                transaction.uid == null ? uuid.v4() : transaction.uid,
                chefData.name,
                transactionsController.descriptionTextfield.text,
                dateFormat.format(DateTime.now()),
                transactionsController.currentMoney.value.toDouble() ??
                    chefData.argent,
                -double.parse(transactionsController.sommeTextfield.text),
                transactionsController.selectedWorker,
                chefData.deleted,
                transactionsController.type.value,
                transactionsController.chantier.value);

            transactionsController.chantier('');
            transactionsController.type('');
            transactionsController.sommeTextfield.text = '0';
            transactionsController.descriptionTextfield.text = '';
            transactionsController.selectedWorker.name = '';
            transactionsController.selectedWorker.uid = null;
            transactionsController.loading(false);
            Get.back();
          }
        });
  }
}

class DeleteButton extends StatelessWidget {
  final TransactionsController transactionsController;
  final ChefData chefData;
  final TR transaction;

  DeleteButton(this.transactionsController, this.chefData, this.transaction);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ))),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            'Supprimer',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        onPressed: () async {
          transactionsController.loading(true);
          await DataBaseController(uid: chefData.uid).updateUserData(
              chefData.uid,
              chefData.name,
              chefData.email,
              chefData.numTlf,
              chefData.argent - transaction.somme,
              chefData.deleted);
          await DataBaseController(uid: chefData.uid)
              .deleteTransaction(transaction.uid);

          transactionsController.loading(false);
          Get.back();
          //    Navigator.of(context).pop();
        });
  }
}

String title(TR transaction) {
  if (transaction.name == '') {
    return 'Supprimer la transaction';
  } else {
    return 'Ajouter une transaction';
  }
}

void affectDropDownValueToTransactionController(
    TransactionsController transactionsController,
    List<Workerr> list,
    dynamic val) {
  for (int i = 0; i < list.length; i++) {
    if (list[i].name == val) {
      transactionsController.selectedWorker.name = val;
      transactionsController.selectedWorker.uid = list[i].uid;
    }
  }
}

class AddTransaction extends StatefulWidget {
  AddTransaction({this.transaction, this.context, this.chefData});

  TR transaction;
  BuildContext context;
  ChefData chefData;

  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final _formKey1 = GlobalKey<FormState>();

  final List<String> typeList = [
    '',
    'Achat materiaux',
    'Gaz',
    'Nouriture',
    'Payement'
  ];

  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
  final TransactionsController transactionsController =
      Get.put(TransactionsController());

  var uuid = Uuid();

  @override
  void initState() {
    transactionsController.init(this.widget.transaction, typeList[0]);
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return GetX<TransactionsController>(builder: (transactionsController) {
      return SingleChildScrollView(
        child: Form(
          key: _formKey1,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ajouter/Modifier la transaction:',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
                SizedBox(
                  height: 15,
                ),
                DescriptionTextField(transactionsController),
                SizedBox(
                  height: 15,
                ),
                MoneyTextField(transactionsController),
                SizedBox(
                  height: 15,
                ),
                StreamBuilder<List<Chantier>>(
                    stream: DataBaseController().chantiers,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Chantier> chantierList;
                        chantierList = snapshot.data;
                       /* transactionsController.chantier(
                            this.widget.transaction.chantier != null &&
                                    this.widget.transaction.chantier != ''
                                ? this.widget.transaction.chantier
                                : chantierList[0].name);*/

                        /*   transactionsController.chantier(
                                  this.widget.transaction.chantier ??
                                      chantierList[0].name);*/

                        transactionsController.firstChantier(chantierList[0].name);

                        return ChantierDropDownField(
                          chantierList,
                          transactionsController,
                          this.widget.transaction,

                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    }),
                SizedBox(
                  height: 15,
                ),
                TypeDropDownField(
                    typeList, transactionsController, this.widget.transaction),
                SizedBox(
                  height: 15,
                ),


                transactionsController.type.value == 'Payement'
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selectionner un travailleur',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          StreamBuilder<List<Workerr>>(
                              stream: DataBaseController().workers,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List<Workerr> list = snapshot.data;

                                  return WorkersDropDownField(
                                    this.widget.transaction,
                                    transactionsController,
                                    snapshot,
                                    list,
                                    (val) {
                                      affectDropDownValueToTransactionController(
                                          transactionsController, list, val);
                                    },
                                  );
                                } else {
                                  return SizedBox();
                                }
                              }),
                        ],
                      )
                    : SizedBox(),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    this.widget.transaction.name == ''
                        ? SizedBox()
                        : AddEditButton(
                            this.widget.transaction,
                            transactionsController,
                            this.widget.chefData,
                            _formKey1,
                            dateFormat,
                            uuid),
                    SizedBox(
                      width: 20,
                    ),
                    this.widget.transaction.uid != null
                        ? transactionsController.loading.value
                            ? SizedBox()
                            : DeleteButton(transactionsController,
                                this.widget.chefData, this.widget.transaction)
                        : SizedBox(),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
