import 'package:flutter/material.dart';
import 'package:flutter_app/pages/course.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth_helper.dart';

import 'package:shared_preferences/shared_preferences.dart';

Future<List<Course>> getCourses(int page, BuildContext context, AuthService _authService) async {
  String url = 'https://802b-103-107-92-82.ngrok-free.app/home_page?page=$page';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token');
  if (token == null) {
    throw Exception('No token found');
  }
  final response = await http.get(Uri.parse(url), headers: {"Authorization": "Bearer $token"});
  var responseData = json.decode(response.body);
  _authService.handleApiResponse(response, context);
  List<Course> _courseList = [];
  if (responseData.containsKey('courses')) {
    var courseData = responseData['courses'];

    // Iterate through each course data and create Course objects
    for (var singleCourse in courseData) {
      Course course = Course(
        course_id: singleCourse["course_id"],
        course_name: singleCourse["course_name"],
        course_details: singleCourse["course_details"],
        duration: singleCourse["duration"],
        is_favorite: singleCourse["is_favorite"],
      );
      _courseList.add(course);
    }
  }
  return _courseList;
}
