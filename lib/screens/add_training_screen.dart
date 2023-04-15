import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fittrack/models/workout.dart';
import 'package:flutter_fittrack/utilities/fittrack_colors.dart';
import 'package:flutter_fittrack/utilities/fittrack_text_style.dart';
import 'package:google_fonts/google_fonts.dart';
import '../network_utils/firebase/workout_data_manager.dart';
import '../utilities/common.dart';
import '../utilities/fittrack_text.dart';

class TrainingAddScreen extends StatefulWidget {
  int dayId;

  TrainingAddScreen({required this.dayId});

  @override
  State<TrainingAddScreen> createState() => _TrainingAddScreenState();
}

class _TrainingAddScreenState extends State<TrainingAddScreen> {
  final TextEditingController _trainingNameController = TextEditingController();

  final TextEditingController _trainingTimeController = TextEditingController();

  String firebaseUId = FirebaseAuth.instance.currentUser!.uid;

  void addWorkoutFromTextField() {
    String trainingName = _trainingNameController.text;
    String trainingTime = _trainingTimeController.text;
    String workoutId = randomString();
    Workout workout = Workout(
       workoutId: workoutId, workoutName: trainingName, workoutTime: int.parse(trainingTime));

    addWorkout(firebaseUId, widget.dayId, workout).whenComplete(() => {
          Navigator.pop(context, "reload"),
        });
  }

  String randomString() {
    const chars = 'abcdefghijklmnopqrstuvwxyz';
    final random = Random();
    return String.fromCharCodes(
        Iterable.generate(15, (_) => chars.codeUnitAt(random.nextInt(chars.length)))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.9,
        backgroundColor: kColorMainApp,
        titleTextStyle: GoogleFonts.amiko(
            textStyle: FittrackTextStyle.appBarTextStyle()),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          kWorkoutAddTrainingPageTitle,
          style: FittrackTextStyle.appBarTextStyle(),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.power_settings_new,
              color: Colors.red,
            ),
            onPressed: () {
              Common.openLogoutDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Text(
                  kWorkoutAddTrainingPageDescription,
                  style: FittrackTextStyle.pageDescriptionTextStyle(),
                ),
                SizedBox(height: 44),
                TextField(
                  controller: _trainingNameController,
                  decoration: InputDecoration(
                    hintText: 'Training Name',
                    hintStyle: FittrackTextStyle.hintTextStyle(),
                    filled: true,
                    fillColor: kColorTextFieldBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _trainingTimeController,
                  decoration: InputDecoration(
                    hintText: 'Training Time',
                    hintStyle: FittrackTextStyle.hintTextStyle(),
                    filled: true,
                    fillColor: kColorTextFieldBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 24, 24),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: addWorkoutFromTextField,
                  child: Text(
                    'Add',
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF0F172A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
