import 'dart:async';
import 'dart:collection';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wallet_q/tabungan/tabungans.dart';
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
  final _textcontrollerAMOUNT = TextEditingController();
  final _textcontrollerITEM = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = false, isLoaded = false;
  Users? users;
  List recenttabungans = [];
  List<Tabungans> tabungans = [];
  List<List> tabungansPerDay = [];
  int amount = 0;
  int income = 0;
  int expense = 0;

  ValueNotifier<List<Tabungans>> _selectedEvents = ValueNotifier([]);
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime? _selectedDay;

  Map<String, List<Tabungans>>? groupByDate;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _selectedDay = _focusedDay;
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

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
        tabungans.sort((tabungan1, tabungan2) => tabungan2.time.compareTo(tabungan1.time));

        recenttabungans = tabungans.take(3).toList();

        groupByDate = groupBy(tabungans, (Tabungans t) {
          return DateFormat('yMd').format(DateTime.fromMillisecondsSinceEpoch(t.time));
        });

        if (_selectedEvents.value.isEmpty && _focusedDay == DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)) {
          List<Tabungans> _getEventsForDay() {
            final kEvents = LinkedHashMap<String, List<Tabungans>>()..addAll(groupByDate!);

            return kEvents[DateFormat('yMd').format(DateTime.now())] ?? [];
          }

          _selectedEvents.value = _getEventsForDay();
        }

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

    void _enterTransaction(bool _isIncome) {
      TabungansServices.createTabungan(
        users!.id,
        int.parse(_textcontrollerAMOUNT.text),
        _textcontrollerITEM.text,
        (_isIncome) ? "Pemasukan" : "Pengeluaran",
        DateTime.now().millisecondsSinceEpoch,
      );
      setState(() {
        isLoaded = false;
        _isIncome = false;
        _textcontrollerAMOUNT.text = "";
        _textcontrollerITEM.text = "";
      });
    }

    void _newTransaction() {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                title: const Text(
                  'T R A N S A K S I B A R U',
                  textAlign: TextAlign.center,
                ),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text('Pengeluaran'),
                          Switch(
                            value: _isIncome,
                            activeColor: Colors.pink[200],
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
                                keyboardType: TextInputType.number,
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
                                hintText: 'Deskripsi',
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
                    color: Colors.pink[300],
                    child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  MaterialButton(
                    color: Colors.pink[300],
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
                        child: ListView.builder(
                          itemCount: recenttabungans.length + 1,
                          itemBuilder: (context, index) {
                            if (index == recenttabungans.length) {
                              return SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: NeumorphicButton(
                                  onPressed: () async {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return StatefulBuilder(builder: (context, setState) {
                                          return AlertDialog(
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                            elevation: 16,
                                            content: SizedBox(
                                              width: MediaQuery.of(context).size.width,
                                              height: MediaQuery.of(context).size.height * 2,
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Flexible(
                                                      fit: FlexFit.loose,
                                                      child: TableCalendar<Tabungans>(
                                                        headerStyle: HeaderStyle(
                                                          formatButtonVisible: false,
                                                        ),
                                                        availableGestures: AvailableGestures.horizontalSwipe,
                                                        firstDay:
                                                            DateTime(DateTime.now().year, DateTime.now().month - 3, DateTime.now().day),
                                                        lastDay:
                                                            DateTime(DateTime.now().year, DateTime.now().month + 3, DateTime.now().day),
                                                        focusedDay: _focusedDay,
                                                        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                                                        calendarFormat: _calendarFormat,
                                                        locale: "id_ID",
                                                        eventLoader: (DateTime day) {
                                                          final kEvents = LinkedHashMap<String, List<Tabungans>>()..addAll(groupByDate!);

                                                          return kEvents[DateFormat('yMd').format(day)] ?? [];
                                                        },
                                                        startingDayOfWeek: StartingDayOfWeek.monday,
                                                        calendarStyle: CalendarStyle(
                                                          selectedDecoration:
                                                              BoxDecoration(color: Color(0xFF7F3DFF), shape: BoxShape.circle),
                                                          markerDecoration: BoxDecoration(
                                                            color: Colors.purple[300],
                                                            shape: BoxShape.circle,
                                                          ),
                                                          markersMaxCount: 1,
                                                          outsideDaysVisible: false,
                                                        ),
                                                        onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                                                          if (!isSameDay(_selectedDay, selectedDay)) {
                                                            setState(() {
                                                              _selectedDay = selectedDay;
                                                              _focusedDay = focusedDay;
                                                            });

                                                            List<Tabungans> _getEventsForDay(DateTime day) {
                                                              final kEvents = LinkedHashMap<String, List<Tabungans>>()
                                                                ..addAll(groupByDate!);

                                                              return kEvents[DateFormat('yMd').format(day)] ?? [];
                                                            }

                                                            _selectedEvents.value = _getEventsForDay(selectedDay);
                                                          }
                                                        },
                                                        onPageChanged: (focusedDay) {
                                                          _focusedDay = focusedDay;
                                                        },
                                                      ),
                                                    ),
                                                    const SizedBox(height: 18.0),
                                                    Flexible(
                                                      fit: FlexFit.loose,
                                                      child: ValueListenableBuilder<List<Tabungans>>(
                                                        valueListenable: _selectedEvents,
                                                        builder: (context, value, _) {
                                                          return (value.isEmpty)
                                                              ? Container(
                                                                  margin: const EdgeInsets.only(bottom: 38.0),
                                                                  child: Column(
                                                                    children: [
                                                                      // Lottie.asset("assets/lottie/cross.json", height: MediaQuery.of(context).size.height / 4),
                                                                      Text(
                                                                        "Tidak ada data",
                                                                        style: TextStyle(
                                                                            fontFamily: "Baloo Da",
                                                                            fontSize: 20,
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              : SizedBox(
                                                                  height: 2000,
                                                                  child: ListView.builder(
                                                                    physics: BouncingScrollPhysics(),
                                                                    itemCount: value.length,
                                                                    itemBuilder: (context, index) {
                                                                      return Padding(
                                                                        padding: const EdgeInsets.only(bottom: 12.0),
                                                                        child: ClipRRect(
                                                                          borderRadius: BorderRadius.circular(10),
                                                                          child: Container(
                                                                            padding: EdgeInsets.all(15),
                                                                            color: Colors.grey[100],
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    Container(
                                                                                      padding: EdgeInsets.all(5),
                                                                                      decoration: BoxDecoration(
                                                                                          shape: BoxShape.circle, color: Colors.pink[200]),
                                                                                      child: Center(
                                                                                        child: Icon(
                                                                                          Icons.attach_money_outlined,
                                                                                          color: Colors.white,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: MediaQuery.of(context).size.width / 2 - 100,
                                                                                      child: Text(
                                                                                        value[index].description,
                                                                                        style: TextStyle(
                                                                                          fontSize: 12,
                                                                                          color: Colors.grey[700],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                Text(
                                                                                  (value[index].category == 'Pengeluaran' ? '-' : '+') +
                                                                                      '\Rp. ' +
                                                                                      value[index].amount.toString(),
                                                                                  style: TextStyle(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontSize: 12,
                                                                                    color: value[index].category == 'Pengeluaran'
                                                                                        ? Colors.red
                                                                                        : Colors.green,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                      },
                                    );
                                  },
                                  padding: EdgeInsets.symmetric(vertical: 18.0),
                                  provideHapticFeedback: true,
                                  style: NeumorphicStyle(
                                    shape: NeumorphicShape.flat,
                                    boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(18.0),
                                    ),
                                    depth: 1,
                                    shadowDarkColor: Colors.black,
                                    lightSource: LightSource.top,
                                    color: Color(0xFFDD2A7B),
                                  ),
                                  child: Text(
                                    'Lihat Selengkapnya',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }
                            return Dismissible(
                              key: UniqueKey(),
                              onDismissed: (direction) {
                                TabungansServices.deleteTabungan(
                                  recenttabungans[index].id,
                                  recenttabungans[index].amount,
                                  recenttabungans[index].description,
                                  recenttabungans[index].category,
                                  recenttabungans[index].time.toString(),
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
                                transactionName: recenttabungans[index].description,
                                money: recenttabungans[index].amount.toString(),
                                expenseOrIncome: recenttabungans[index].category,
                              ),
                            );
                          },
                        ),
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
