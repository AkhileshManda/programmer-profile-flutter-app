import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

Widget contestCard(
    {required String name,
    required DateTime start,
    required DateTime end,
    required String site,
    required String href}) {
  String day = DateFormat('EEEE').format(start).substring(0, 3);
  Uri url = Uri.parse(href);
  return GestureDetector(
    onTap: () async {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw "Could not launch ";
      }
    },
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(start.toString().substring(8, 10)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(day),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 200,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      name,
                      //textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Duration: ${end.difference(start).toString()}"),
                ),
                SizedBox(
                  width: 200,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(site),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
