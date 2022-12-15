import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

Widget contestCard(
    {required String name,
    required DateTime start,
    required DateTime end,
    required String site}) {
  
  //String day = DateFormat('EEEE').format(start).substring(0,3);

  return Card(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // Column(
          //   children: [
              
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Text(),
          //     ),
              
          //   ],
          // ),
          Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  start.toString(),
                  textAlign: TextAlign.center,
                ),
              ),
          Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(end.toString()),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(site),
              )
        ],
      ),
    ),
  );
}
