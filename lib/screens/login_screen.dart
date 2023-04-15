import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fittrack/screens/create_account_screen.dart';
import 'package:flutter_fittrack/screens/day_list_screen.dart';
import 'package:get/get.dart';
import '../services/auth.dart';
import '../utilities/fittrack_colors.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text)
          .whenComplete(() => Get.to(() => DayListScreen()));
      User? user = userCredential.user;
      print('Giriş yapıldı: ${user!.uid}');
    } catch (e) {
      print('Hata oluştu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Container(
          margin: EdgeInsets.only(top: 102.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Hi, Welcome back',
                style: TextStyle(
                  fontSize: 27.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Login in to your account',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Your Email',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.black54,
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(() => CreateAccountScreen());
                    },
                    child: Text(
                      'Sign up Or',
                      style: TextStyle(
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: kColorLoginIconBackground,
                          ),
                          child: IconButton(
                            onPressed: () {
                              // TODO: Implement Google login functionality
                            },
                            icon: Image.asset(
                              'assets/icons/ic_facebook.png',
                              height: 20.0,
                              width: 20.0,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: kColorLoginIconBackground,
                          ),
                          child: IconButton(
                            onPressed: () async {
                              await AuthService().signInWithGoogle(context);
                            },
                            icon: Image.asset(
                              'assets/icons/ic_google.png',
                              height: 20.0,
                              width: 20.0,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: kColorLoginIconBackground,
                        ),
                        child: IconButton(
                          onPressed: () async {
                            await AuthService().signInWithApple(context);
                          },
                          icon: Image.asset(
                            'assets/icons/ic_apple.png',
                            height: 20.0,
                            width: 20.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 150.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 60.0,
                  child: ElevatedButton(
                    onPressed: () {
                      signInWithEmailAndPassword();
                    },
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF0F172A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
