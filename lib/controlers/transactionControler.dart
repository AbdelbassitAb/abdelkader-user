import 'package:abdelkader_user/models/transactions.dart';
import 'package:abdelkader_user/models/worker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionsController extends GetxController {
  var description = ''.obs;
  var somme = '0'.obs;
  var type = ''.obs;
  var chantier = ''.obs;
  var workerName = ''.obs;
  var workerId = ''.obs;
  var firstChantier = ''.obs;
  var currentMoney = 0.obs;
  var loading = false.obs;

  var checkBoxValue = false.obs;
  var selectedWorker = Workerr(name: '', uid: null);
  TextEditingController descriptionTextfield = TextEditingController();
  TextEditingController sommeTextfield = TextEditingController();

  void init(TR transaction, String typee) {
    currentMoney(transaction.argent.toInt());
    descriptionTextfield.text = transaction.description ?? '';
    type(transaction.type ?? typee);
    chantier(transaction.chantier ?? '');

    selectedWorker.name = transaction.workerName ?? '';
    selectedWorker.uid = transaction.uid ?? '';
    workerName(transaction.workerName ?? '');
    workerId(transaction.workerId ?? '');

    sommeTextfield.text = transaction.somme != 0
        ? transaction.somme.toInt().toString()
        : ''.toString();
  }
}
