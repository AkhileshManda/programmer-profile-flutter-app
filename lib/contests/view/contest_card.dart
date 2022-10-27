import 'package:flutter/material.dart';

Widget contestCard(
    {required String name,
    required String start,
    required String end,
    required String site}) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(start),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(end),
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
