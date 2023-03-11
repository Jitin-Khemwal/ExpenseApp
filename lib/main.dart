import 'package:expenses/AddExpense.dart';
import 'package:expenses/models/Transation.dart';
import 'package:expenses/widgets/ExpenseScaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './ExpenseItem.dart';
import './Chart.dart';
import 'package:intl/intl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const ExpenseApp());
}

class ExpenseApp extends StatelessWidget {
  const ExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          fontFamily: "Quicksand",
          textTheme: ThemeData.light().textTheme.copyWith(
              titleLarge: const TextStyle(
                  fontFamily: "OpenSans",
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(
                  fontFamily: "OpenSans",
                  fontSize: 16,
                  fontWeight: FontWeight.bold))),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageAppState();
}

class _HomePageAppState extends State<HomePage> {
  final List<Transaction> transactions = [];

  void _updateTransaction(Transaction transaction) {
    setState(() {
      transactions.add(transaction);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      transactions.removeWhere((element) => element.id == id);
    });
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return AddExpense((txTitle, txAmount, selectedDate, viewType) {
            _updateTransaction(Transaction(
                id: DateTime.now().toString(),
                amount: txAmount,
                title: txTitle,
                date: selectedDate,
                type: viewType));
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return ExpenseScaffold(
        MainLayout(transactions, (id) {
          _deleteTransaction(id);
        }), () {
      _showBottomSheet(context);
    });
  }
}

// ignore: must_be_immutable
class MainLayout extends StatelessWidget {
  List<Transaction> transactions = [];
  Function deleteTransaction;
  MainLayout(this.transactions, this.deleteTransaction, {super.key});

  List<Transaction> get _recentTransactions {
    return transactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: transactions.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 60,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Text(
                    "Add Expense by clicking on '+' button",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                )
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Chart(_recentTransactions),
                Expanded(
                    child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    final tx = transactions[index];
                    if (tx.type == 1) {
                      return Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text('\$${tx.amount.toStringAsFixed(2)}'),
                            ),
                            title: Text(tx.title,
                                style: Theme.of(context).textTheme.titleLarge),
                            subtitle:
                                Text(DateFormat("MMM dd yyyy").format(tx.date)),
                            trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () {
                                  deleteTransaction(tx.id);
                                }),
                          ),
                        ),
                      );
                    } else {
                      return ExpenseItem(tx, (id) {
                        deleteTransaction(id);
                      });
                    }
                  },
                  itemCount: transactions.length,
                ))
              ],
            ),
    );
  }
}
