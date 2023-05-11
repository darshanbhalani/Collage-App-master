import 'package:flutter/material.dart';
import 'package:myapp2/app/util/Functions.dart';

class StudentCorner extends StatefulWidget {
  const StudentCorner({Key? key}) : super(key: key);

  @override
  State<StudentCorner> createState() => _StudentCornerState();
}

class _StudentCornerState extends State<StudentCorner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Corner"),
      ),
      body: ListView(
        children: [
          ListField(context, null, "Check Result", ChechResult()),
          ListField(context, null, "Request to Admin", RequesttoAdmin()),
          ListField(context, null, "Pay Collage Fees", PayCollageFees()),
          ListField(context, null, "Pay Exam Fees", PayExamFees()),
        ],
      ),
    );
  }
}

class ChechResult extends StatelessWidget {
  const ChechResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Check Result"),
      ),
      body: Center(
          child: Text(
        "Comming Soon...",
        style: TextStyle(fontSize: 30),
      )),
    );
  }
}

class RequesttoAdmin extends StatelessWidget {
  const RequesttoAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RequestToAdmin();
  }
}

class PayCollageFees extends StatelessWidget {
  const PayCollageFees({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pay Collage Fees"),
      ),
      body: Center(
          child: Text(
        "Comming Soon...",
        style: TextStyle(fontSize: 30),
      )),
    );
  }
}

class PayExamFees extends StatelessWidget {
  const PayExamFees({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pay Exam Fees"),
      ),
      body: Center(
          child: Text(
        "Comming Soon...",
        style: TextStyle(fontSize: 30),
      )),
    );
  }
}
