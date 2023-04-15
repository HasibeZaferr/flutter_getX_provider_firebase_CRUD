import 'dart:convert';
import 'dart:math';
import 'package:flutter_fittrack/models/workout.dart';
import 'package:http/http.dart' as http;

Future<void> addWorkout(String firebaseUId, int dayId, Workout workout) async {
  var url = Uri.parse(
      'https://fittrack-e5a63-default-rtdb.firebaseio.com/UserWorkouts/${firebaseUId}/Days/${dayId}/Workouts/${workout.workoutId}.json');
  await http.patch(url,
      body: json.encode({
        'workoutName': workout.workoutName,
        'workoutTime': workout.workoutTime,
      }));
}

Future<void> deleteWorkout(
    String firebaseUId, int dayId, Workout workout) async {
  var url = Uri.parse(
      'https://fittrack-e5a63-default-rtdb.firebaseio.com/UserWorkouts/${firebaseUId}/Days/${dayId}/Workouts/${workout.workoutId}.json');
  final response = await http.delete(url);

  if (response.statusCode == 200) {
    print('Data deleted successfully');
  } else {
    print('Failed to delete data. Error code: ${response.statusCode}');
  }
}

Future<void> getWorkoutList(
    String firebaseUId, List<Workout> workoutList, int dayId) async {
  var url = Uri.parse(
      'https://fittrack-e5a63-default-rtdb.firebaseio.com/UserWorkouts/${firebaseUId}/Days/${dayId}/Workouts/.json?');
  final response = await http.get(url);
  final extractedData = json.decode(response.body) as Map<String, dynamic>;

  extractedData.forEach((workoutId, workoutData) {
    workoutList.add(
      Workout(
        workoutId: workoutId,
        workoutName: workoutData['workoutName'],
        workoutTime: workoutData['workoutTime'],
      ),
    );
  });
}
