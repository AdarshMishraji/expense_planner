// ignore_for_file: avoid_print

import 'package:intl/intl.dart';

import '../models/transaction.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  const Chart(this.recentTransactions, {Key? key}) : super(key: key);

  List<Map<String, dynamic>> get groupedTransactionValues {
    return List.generate(
      7,
      (index) {
        final weekDay = DateTime.now().subtract(Duration(days: index));
        num sum = 0;
        for (var element in recentTransactions) {
          if (element.date.day == weekDay.day &&
              element.date.month == weekDay.month &&
              element.date.year == weekDay.year) {
            sum += element.amount;
          }
        }
        return {
          'day': DateFormat.E().format(weekDay).substring(0, 1),
          'amount': sum
        };
      },
    ).reversed.toList();
  }

  num get totalWeekSpent {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTransactionValues);
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues
              .map((data) => Flexible(
                    fit: FlexFit.tight,
                    child: CharBar(
                        data['day'],
                        data['amount'],
                        totalWeekSpent == 0.0
                            ? 0.0
                            : (data['amount'] as num) / totalWeekSpent),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class CharBar extends StatelessWidget {
  final String label;
  final num spendingAmount;
  final num spendingPercentageOfTotal;

  const CharBar(this.label, this.spendingAmount, this.spendingPercentageOfTotal,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => Column(
        children: [
          SizedBox(
            height: constraints.maxHeight * 0.125,
            child: FittedBox(
              child: Text('\$${spendingAmount.toStringAsFixed(0)}'),
            ),
          ),
          Container(
            margin:
                EdgeInsets.symmetric(vertical: constraints.maxHeight * 0.075),
            height: constraints.maxHeight * 0.6,
            width: 10,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    color: const Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: spendingPercentageOfTotal.toDouble(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.125,
            child: FittedBox(
              child: Text(label),
            ),
          )
        ],
      ),
    );
  }
}
