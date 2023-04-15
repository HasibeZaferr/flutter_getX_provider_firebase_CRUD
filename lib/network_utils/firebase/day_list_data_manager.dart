import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/day.dart';

Future<void> getDayList(List<Day> dayList) async {
  var url = Uri.parse(
      'https://fittrack-e5a63-default-rtdb.firebaseio.com/Days.json?');
  final response = await http.get(url);
  final extractedData = json.decode(response.body) as Map<String, dynamic>;

  extractedData.forEach((dayId, dayData) {
    dayList.add(
      Day(
        dayId: dayData['dayId'],
        dayName: dayData['dayName'],
      ),
    );
  });
}
