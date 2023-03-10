import 'package:expenses/ChartBar.dart';
import 'package:flutter/material.dart';
import './models/Transation.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> transactions;

  const Chart(this.transactions, {super.key});

  List<Map<String, Object>> get groupTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0;
      for (var tx in transactions) {
        if (tx.date.day == weekDay.day &&
            tx.date.month == weekDay.month &&
            tx.date.year == weekDay.year) {
          totalSum += tx.amount;
        }
      }
      return {"day": DateFormat.E().format(weekDay), "amount": totalSum};
    }).reversed.toList();
  }

  double get maxSpending {
    return groupTransactionValues.fold(0.0, (sum, tx) {
      return sum + (tx["amount"] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ...groupTransactionValues.map((tx) {
                  return Flexible(
                      fit: FlexFit.tight,
                      child: ChartBar(
                          label: (tx["day"] as String),
                          spendingAmount: (tx["amount"] as double),
                          spendingFactor: maxSpending == 0.0
                              ? 0.0
                              : (tx["amount"] as double) / maxSpending));
                }).toList()
              ],
            ),
          )),
    );
  }
}
