import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiCall {
  final String _baseUrl = "http://127.0.0.1:8000/";

  Future<dynamic> fetchTopBooks() async {
    var url = Uri.parse("${_baseUrl}top-books");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load top books');
    }
  }

  Future<dynamic> fetchBookText(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load book text');
    }
  }

}
