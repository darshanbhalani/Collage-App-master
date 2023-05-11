// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
//
// class CalenderPage extends StatefulWidget {
//   const CalenderPage({Key? key}) : super(key: key);
//
//   @override
//   State<CalenderPage> createState() => _CalenderPageState();
// }
//
// class _CalenderPageState extends State<CalenderPage> {
//
//   CalendarFormat _format= CalendarFormat.month;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Calender"),
//       ),
//       body:ListView(
//         children: [
//           TableCalendar(
//             focusedDay: DateTime.now(),
//             firstDay: DateTime.now(),
//             lastDay: DateTime(2025),
//             calendarFormat: _format,
//             rowHeight: 60,
//             daysOfWeekHeight: 60,
//             startingDayOfWeek: StartingDayOfWeek.monday,
//             daysOfWeekStyle:DaysOfWeekStyle(
//                 weekendStyle: TextStyle(color: Colors.red)
//             ) ,
//             calendarStyle: CalendarStyle(
//               weekendTextStyle: TextStyle(color: Colors.red),
//             ),
//           ),
//         ],
//       ),
//     );
//
//   }
// }
