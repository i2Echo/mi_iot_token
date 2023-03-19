// To parse this JSON data, do
//
//     final miCloudGetDeviceListResponse = miCloudGetDeviceListResponseFromJson(jsonString);

// ignore_for_file: type_annotate_public_apis, prefer_typing_uninitialized_variables

import 'dart:convert';

class MiCloudResponse {
  MiCloudResponse({
    required this.code,
    required this.message,
    required this.result,
  });

  int code;
  String message;
  var result;

  MiCloudResponse copyWith({
    int? code,
    String? message,
    result,
  }) =>
      MiCloudResponse(
        code: code ?? this.code,
        message: message ?? this.message,
        result: result ?? this.result,
      );

  factory MiCloudResponse.fromRawJson(String str) =>
      MiCloudResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MiCloudResponse.fromJson(Map<String, dynamic> json) =>
      MiCloudResponse(
        code: json["code"],
        message: json["message"],
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "result": result,
      };
}
