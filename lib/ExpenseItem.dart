// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './models/Transation.dart';

class ExpenseItem extends StatelessWidget {
  final Transaction item;
  final Function delteCallBack;
  const ExpenseItem(this.item, this.delteCallBack, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 2),
                ),
                child: SizedBox(
                  width: 40,
                  child: FittedBox(
                    child: Text(
                      '\$${item.amount.toStringAsFixed(2)}',
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ),
              Flexible(
                  fit: FlexFit.tight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title.toString(),
                          style: Theme.of(context).textTheme.titleLarge),
                      Text(DateFormat("MMM dd yyyy").format(item.date))
                    ],
                  )),
              IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: () {
                    delteCallBack(item.id);
                  })
            ],
          ),
        ));
  }
}
