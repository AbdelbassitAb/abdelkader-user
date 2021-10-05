

import 'package:abdelkader_user/components/transactionCard.dart';
import 'package:abdelkader_user/models/transactions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionsList extends StatefulWidget {
  @override
  _TransactionsListState createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  @override
  Widget build(BuildContext context) {
    final transactionsList = Provider.of<List<TR>>(context) ?? [];
    return ListView.builder(
      itemCount: transactionsList.length,
      itemBuilder: (context, index) {

        return Transaction_Card(data: transactionsList[index]);
      },
    );
  }
}