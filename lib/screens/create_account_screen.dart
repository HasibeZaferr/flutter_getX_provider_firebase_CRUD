import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fittrack/models/firebase_user_info.dart';
import 'package:flutter_fittrack/screens/login_screen.dart';
import 'package:flutter_fittrack/utilities/fittrack_text_style.dart';
import 'package:get/get.dart';
import '../network_utils/firebase/user_data_manager.dart';
import '../utilities/fittrack_colors.dart';
import 'day_list_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0F172A),
        title: Text(
          'Create an account',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Your Name',
                        filled: true,
                        fillColor: kColorTextFieldBackground,
                        hintStyle: FittrackTextStyle.hintTextStyle(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.all(16.0),
                      ),
                      style: TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'E-mail',
                        filled: true,
                        fillColor: kColorTextFieldBackground,
                        hintStyle: FittrackTextStyle.hintTextStyle(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.all(16.0),
                      ),
                      style: TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email address';
                        } else if (!value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        hintText: 'Password (8+ characters)',
                        filled: true,
                        fillColor: kColorTextFieldBackground,
                        hintStyle: FittrackTextStyle.hintTextStyle(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.all(16.0),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: kColorMainApp,
                          ),
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                      ),
                      style: TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a password';
                        } else if (value.length < 8) {
                          return 'Password must be at least 8 characters long';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
              ),
              SizedBox(height: 240.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      createUserWithEmailAndPassword();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff0F172A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      padding: EdgeInsets.all(16.0),
                      minimumSize: Size(double.infinity, 60.0),
                    ),
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Already have an account?',
                    style: TextStyle(
                      color: Color(0xff0F172A),
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.0),
                  TextButton(
                    onPressed: () {
                      Get.to(() => LoginScreen());
                    },
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                        color: Color(0xff0F172A),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Moderat',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> createUserWithEmailAndPassword() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      if (!EmailValidator.validate(email)) {
        throw FirebaseAuthException(
          code: 'invalid-email',
          message: 'The email address is badly formatted.',
        );
      }

      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      FirebaseUserInfo firebaseUserInfo = FirebaseUserInfo(
          userEmail: user!.email,
          userName: _nameController.text ?? "",
          userProfilePhotoUrl: user.email);
      addUser(user.uid, firebaseUserInfo).whenComplete(() => Get.to(
            () => DayListScreen(),
          ));
      print('Yeni kullanıcı oluşturuldu: ${user.uid}');
    } catch (e) {
      print('Hata oluştu: $e');
    }
  }
}
