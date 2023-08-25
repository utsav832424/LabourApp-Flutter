import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiService with ChangeNotifier {
  final url = "http://89.116.229.150:3003/api";

  Future<Map<String, dynamic>> postCallWithOutToken(
      slug, Map<String, dynamic> param) async {
    try {
      log("${url}/${slug}, data: ${param}");
      var formData = FormData.fromMap(param);
      var response = await Dio().post('${url}/${slug}', data: formData);
      if (response.statusCode == 200) {
        var json = response.data;
        return json;
      } else {
        throw Exception(response);
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> postCall(
      slug, Map<String, dynamic> param) async {
    try {
      log("${url}/${slug}, data: ${param}");
      var formData = FormData.fromMap(param);
      var response = await Dio().post('${url}/${slug}', data: formData);
      if (response.statusCode == 200) {
        var json = response.data;
        return json;
      } else {
        throw Exception(response);
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> getcall(slug) async {
    try {
      log("${url}/${slug}");
      // var formData = FormData.fromMap(param);
      var response = await Dio().get('${url}/${slug}');
      if (response.statusCode == 200) {
        var json = response.data;
        return json;
      } else {
        throw Exception(response);
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> getCall(url) async {
    try {
      log("${url}");
      var response = await Dio().get('${url}');
      if (response.statusCode == 200) {
        var json = response.data;
        return json;
      } else {
        throw Exception(response);
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future getUserSuggestion(slug, Map<String, dynamic> param) async {
    try {
      log('${url}/${slug}, data: ${param}');
      var formData = FormData.fromMap(param);
      Response res = await Dio().post('${url}/${slug}', data: formData);
      if (res.statusCode == 200) {
        var json = res.data;
        return json['data'] == null ? [] : json['data'];
      } else {
        throw Exception(res);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
