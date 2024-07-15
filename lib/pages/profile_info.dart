import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'UserPages/profile_page.dart';
import 'auth_helper.dart';

Future<Profile> getProfile(BuildContext context, AuthService _authService) async {
  String url = 'https://802b-103-107-92-82.ngrok-free.app/profile';
  final prefs = await SharedPreferences.getInstance();

  String? token = prefs.getString('access_token');
  if (token == null) {
    throw Exception('No token found');
  }
  final response = await http.get(Uri.parse(url), headers: {'Authorization' : 'Bearer $token'});
  var responseData = json.decode(response.body);
  _authService.handleApiResponse(response, context);
  if (response.statusCode == 200) {
    Profile userProfile = Profile.fromJson(responseData);
    await SharedPreferences.getInstance();
    prefs.setString('user_name', userProfile.name);
  }
  Profile userProfile = Profile.fromJson(responseData);
  return userProfile;

}