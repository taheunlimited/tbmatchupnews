import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ClientInternetApi{
  static const String _baseUrl = 'http://45.149.187.204:3000/api'; // 🔁 GANTI dengan base URL baru kamu

  // 🔐 TOKEN MANAGEMENT ---------------------------
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // 🌐 GENERAL REQUESTS ---------------------------
  static Future<http.Response> get(String endpoint, {Map<String, String>? headers}) async {
    final token = await getToken();
    final defaultHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?headers,
    };

    final url = Uri.parse('$_baseUrl$endpoint');
    print(url);
    return await http.get(url, headers: defaultHeaders);
  }

  static Future<http.Response> post(String endpoint, Map<String, dynamic> body,
      {Map<String, String>? headers}) async {
    final token = await getToken();
    final defaultHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?headers,
    };

    final url = Uri.parse('$_baseUrl$endpoint');
    return await http.post(url, headers: defaultHeaders, body: jsonEncode(body));
  }

  static Future<http.Response> put(String endpoint, Map<String, dynamic> body,
      {Map<String, String>? headers}) async {
    final token = await getToken();
    final defaultHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?headers,
    };

    final url = Uri.parse('$_baseUrl$endpoint');
    return await http.put(url, headers: defaultHeaders, body: jsonEncode(body));
  }

  static Future<http.Response> delete(String endpoint, {Map<String, String>? headers}) async {
    final token = await getToken();
    final defaultHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?headers,
    };

    final url = Uri.parse('$_baseUrl$endpoint');
    return await http.delete(url, headers: defaultHeaders);
  }

  static Map<String,dynamic> parseResponse(http.Response response){
    final json = jsonDecode(response.body);
    return json['body'];
  }

  // 🔐 LOGIN
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await post('/auth/login', {
      'email': email,
      'password': password,
    });

    final data = parseResponse(response);
    if (response.statusCode == 200 && data['success'] == true) {
      await saveToken(data['data']['token']);
    }
    return data;
  }

  // 📝 REGISTER (opsional)
  static Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    final response = await post('/auth/register', userData);
    return parseResponse(response);
  }


  static Future<Map<String, dynamic>> getNews() async {
    final response = await get('/news');
    return parseResponse(response);
  }

  static Future<Map<String, dynamic>> detailNews(String slug) async {
    final response = await get('/news/${slug}');
    return parseResponse(response);
  }

  static Future<Map<String, dynamic>> postNews(Map<String, dynamic> body) async {
    final response = await post('/author/news', body);
    return parseResponse(response);
  }

  static Future<Map<String, dynamic>> putNews(String Id, Map<String, dynamic> body) async {
    final response = await put('/author/news/${Id}', body);
    return parseResponse(response);
  }

  static Future<Map<String, dynamic>> deleteNews(String Id) async {
    final response = await delete('/author/news/${Id}');
    return parseResponse(response);
  }
  
}

