import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:re_lms_crud/Models/models.dart';
import 'package:re_lms_crud/utilities/tokenManager.dart';

class LmsServiceApi {
  final baseUrl = 'https://api.portfoliobuilders.in/api/superadmin';
  Future<Map<String, dynamic>> loginAdmin(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return {
          'msgFromApi': responseData['message'],
          'token': responseData['token'],
        };
      } else {
        throw Exception('error');
      }
    } catch (e) {
      throw Exception('failed to login');
    }
  }

  Future<List<courseModel>> getCourse() async {
    final token = await Tokenmanager.getToken();
    print(token);
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/getAllCourses'),

        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        List<dynamic> body = responseData['courses'];
        List<courseModel> course =
            body.map((dynamic item) => courseModel.fromjson(item)).toList();
        //print('11111111111111');
        return course;
      } else {
        throw Exception('error');
      }
    } catch (e) {
      throw Exception('failed to load getApi');
    }
  }

  Future<String> createCourse(
    
    String title,
    String description,
    String startDate,
    String endDate,
  ) async {
    final token = await Tokenmanager.getToken();
    print('🟡 Sending course creation request...');

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/createCourse'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Required for JSON
        },
        body: jsonEncode({
          
          'title': title,
          'description': description,
          'startDate': startDate,
          'endDate': endDate,
        }),
      );
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('🟢 Course created successfully');
        return responseData['message'];
      } else {
        print('🔴 Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to create course: ${response.body}');
      }
    } catch (e) {
      print('🔴 Exception: $e');
      throw Exception('Failed to create course');
    }
  }

  Future<String> deleteCourse(courseId) async {
    final token = await Tokenmanager.getToken();
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/deleteCourse/$courseId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Required for JSON
        },
      );
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('🟢 Course Deleted successfully');
        return responseData['message'];
      } else {
        print('🔴 Error: ${response.statusCode} - ${response.body}');
        return responseData['message'];
      }
    } catch (e) {
      print('🔴 Exception: $e');
      throw Exception('Failed to Delete course');
    }
  }

  Future<String> UpdateCourse(
    int? courseId,
    String? title,
    String? description,
    String? startDate,
    String? endDate,
  ) async {
    final token = await Tokenmanager.getToken();
    try {
      print('11111111111');
      final response = await http.put(
        Uri.parse('$baseUrl/updateCourse/$courseId'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'courseId': courseId,
          'title': title,
          'description': description,
          'startDate': startDate,
          'endDate': endDate,
        }),
      );
      print('22222');
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('🟢 Course updated successfully');
        return responseData['message'];
      } else {
         print('🔴 Error: ${response.statusCode} - ${response.body}');
        return responseData['message'];
      }
    } catch (e) {
      print('🔴 Exception in update: $e');
      throw Exception('failed to update');
    }
  }
}
