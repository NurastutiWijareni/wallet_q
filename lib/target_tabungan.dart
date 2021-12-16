import 'package:flutter/material.dart';

class TargetTabungan extends StatefulWidget {
  const TargetTabungan({Key? key}) : super(key: key);

  @override
  _TargetTabunganState createState() => _TargetTabunganState();
}

class _TargetTabunganState extends State<TargetTabungan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: 1000,
        decoration: const BoxDecoration(
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
        child: Container(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * (1 / 6),
                decoration: BoxDecoration(
                  color: Color(0xFFFF98CE),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    Text(
                      "Target Tabungan",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Icon(
                      Icons.arrow_back_ios,
                      color: Colors.transparent,
                      size: 30,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * (1 / 6),
                ),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 56, height: MediaQuery.of(context).size.height / 4, child: SizedBox()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
