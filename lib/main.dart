// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import './models/transaction.dart';
import './widgets/addTransaction.dart';
import './widgets/transactionList.dart';
import './widgets/chart.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp
  ]);
  runApp(const Index());
}

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
  bool _showChart = true;

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

  void _showAddTransactionSheet(BuildContext context) {
    final modalContent = AddTransaction(_addTransaction);
    showModalBottomSheet(
      context: context,
      elevation: 25,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      builder: (ctx) {
        final mediaQuery = MediaQuery.of(ctx);
        return Padding(
          padding: EdgeInsets.only(
              top: 12,
              bottom: mediaQuery.viewInsets.bottom,
              left: 12,
              right: 12),
          child: SizedBox(
            height: 350,
            child: Column(
              children: [
                Container(
                    width: 100,
                    height: 10,
                    decoration: const BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                modalContent,
              ],
            ),
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
    final isLandscapeMode =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Expense Planner',
                style: Theme.of(context).textTheme.titleLarge),
            trailing: GestureDetector(
              onTap: () => _showAddTransactionSheet(context),
              child: const Icon(CupertinoIcons.add),
            ),
          ) as PreferredSizeWidget
        : AppBar(
            title: Text('Expense Planner',
                style: Theme.of(context).textTheme.titleLarge),
            actions: [
              IconButton(
                  onPressed: () => _showAddTransactionSheet(context),
                  icon: const Icon(Icons.add))
            ],
          );
    final availableSpace = (MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top);
    final txListWidget = Container(
      alignment: Alignment.center,
      height: _showChart && isLandscapeMode ? 0 : availableSpace * 0.5,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );
    final txChartWidget = SizedBox(
      height: isLandscapeMode ? availableSpace * 0.75 : availableSpace * 0.3,
      child: Chart(_recentTransactions),
    );
    final appBody = SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isLandscapeMode)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Show Chart',
                    style: Theme.of(context).textTheme.titleMedium),
                Switch.adaptive(
                  activeColor: Theme.of(context).primaryColorLight,
                  value: _showChart,
                  onChanged: (val) => setState(
                    () {
                      _showChart = val;
                    },
                  ),
                ),
              ],
            ),
          if (!isLandscapeMode) txChartWidget,
          if (!isLandscapeMode) txListWidget,
          if (isLandscapeMode) _showChart ? txChartWidget : txListWidget,
        ],
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar as ObstructingPreferredSizeWidget,
            child: appBody,
          )
        : Scaffold(
            appBar: appBar,
            body: appBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _showAddTransactionSheet(context),
                    child: const Icon(Icons.add),
                  ),
          );
  }
}
