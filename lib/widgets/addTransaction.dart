import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTransaction extends StatefulWidget {
  final Function addTransaction;

  const AddTransaction(this.addTransaction, {Key? key}) : super(key: key);

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _chosenDate;

  void _addTransactionCallback() {
    try {
      var numAmount = num.parse(_amountController.text);
      if ((_titleController.text.isNotEmpty) &&
          (numAmount >= 0) &&
          _chosenDate != null) {
        widget.addTransaction(
          _titleController.text,
          num.parse(_amountController.text),
          _chosenDate,
        );
        Navigator.of(context).pop();
      } else {
        throw const FormatException('Empty Input Values');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _presentDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((value) => setState(() => _chosenDate = value));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextField(
          decoration: const InputDecoration(labelText: 'Title'),
          controller: _titleController,
          onSubmitted: (_) => _addTransactionCallback(),
        ),
        TextField(
          decoration: const InputDecoration(labelText: 'Amount'),
          controller: _amountController,
          keyboardType: TextInputType.number,
          onSubmitted: (_) => _addTransactionCallback(),
        ),
        Container(
          margin: const EdgeInsets.only(top: 12, bottom: 24),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _chosenDate == null
                      ? 'No date chosen'
                      : DateFormat.yMMMMd().format(_chosenDate!),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              TextButton(
                onPressed: () => _presentDatePicker(context),
                style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.titleSmall),
                child: const Text('Choose date'),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: _addTransactionCallback,
          style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.titleSmall,
              backgroundColor: Theme.of(context).primaryColorLight),
          child: const Text('Add Transaction'),
        ),
      ],
    );
  }
}
