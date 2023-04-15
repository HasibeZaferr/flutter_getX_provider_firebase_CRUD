import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_fittrack/models/firebase_user_info.dart';
import 'package:http/http.dart' as http;

Future<void> addUser(
    @required String firebaseUId, @required FirebaseUserInfo firebaseUserInfo) async {
  var url = Uri.parse(
      'https://fittrack-e5a63-default-rtdb.firebaseio.com/Users/${firebaseUId}.json');
  await http.patch(url,
      body: json.encode({
        'userName': firebaseUserInfo.userName,
        'userEmail': firebaseUserInfo.userEmail,
        'userProfilePhotoUrl': firebaseUserInfo.userProfilePhotoUrl ?? "",
      }));
}

Future<void> getCurrentUserInfo(
    String firebaseUID, FirebaseUserInfo userInfo) async {
  var url = Uri.parse(
      'https://fittrack-e5a63-default-rtdb.firebaseio.com/Users/${firebaseUID}.json?');
  final response = await http.get(url);
  final extractedData = json.decode(response.body) as Map<String, dynamic>;

  userInfo.userEmail = extractedData['userEmail'];
  userInfo.userName = extractedData['userName'];
  userInfo.userProfilePhotoUrl = extractedData['userProfilePhotoUrl'];
}
