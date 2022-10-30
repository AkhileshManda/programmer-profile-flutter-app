import 'dart:convert';

import '../model/contest_model.dart';
import 'package:http/http.dart' as http;

class ContestAPI{
  Future<List<Contest>> getContests() async {
    //print("Called");
    List<Contest> contests = [];
    Uri url1 = Uri.parse("https://kontests.net/api/v1/all");
    var response1 = await http.get(
      url1,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    final extractedData1 = json.decode(response1.body);

    for (var x in extractedData1) {
      contests.add(Contest(
          name: x["name"],
          url: x["url"],
          start: x["start_time"],
          end: x["end_time"],
          duration: x["duration"],
          in24hrs: x["in_24_hours"],
          status: x["status"],
          site: x["site"]));
    }

    //print(_contests.length);
    
    return contests;
  }
}