
import 'dart:io';

abstract class BaseApiServices {
  Future<dynamic> getGetApiResponse(String url);
  Future<dynamic> deleteApiResponse(String url);

  Future<dynamic> getPostApiResponse(String url, dynamic data);
  Future<dynamic> getPutApiResponse(String url);
  Future<dynamic> getPutApiResponseWithData(String url, dynamic data);
  Future<dynamic> putSendMultiFormData(String url, Map<String, dynamic> data);

  Future<dynamic> getPostWithoutApiResponse(String url, dynamic data);
  Future<dynamic> uploadImageHTTP(String url, dynamic data);
  Future<dynamic> uploadImageHTTP2(String url, File data, String userId);
  Future<dynamic> patchApiResponseWithData(String url, dynamic data);
  // Future<dynamic> uploadImageHTTP2(String url, String data, String uid);
}
