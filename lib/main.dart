// ignore_for_file: avoid_print

import './models/transaction.dart';
import './widgets/addTransaction.dart';
import './widgets/transactionList.dart';
import './widgets/chart.dart';
import 'package:flutter/material.dart';

void main() => runApp(const Index());

class Index extends StatelessWidget {
  const Index({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Planner',
      home: const HomePage(),
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Poppins',
        textTheme: ThemeData.light().textTheme.copyWith(
              titleLarge:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              titleMedium:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              titleSmall:
                  const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
            ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Transaction> _userTransactions = [];

  void _addTransaction(String title, num amount, DateTime chosedDate) {
    final Transaction newTx = Transaction(
      id: 'tx:${_userTransactions.length.toString()}',
      title: title,
      amount: amount,
      date: chosedDate,
    );
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  void _showTransactionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor,
                  blurRadius: 10,
                  spreadRadius: 0,
                  blurStyle: BlurStyle.normal,
                  offset: Offset.zero,
                )
              ],
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              color: Theme.of(context).scaffoldBackgroundColor),
          child: Column(
            children: [
              Container(
                  width: 100,
                  height: 10,
                  decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              AddTransaction(_addTransaction),
            ],
          ),
        );
      },
    );
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where(
      (element) {
        return element.date.isAfter(
          DateTime.now().subtract(
            const Duration(days: 7),
          ),
        );
      },
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Planner'),
        actions: [
          IconButton(
              onPressed: () => _showTransactionSheet(context),
              icon: const Icon(Icons.add))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Chart(_recentTransactions),
          TransactionList(_userTransactions, _deleteTransaction)
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTransactionSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
