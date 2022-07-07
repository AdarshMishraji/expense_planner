import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> userTransactions;
  final Function onDeleteCallback;

  const TransactionList(this.userTransactions, this.onDeleteCallback,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return userTransactions.isEmpty
        ? const NoTransactions()
        : ListView.builder(
            itemCount: userTransactions.length,
            itemBuilder: (ctx, index) => Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                leading: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 7.5,
                        blurStyle: BlurStyle.outer,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text(
                    style: Theme.of(context).textTheme.titleLarge,
                    '\$${userTransactions[index].amount.toStringAsFixed(2)}',
                  ),
                ),
                title: Text(
                  userTransactions[index].title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text(
                  DateFormat.yMMMMd().format(userTransactions[index].date),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => onDeleteCallback(userTransactions[index].id),
                  color: Theme.of(context).errorColor,
                ),
              ),
            ),
          );
  }
}

class NoTransactions extends StatelessWidget {
  const NoTransactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'No transactions added yet!',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Expanded(
          child: Image.asset(
            'assets/images/waiting.png',
            fit: BoxFit.cover,
          ),
        )
      ],
    );
  }
}
