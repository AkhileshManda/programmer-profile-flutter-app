import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

Widget contestCard(
    {required String name,
    required DateTime start,
    required DateTime end,
    required String site,
    required String href}) {
  String day = DateFormat('EEEE').format(start).substring(0, 3);
  String monthName = DateFormat.MMMMd().format(start).split(" ")[0];
  Uri url = Uri.parse(href);
  return GestureDetector(
    onTap: () async {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw "Could not launch ";
      }
    },
    child: GlassmorphicContainer(
      width: double.infinity,
      height: 185,
      borderRadius: 20,
      blur: 20,
      alignment: Alignment.bottomCenter,
      border: 2,
      linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFffffff).withOpacity(0.1),
            const Color(0xFFFFFFFF).withOpacity(0.05),
          ],
          stops: const [
            0.1,
            1,
          ]),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFFffffff).withOpacity(0.5),
          const Color((0xFFFFFFFF)).withOpacity(0.5),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(7.5),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, top: 8, bottom: 2),
                  child: Text(monthName,
                      style: const TextStyle(color: Colors.white, fontSize: 15)),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, top: 8, bottom: 2),
                  child: Text(
                    start.toString().substring(8, 10),
                    style: const TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(day,
                      style: const TextStyle(color: Colors.white, fontSize: 20)),
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
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                      //textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(
                  width: 190,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Start : ${DateFormat("MM-dd HH:mm").format(start)}\n\nEnd : ${DateFormat("MM-dd HH:mm").format(end)}",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      site,
                      style: const TextStyle(color: Colors.pink, fontSize: 20),
                      overflow: TextOverflow.ellipsis,
                    ),
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
