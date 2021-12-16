import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_q/users.dart';
import '../users_services.dart';
import 'plus_button.dart';
import 'tabungan_services.dart';
import 'top_card.dart';
import 'transaction.dart';

class Tabungan extends StatefulWidget {
  const Tabungan({Key? key}) : super(key: key);

  @override
  _TabunganState createState() => _TabunganState();
}

class _TabunganState extends State<Tabungan> {
  // collect user input
  final _textcontrollerAMOUNT = TextEditingController();
  final _textcontrollerITEM = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = false, isLoaded = false;
  Users? users;
  List tabungans = [];
  int amount = 0;
  int income = 0;
  int expense = 0;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    UsersServices.readUser(user.uid).then(
      (value) {
        try {
          users = value;
        } catch (e) {}
      },
    );

    if (!isLoaded) {
      TabungansServices.readTabungan(user.uid).then((value) {
        tabungans = value;
        amount = 0;
        income = 0;
        expense = 0;

        tabungans.forEach((element) {
          if (element.category == "Pemasukan") {
            income += element.amount as int;
            amount += element.amount as int;
          } else {
            expense += element.amount as int;
            amount -= element.amount as int;
          }
        });
        isLoaded = true;

        setState(() {});
      });
    }

    // enter the new transaction into the spreadsheet
    void _enterTransaction(bool _isIncome) {
      TabungansServices.createTabungan(
        users!.id,
        int.parse(_textcontrollerAMOUNT.text),
        _textcontrollerITEM.text,
        (_isIncome) ? "Pemasukan" : "Pengeluaran",
      );
      setState(() {
        isLoaded = false;
        _isIncome = false;
        _textcontrollerAMOUNT.text = "";
        _textcontrollerITEM.text = "";
      });
    }

    // new transaction
    void _newTransaction() {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                title: const Text('T R A N S A K S I B A R U'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text('Pengeluaran'),
                          Switch(
                            value: _isIncome,
                            onChanged: (newValue) {
                              setState(() {
                                _isIncome = newValue;
                              });
                            },
                          ),
                          const Text('Pemasukan'),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Jumlah',
                                ),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Masukkan Jumlah';
                                  }
                                  return null;
                                },
                                controller: _textcontrollerAMOUNT,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Untuk',
                              ),
                              controller: _textcontrollerITEM,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  MaterialButton(
                    color: Colors.grey[600],
                    child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  MaterialButton(
                    color: Colors.grey[600],
                    child: const Text('Enter', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _enterTransaction(_isIncome);
                        Navigator.of(context).pop();
                      }
                    },
                  )
                ],
              );
            },
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [
              0.5,
              0.9,
            ],
            colors: [
              Color(0xFFFFC0CB),
              Colors.white,
            ],
          ),
        ),
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            TopNeuCard(
              balance: amount.toString(),
              income: income.toString(),
              expense: expense.toString(),
            ),
            Expanded(
              child: Container(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        // child: GoogleSheetsApi.loading == true
                        //     ? LoadingCircle()
                        // :
                        child: ListView.builder(
                            itemCount: tabungans.length,
                            itemBuilder: (context, index) {
                              return Dismissible(
                                key: UniqueKey(),
                                onDismissed: (direction) {
                                  // Remove the item from the data source.
                                  TabungansServices.deleteTabungan(
                                    tabungans[index].id,
                                    tabungans[index].amount,
                                    tabungans[index].description,
                                    tabungans[index].category,
                                  );
                                  setState(() {
                                    isLoaded = false;
                                  });
                                },
                                background: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.red,
                                  ),
                                  padding: EdgeInsets.all(15.0),
                                ),
                                child: MyTransaction(
                                  transactionName: tabungans[index].description,
                                  money: tabungans[index].amount.toString(),
                                  expenseOrIncome: tabungans[index].category,
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                ),
              ),
            ),
            PlusButton(
              function: _newTransaction,
            ),
          ],
        ),
      ),
    );
  }
}
