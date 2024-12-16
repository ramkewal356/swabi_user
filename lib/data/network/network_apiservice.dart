import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:dio/dio.dart' as dio;
import 'package:shared_preferences/shared_preferences.dart';
import '/data/app_excaptions.dart';

import 'base_apiservices.dart';

class NetworkApiService extends BaseApiServices {
  @override
  Future uploadImageHTTP(
    url,
    dynamic file,
  ) async {
    dynamic responseJson;
    try {
      var prefsToken = await SharedPreferences.getInstance();
      dynamic token = prefsToken.getString('token');
      Map<String, String> headers = {
        'Content-Type': 'multipart/form-data',
      };
      var request = http.MultipartRequest('PUT', Uri.parse(url))
        ..headers.addAll(headers)
        ..files.add(await http.MultipartFile.fromPath('image', file,
            contentType: MediaType("image", "jpg")));
      var response = await request.send();

      if (response.statusCode == 200) {
        responseJson = await response.stream.bytesToString();
      } else {
        throw UnauthorisedException(jsonEncode({"msg": "File upload error"}));
      }
    } on SocketException {
      throw FetchDataException('API Connection Error');
    }
    return jsonDecode(responseJson);
  }

  //    @override
  //     Future uploadImageHTTP2(
  //     url,
  //     dynamic file,
  //     ) async {
  //   dynamic responseJson;
  //   try {
  //     final prefsToken = await SharedPreferences.getInstance();
  //     dynamic token = prefsToken.getString('token');
  //     Map<String, String> headers = {
  //       'Content-Type': 'multipart/form-data',
  //       'token': token,
  //       // 'Content-Length':'<calculated when request is sent>',
  //       // 'Host':'<calculated when request is sent>'
  //     };
  //     var request = http.MultipartRequest('PUT', Uri.parse(url))
  //       ..headers.addAll(headers)
  //       ..files.add(await http.MultipartFile.fromPath('file', file,
  //           contentType: MediaType("image", "jpeg")));
  //     var response = await request.send();
  //
  //     if (response.statusCode == 200) {
  //       print("abc");
  //       responseJson = await response.stream.bytesToString();
  //     } else {
  //       print("xyz");
  //       print(response.statusCode);
  //       print(response.stream);
  //       print(response.reasonPhrase);
  //       throw UnauthorisedException(jsonEncode(response.reasonPhrase));
  //       // throw UnauthorisedException(jsonEncode({"msg": "File upload error"}));
  //     }
  //   } on SocketException {
  //     throw FetchDataException('API Connection Error');
  //   }
  //   return jsonDecode(responseJson);
  // }
  // @override
  // Future uploadImageHTTP2(String url, dynamic file) async
  // {
  //   dynamic responseJson;
  //   print("Yha Chla");
  //   try {
  //     final prefsToken = await SharedPreferences.getInstance();
  //     dynamic token = prefsToken.getString('token');
  //     Map<String, String> headers = {
  //       'Content-Type': 'multipart/form-data',
  //       'Postman-Token': token,
  //       'Content-Length': '<calculated when request is sent>',
  //       'Host': '<calculated when request is sent>',
  //     };
  //     print("Fir 2nd Yha Chla");
  //     var request = http.MultipartRequest('PUT', Uri.parse(url))
  //       ..headers.addAll(headers)
  //       ..fields.addAll({
  //
  //         // 'gm_uniqueid': gmUniqueId,
  //         // 'interaction': interaction,
  //         // 'message': message
  //       })
  //       ..files.add(await http.MultipartFile.fromPath('file', file.toString(),
  //           contentType: MediaType("image", "jpeg")));
  //     print("Phir 3rd Yha Chla");
  //     var response = await request.send();
  //     print("Phir 4th Yha Chla");
  //     if (response.statusCode == 200) {
  //       print("abc");
  //       responseJson = await response.stream.bytesToString();
  //     } else {
  //       print("xyz");
  //       print(response.statusCode);
  //       print(response.stream);
  //       print(response.reasonPhrase);
  //       throw UnauthorisedException(jsonEncode(response.reasonPhrase));
  //     }
  //   } on SocketException {
  //     throw FetchDataException('API Connection Error');
  //   }
  //   return jsonDecode(responseJson);
  //
  // }
  @override
  Future<dynamic> uploadImageHTTP2(
    String url,
    dynamic file,
    String userId,
  ) async {
    var prefsToken = await SharedPreferences.getInstance();
    dynamic token = prefsToken.getString('token');
    // print("token==$token");
    // print("1st Yha Chla");
    dynamic responseJson;
    // print("5th Yha Chla $responseJson");
    try {
      var formData = dio.FormData.fromMap({
        'userId': userId, // Ensure userId is a string as required by the server
        'image': await dio.MultipartFile.fromFile(
            file.path), // Using MultipartFile from dio
      });
      // print("Phir 2nd Yha Chla");
      var dioClient = dio.Dio();

      var response = await dioClient.put(
        url,
        data: formData,
        options: dio.Options(
          headers: {
            'Content-Type': 'multipart/form-data;>',
            'token': token.toString(),
            // 'Host': '<calculated when request is sent>',
            // 'User-Agent': 'PostmanRuntime/7.37.3',
            // 'Accept': '*/*',
            // 'Accept-Encoding': 'gzip, deflate, br',
            // 'Connection': 'keep-alive',
          },
        ),
      );
      // print("Phir 3rd Yha Chla");
      if (response.statusCode == 200) {
        // debugPrint(response.statusCode.toString());
        responseJson = response.data;
      } else if (response.statusCode == 413) {
        // debugPrint(response.statusCode.toString());
        throw BadRequestException(jsonEncode({'Request Entity Too Large'}));
      } else {
        // debugPrint(response.statusCode.toString());
        throw UnauthorisedException(jsonEncode({"msg": "File upload error"}));
      }
    } catch (e) {
      throw FetchDataException('API Connection Error: ${e.toString()}');
    }
    // print("Phir 4th Yha Chla");
    return responseJson;
  }

  @override
  Future getGetApiResponse(String url) async {
    var prefsToken = await SharedPreferences.getInstance();
    dynamic token = prefsToken.getString('token');
    // print("token==$token");
    dynamic responseJson;
    try {
      if (kDebugMode) {
        print(url);
      }
      final response = await http.get(Uri.parse(url), headers: {
        "token": token,
        "Content-Type": "application/json",
      }).timeout(const Duration(seconds: 120));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('API Connection Error');
    }
    return responseJson;
  }

  @override
  Future deleteApiResponse(String url) async {
    var prefsToken = await SharedPreferences.getInstance();
    dynamic token = prefsToken.getString('token');
    print("token==$token");
    dynamic responseJson;
    try {
      if (kDebugMode) {
        print(url);
      }
      final response = await http.delete(Uri.parse(url), headers: {
        "token": token,
        "Content-Type": "application/json",
      }).timeout(const Duration(seconds: 120));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('API Connection Error');
    }
    return responseJson;
  }

  @override
  Future getPostApiResponse(
    String url,
    dynamic data,
  ) async {
    var prefsToken = await SharedPreferences.getInstance();
    dynamic token = prefsToken.getString('token');
    dynamic responseJson;
    try {
      if (kDebugMode) {
        print(url);
      }
      Map<String, String> headerData = {
        "Content-Type": "application/json",
        "token": token,
      };
      Response response = await post(
        Uri.parse(url),
        headers: headerData,
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 120));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('API Connection Error');
    }

    return responseJson;
  }

  @override
  Future getPutApiResponseWithData(
    String url,
    dynamic data,
  ) async {
    var prefsToken = await SharedPreferences.getInstance();
    dynamic token = prefsToken.getString('token');
    dynamic responseJson;
    try {
      if (kDebugMode) {
        print("toekn is $token");
        print(url);
      }
      Map<String, String> headerData = {
        "Content-Type": "application/json",
        "token": token,
      };
      Response response = await put(
        Uri.parse(url),
        headers: headerData,
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 120));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('API Connection Error');
    }

    return responseJson;
  }

  ///getPutApiResponse
  @override
  Future getPutApiResponse(String url) async {
    var prefsToken = await SharedPreferences.getInstance();
    dynamic token = prefsToken.getString('token');
    dynamic responseJson;
    try {
      if (kDebugMode) {
        print(url);
      }
      final response = await http.put(Uri.parse(url), headers: {
        "token": token,
        "Content-Type": "application/json",
      }).timeout(const Duration(seconds: 120));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('API Connection Error');
    }
    return responseJson;
  }

  ///multi put function
  @override
  Future putSendMultiFormData(String url, Map<String, dynamic> data) async {
    var prefsToken = await SharedPreferences.getInstance();
    dynamic token = prefsToken.getString('token');
    dynamic responseJson;
    try {
      if (kDebugMode) {
        // print("token is $token");
        print(url);
      }
      var request = http.MultipartRequest('PUT', Uri.parse(url));
      request.headers['token'] = token;

      data.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      final response = await http.put(Uri.parse(url), headers: {
        "token": token,
        "Content-Type": "application/json",
      }).timeout(const Duration(seconds: 120));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('API Connection Error');
    }
    return responseJson;
  }

  ///patch Api response with data
  @override
  Future<dynamic> patchApiResponseWithData(
    String url,
    dynamic data,
  ) async {
    var prefsToken = await SharedPreferences.getInstance();
    dynamic token = prefsToken.getString('token');
    dynamic responseJson;
    try {
      if (kDebugMode) {
        print("token is $token");
        print(url);
      }
      Map<String, String> headerData = {
        "Content-Type": "application/json",
        "token": token,
      };
      Response response = await patch(
        Uri.parse(url),
        headers: headerData,
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 120));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('API Connection Error');
    }

    return responseJson;
  }

  //getstarted
  @override
  Future getPostWithoutApiResponse(
    String url,
    dynamic data,
  ) async {
    dynamic responseJson;
    try {
      Map<String, String> headerData = {
        "Content-Type": "application/json",
      };
      Response response = await post(
        Uri.parse(url),
        headers: headerData,
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 120));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('API Connection Error');
    }

    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        {
          dynamic responseJson = jsonDecode(response.body);
          return responseJson;
        }
      case 400:
        // {
        //   dynamic responseJson = jsonDecode(response.body);
        //   return responseJson;
        // }
        throw BadRequestException(
            jsonDecode(response.body)['status']['message']);
      case 413:
        throw BadRequestException('Request Entity Too Large');
      case 500:
        throw BadRequestException(
            jsonDecode(response.body)['status']['message']);
      case 404:
        throw UnauthorisedException(
            jsonDecode(response.body)['status']['message']);
      case 401:
        throw InvalidPermissionException(
            jsonDecode(response.body)['status']['message']);
      default:
        throw FetchDataException(
            'Error occurred while communicating with server with status code ${response.statusCode}');
    }
  }
}
