import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'models/TransactionClass.dart';
import 'widget/chart.dart';
import "widget/transaction_list.dart";
import 'widget/new_transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    MyApp(),
  );
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "My Expanses",
        home: MyHomePage(),
        theme: ThemeData(
            primarySwatch: Colors.teal,
            // ignore: deprecated_member_use
            accentColor: Colors.cyan,
            fontFamily: 'Quicksand',
            textTheme: const TextTheme(
                subtitle1: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.normal,
                    fontSize: 18),
                subtitle2: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
            appBarTheme: AppBarTheme(
              // ignore: deprecated_member_use
              textTheme: ThemeData.light().textTheme.copyWith(
                    subtitle1: const TextStyle(
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
            )));
  }
}

// ignore: use_key_in_widget_constructors
class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  // ignore: non_constant_identifier_names
  final List<Transaction> TransactionBody = [];
  bool showChart = false;

  List<Transaction> get recentTransactions {
    return TransactionBody.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  void addTransaction(String txTitle, int txAmount, DateTime date) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: txTitle,
        amount: txAmount,
        date: date);

    setState(() {
      TransactionBody.add(newTx);
    });
  }

  void startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      useRootNavigator: true,
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: NewTransaction(addTransaction),
        );
      },
    );
  }

  void deleteTransaction(String id) {
    setState(() {
      TransactionBody.removeWhere((tx) => tx.id == id);
    });
  }

  // ignore: non_constant_identifier_names
  List<Widget> BuildLanndscapeMode(
      MediaQueryData mediaQuery, AppBar appbar, Widget listWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Show Chart'),
          Switch.adaptive(
              //adaptive is used for adust the according to the operating system
              value: showChart,
              onChanged: (val) {
                setState(() {
                  showChart = val;
                });
              })
        ],
      ),
      showChart
          ? SizedBox(
              height: (mediaQuery.size.height -
                      appbar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(recentTransactions),
            )
          : listWidget,
    ];
  }

  // ignore: non_constant_identifier_names
  List<Widget> BuildPortraitMode(
      MediaQueryData mediaQuery, AppBar appbar, Widget listWidget) {
    return [
      SizedBox(
        height: (mediaQuery.size.height -
                appbar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(recentTransactions),
      ),
      listWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appbar = AppBar(
      title: const Text(
        "My Expenses",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
            onPressed: () => startAddNewTransaction(context),
            icon: const Icon(Icons.add))
      ],
    );
    final listWidget = SizedBox(
      height: (mediaQuery.size.height -
              appbar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(TransactionBody, deleteTransaction),
    );
    return Scaffold(
      appBar: appbar,
      body: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isLandscape)
            ...BuildLanndscapeMode(mediaQuery, appbar, listWidget),
          if (!isLandscape)
            ...BuildPortraitMode(mediaQuery, appbar, listWidget),
          // if (!isLandscape) listWidget,
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => startAddNewTransaction(context),
            ),
    );
  }
}
