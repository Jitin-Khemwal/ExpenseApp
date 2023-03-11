import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ExpenseScaffold extends StatelessWidget {
  final Widget expenseBody;
  final Function openBottomSheet;
  const ExpenseScaffold(this.expenseBody, this.openBottomSheet, {super.key});

  PreferredSizeWidget get expenseAppBar {
    final PreferredSizeWidget iosAppBar = CupertinoNavigationBar(
      middle: const Text("Expense"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            child: const Icon(
              Icons.add,
              color: Colors.black,
            ),
            onTap: () {
              openBottomSheet();
            },
          )
        ],
      ),
    );
    final PreferredSizeWidget androidAppBar = AppBar(
      title: const Text("Expense"),
      centerTitle: false,
      actions: [
        IconButton(
            onPressed: () {
              openBottomSheet();
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ))
      ],
    );
    if (Platform.isIOS) {
      return iosAppBar;
    } else {
      return androidAppBar;
    }
  }

  @override
  Widget build(BuildContext context) {
    final safeAreaBody = SafeArea(child: expenseBody);
    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: expenseAppBar as ObstructingPreferredSizeWidget,
            child: safeAreaBody,
          )
        : Scaffold(
            appBar: expenseAppBar,
            body: safeAreaBody,
            floatingActionButton: FloatingActionButton(
                onPressed: () => openBottomSheet(),
                child: const Icon(
                  Icons.add,
                  color: Colors.black,
                )),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
    ;
  }
}
