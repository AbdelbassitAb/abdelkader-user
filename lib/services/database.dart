import 'package:abdelkader_user/models/chantier.dart';
import 'package:abdelkader_user/models/chefData.dart';
import 'package:abdelkader_user/models/transactions.dart';
import 'package:abdelkader_user/models/worker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DataBaseController extends GetxController {
  // static DataBaseController to = Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String uid;

  DataBaseController({this.uid});

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');
  final CollectionReference transactionsCollection =
      FirebaseFirestore.instance.collection('Transactions');
  final CollectionReference workersCollection =
      FirebaseFirestore.instance.collection('Workers');

  final CollectionReference chantiersCollection =
      FirebaseFirestore.instance.collection('Chantier');

/*  CollectionReference get collection {
    return usersCollection;
  }*/

  Future<void> updateUserData(String uid, String name, String email,
      String numTlf, double argent, bool deleted) async {
    return await usersCollection.doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'numTlf': numTlf,
      'argent': argent,
      'deleted': deleted,
    });
  }

  Future<void> updateWorkerData(
    String uid,
    String name,
  ) async {
    return await workersCollection.doc(uid).set({
      'uid': uid,
      'name': name,
    });
  }

  Future<void> updateChantier(
    String name,
  ) async {
    return await chantiersCollection.doc(name).set({
      'name': name,
    });
  }

  Future<void> updateUserTransaction(
      String uid,
      String name,
      String description,
      String time,
      double argent,
      double somme,
      Workerr worker,
      bool deleted,
      String type,
      String chantier) async {
    await transactionsCollection
        .doc('All transactions')
        .collection('Transactions')
        .doc(uid)
        .set({
      'uid': uid,
      'name': name,
      'description': description,
      'time': time,
      'argent': argent,
      'somme': somme,
      'type': type,
      'chantier': chantier,
      'workerName': worker.name,
      'workerId': worker.uid,
      'deleted': deleted,
    });
  }

/*  Future<void> addTransaction(String uid, String name, String description,
      String time, double argent, double somme, bool deleted) async {
    return await usersCollection.doc(uid).collection('Transactions').add({
      'uid': uid,
      'name': name,
      'description': description,
      'time': time,
      'argent': argent,
      'somme': somme,
      'deleted': deleted,
    });
  }*/

  List<ChefData> _chefListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return ChefData.fromMap(doc.data());
    }).toList();
  }

  ChefData _chefFromSnapshot(DocumentSnapshot snapshot) {
    return ChefData.fromMap(snapshot.data());
  }

  List<Chantier> _chantiersListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Chantier.fromMap(doc.data());
    }).toList();
  }

  List<Workerr> _workerListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Workerr.fromMap(doc.data());
    }).toList();
  }

  List<TR> _transactionsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return TR.fromMap(doc.data());
    }).toList();
  }

  Stream<List<ChefData>> get chefs {
    return usersCollection.snapshots().map(_chefListFromSnapshot);
  }

  Stream<ChefData> get chefData {
    return usersCollection.doc(uid).snapshots().map(_chefFromSnapshot);
  }

  Stream<List<Chantier>> get chantiers {
    return chantiersCollection.snapshots().map(_chantiersListFromSnapshot);
  }

  Stream<List<Workerr>> get workers {
    return workersCollection.snapshots().map(_workerListFromSnapshot);
  }

  Stream<List<TR>> get allTransactions {
    return transactionsCollection
        .doc('All transactions')
        .collection('Transactions')
        .snapshots()
        .map(_transactionsListFromSnapshot);
  }

/*  Stream<List<TR>> transactionsOf(String type) {
    return transactionsCollection
        .doc(type)
        .collection('Transactions')
        .snapshots()
        .map(_transactionsListFromSnapshot);
  }*/

  /* Stream<List<TR>> chantier(String name) {
    return chantiersCollection
        .doc(name)
        .collection('Transactions')
        .snapshots()
        .map(_transactionsListFromSnapshot);
  }*/

  /* Stream<List<TR>> get transactions {
    return usersCollection
        .doc(uid)
        .collection('Transactions')
        .snapshots()
        .map(_transactionsListFromSnapshot);
  }*/

  Stream<List<TR>> transactionQuery(String fieldName, String data) {
    return transactionsCollection
        .doc('All transactions')
        .collection('Transactions')
        .where(fieldName, isEqualTo: data)
        .snapshots()
        .map(_transactionsListFromSnapshot);
  }

  /* Stream<List<TR>> get workerTransactions {
    return workersCollection
        .doc(uid)
        .collection('Transactions')
        .snapshots()
        .map(_transactionsListFromSnapshot);
  }*/

  Future<void> deleteChef(String id) {
    return usersCollection.doc(id).delete();
  }

  Future<void> deleteTransaction(String id) {
    return transactionsCollection
        .doc('All transactions')
        .collection('Transactions')
        .doc(id)
        .delete();
  }
}

class FireStorageService extends ChangeNotifier {
  FireStorageService();

  static Future<dynamic> loadFromStorage(
      BuildContext context, String image) async {
    return await FirebaseStorage.instance.ref().child(image).getDownloadURL();
  }
}
