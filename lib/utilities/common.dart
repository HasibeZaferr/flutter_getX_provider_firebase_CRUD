import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import '../screens/login_screen.dart';
import 'fittrack_text.dart';

class Common {
  static void openLogoutDialog(BuildContext context) {
    Dialogs.materialDialog(
        barrierDismissible: false,
        msg: kLogoutMessage,
        title: "Logout",
        lottieBuilder: Lottie.asset(
          'assets/animation/lottie/animation_logout.json',
          fit: BoxFit.contain,
        ),
        context: context,
        actions: [
          IconsOutlineButton(
            onPressed: () {
              Navigator.pop(context);
            },
            text: 'Cancel',
            textStyle: TextStyle(color: Colors.black, fontSize: 20),
          ),
          IconsOutlineButton(
            onPressed: () {
              Navigator.pop(context);
              _logout(context);
            },
            text: 'Logout',
            textStyle: TextStyle(color: Colors.black, fontSize: 20),
          )
        ]);
  }

  static void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return LoginScreen();
        },
      ),
      (_) => false,
    );
  }
}
