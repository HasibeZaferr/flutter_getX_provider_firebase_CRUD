import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fittrack/models/workout.dart';
import 'package:flutter_fittrack/network_utils/firebase/workout_data_manager.dart';
import 'package:flutter_fittrack/screens/add_training_screen.dart';
import 'package:flutter_fittrack/screens/update_training_screen.dart';
import 'package:flutter_fittrack/utilities/fittrack_text.dart';
import 'package:flutter_fittrack/utilities/fittrack_text_style.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import '../models/firebase_user_info.dart';
import '../network_utils/firebase/user_data_manager.dart';
import '../utilities/common.dart';
import '../utilities/fittrack_colors.dart';

class WorkoutListScreen extends StatefulWidget {
  int dayId;

  WorkoutListScreen({required this.dayId});

  @override
  State<WorkoutListScreen> createState() => _WorkoutListScreenState();
}

class _WorkoutListScreenState extends State<WorkoutListScreen> {
  List<Workout>? workoutList = [];
  bool isLoading = false;
  late FirebaseUserInfo userInfo;
  String firebaseUId = FirebaseAuth.instance.currentUser!.uid;
  String userName="";

  @override
  void initState() {
    super.initState();
    isLoading = true;
    userInfo = FirebaseUserInfo.Instance();

    setState(() {
      getWorkoutList(firebaseUId, workoutList!, widget.dayId)
          .whenComplete(() => {
                setState(() {
                  getCurrentUserInfo(firebaseUId, userInfo)
                      .whenComplete(() => {
                    setState(() {
                      if (userInfo.userName != null) {
                        userName = userInfo.userName!;
                      }
                      isLoading = false;
                    })
                  });
                })
              });
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.9,
        backgroundColor: kColorMainApp,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          kWorkoutListTitle,
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
      body: isLoading
          ? SpinKitFadingCircle(
              color: kColorMainApp,
            )
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello" + userName,
                    style: FittrackTextStyle.pageTitleStyle(),
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                  Text(
                    kWorkoutListPageDescription,
                    style: FittrackTextStyle.pageDescriptionTextStyle(),
                  ),
                  SizedBox(
                    height: 29.0,
                  ),
                  workoutListWidget(),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => TrainingAddScreen(dayId: widget.dayId))?.then((value) {
            if (value != null && value == "reload") {
              setState(() {
                workoutList = [];
                getWorkoutList(firebaseUId, workoutList!, widget.dayId)
                    .whenComplete(() => {
                          setState(() {
                            isLoading = false;
                          })
                        });
              });
            }
          });
        },
        backgroundColor: kColorMainApp,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget workoutListWidget() {
    return workoutList != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: workoutList!.length,
            itemBuilder: (context, index) {
              return workoutListItem(workoutList![index]);
            },
          )
        : Container();
  }

  Widget workoutListItem(Workout workout) {
    return GestureDetector(
      onTap: () {
        openBottomSheet(workout);
      },
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              color: kColorDayListBackground,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          workout.workoutName +
                              " - " +
                              workout.workoutTime.toString() +
                              " min",
                          style: FittrackTextStyle.defaultTextStyle(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }

  void openBottomSheet(Workout workout) {
    showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                bottomSheetListTile(
                    title: "Edit",
                    iconPath: 'assets/icons/ic_edit.png',
                    function: () {
                      Navigator.pop(context);
                      Get.to(() => UpdateTrainingScreen(
                            dayId: widget.dayId,
                            workout: workout,
                          ))?.then((value) {
                        if (value != null && value == "reload") {
                          setState(() {
                            workoutList = [];
                            getWorkoutList(firebaseUId, workoutList!, widget.dayId)
                                .whenComplete(() => {
                              setState(() {
                                isLoading = false;
                              })
                            });
                          });
                        }
                      });;
                    }),
                const Divider(
                  height: 2,
                  color: Colors.black26,
                ),
                bottomSheetListTile(
                    title: 'Delete',
                    iconPath: 'assets/icons/ic_delete.png',
                    function: () {
                      Dialogs.materialDialog(
                          msg: 'Are you sure you want to delete the item?',
                          title: "Delete",
                          color: Colors.white,
                          context: context,
                          actions: [
                            IconsOutlineButton(
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                              text: 'Cancel',
                              textStyle: GoogleFonts.raleway(
                                  textStyle: TextStyle(
                                      color: kColorMainApp,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                            ),
                            IconsOutlineButton(
                              onPressed: () async {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                deleteWorkoutItem(context, workout);
                              },
                              text: 'Delete',
                              textStyle: GoogleFonts.raleway(
                                  textStyle: TextStyle(
                                      color: kColorMainApp,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ]);
                    }),
              ],
            ),
          ),
        );
      },
    );
  }

  void deleteWorkoutItem(BuildContext context, Workout workout) {
    Navigator.of(context, rootNavigator: true).pop();
    isLoading = true;

    deleteWorkout(firebaseUId, widget.dayId, workout).whenComplete(() => {
          setState(() {
            workoutList = [];
            getWorkoutList(firebaseUId, workoutList!, widget.dayId)
                .whenComplete(() => {
                      setState(() {
                        isLoading = false;
                      })
                    });
            isLoading = false;
            Navigator.pop(context);
          })
        });
  }

  Widget bottomSheetListTile(
      {required String title,
      required String iconPath,
      required VoidCallback function}) {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onTap: function,
      splashColor: Colors.blueAccent,
      child: ListTile(
        leading: Image.asset(
          iconPath,
          height: 24.0,
          width: 24.0,
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
            color: kColorMainApp,
          )),
        ),
      ),
    );
  }
}
