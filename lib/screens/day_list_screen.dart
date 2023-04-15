import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fittrack/screens/workout_list_screen.dart';
import 'package:flutter_fittrack/utilities/fittrack_text_style.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import '../models/day.dart';
import '../models/firebase_user_info.dart';
import '../network_utils/firebase/day_list_data_manager.dart';
import '../network_utils/firebase/user_data_manager.dart';
import '../utilities/common.dart';
import '../utilities/fittrack_colors.dart';
import '../utilities/fittrack_text.dart';

class DayListScreen extends StatefulWidget {
  const DayListScreen({Key? key}) : super(key: key);

  @override
  State<DayListScreen> createState() => _DayListScreenState();
}

class _DayListScreenState extends State<DayListScreen> {
  List<Day>? dayList = [];
  bool isLoading = false;
  late FirebaseUserInfo userInfo;
  String firebaseUId = FirebaseAuth.instance.currentUser!.uid;
  String userName = "";

  @override
  void initState() {
    super.initState();
    isLoading = true;
    userInfo = FirebaseUserInfo.Instance();
    setState(() {
      getDayList(dayList!).whenComplete(() => {
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
          automaticallyImplyLeading: false,
          elevation: 0.9,
          backgroundColor: kColorMainApp,
          title: Text(
            kDaysPageTitle,
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
                      kDaysPageDescription,
                      style: FittrackTextStyle.pageDescriptionTextStyle(),
                    ),
                    SizedBox(
                      height: 29.0,
                    ),
                    dayListWidget(),
                  ],
                ),
              ));
  }

  Widget dayListWidget() {
    return dayList != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: dayList!.length,
            itemBuilder: (context, index) {
              return dayListItem(dayList![index]);
            },
          )
        : Container();
  }

  Widget dayListItem(Day day) {
    return GestureDetector(
      onTap: () {
        openWorkoutListScreen(day.dayId);
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
                          day.dayName,
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

  void openWorkoutListScreen(int dayId) {
    Get.to(() => WorkoutListScreen(
          dayId: dayId,
        ));
  }
}
