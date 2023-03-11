import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AddExpense extends StatefulWidget {
  final Function expenseCallback;

  const AddExpense(this.expenseCallback, {super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();

  DateTime? _selectedDate;

  void _addTransaction(BuildContext context) {
    final amount =
        amountController.text.isEmpty ? 0 : double.parse(amountController.text);
    final title = titleController.text;
    if (title.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter title");
      return;
    }
    if (amount < 10) {
      Fluttertoast.showToast(msg: "Please enter amount above 10");
      return;
    }

    if (_selectedDate == null) {
      Fluttertoast.showToast(msg: "Please select date");
      return;
    }
    int type = 0;
    if (amount < 100) {
      type = 1;
    }
    widget.expenseCallback(title, amount, _selectedDate, type);
    Navigator.of(context).pop();
  }

  void _showDatePicker(BuildContext context) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now().subtract(const Duration(days: 6)),
            lastDate: DateTime.now())
        .then((date) {
      setState(() {
        _selectedDate = date;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            decoration: const InputDecoration(label: Text("Title")),
            keyboardType: TextInputType.text,
            controller: titleController,
          ),
          TextField(
            decoration: const InputDecoration(label: Text("Amount")),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9.,]'))
            ],
            controller: amountController,
            onSubmitted: (e) {
              _addTransaction(context);
            },
          ),
          Row(
            children: [
              const SizedBox(
                height: 10,
              ),
              Expanded(
                  child: Text(_selectedDate == null
                      ? "No Date Choosen"
                      : "Picked Date : ${DateFormat("MMM dd yyyy").format(_selectedDate!)}")),
              TextButton(
                onPressed: () {
                  _showDatePicker(context);
                },
                child: Text(
                  "Choose Date",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          ElevatedButton(
              onPressed: () => _addTransaction(context),
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColor)),
              child: const Text("Add Expense"))
        ],
      ),
    );
  }
}
