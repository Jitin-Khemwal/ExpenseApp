// ignore_for_file: file_names, unused_import

import 'package:flutter/foundation.dart';

class Transaction {
  final String id;
  final double amount;
  final String title;
  final DateTime date;
  final int type;

  Transaction(
      {required this.id,
      required this.amount,
      required this.title,
      required this.date,
      required this.type});
}
