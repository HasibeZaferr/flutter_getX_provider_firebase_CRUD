import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fittrack/screens/day_list_screen.dart';
import 'package:flutter_fittrack/screens/login_screen.dart';
import 'package:get/get.dart';
import '../helpers/Globals.dart';
import '../services/auth.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

enum AuthStatus { notSignedIn, signedIn }

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  AuthStatus _authStatus = AuthStatus.notSignedIn;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    )..forward();

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

     AuthService().getCurrentUserId().then((userId) {
      if (userId != null) {
        Globals.currentUserID = userId;
        openHomePage();
      } else {
        openAuthPage();
      }
      setState(() {
        _authStatus =
        userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });

  }

  openHomePage() async {
    var duration = const Duration(seconds: 4);
    return Timer(duration, () {
      Get.to(() => DayListScreen());
    });
  }

  openAuthPage() async {
    var duration = const Duration(seconds: 4);
    return Timer(duration, () {
      Get.to(() => LoginScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Text(
            "FitTrack",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}