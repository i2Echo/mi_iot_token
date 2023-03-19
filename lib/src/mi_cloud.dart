// ignore_for_file: avoid_dynamic_calls, join_return_with_assignment

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:mi_iot_token/src/models/action_res.dart';
import 'package:mi_iot_token/src/models/device.dart';
import 'package:mi_iot_token/src/models/mi_cloud_res.dart';
import 'package:mi_iot_token/src/utils.dart';

class MiCloud {
  final String loginUrl = 'https://account.xiaomi.com/pass/serviceLoginAuth2';

  String apiUrl = 'https://api.io.mi.com/app';
  String region = 'cn';

  String userName = '';
  String password = '';
  String serviceToken = '';
  int userId = 0;
  String security = '';
  String nonce = '';
  String signedNonce = '';

  final List allowCountry = ['ru', 'us', 'tw', 'sg', 'cn', 'de', 'in', 'i2'];

  // set your mi account region, if you don't have one, please use empty string represent all regions.
  void setRegion(String rg) {
    // ignore: parameter_assignments
    rg = rg.toLowerCase();
    if (allowCountry.firstWhere((o) => o == rg, orElse: () => null) == null) {
      throw 'Country is not allow';
    }
    region = rg;
  }

  Future login(String userName, String password) async {
    if (isLoggedIn()) {
      throw 'You are already logged in with username ${this.userName}. Login not required!';
    }

    final Map<String, String> data = {};
    data.putIfAbsent("sid", () => 'xiaomiio');
    data.putIfAbsent('hash', () => convertToHash(password));
    data.putIfAbsent('user', () => userName);
    data.putIfAbsent('_json', () => 'true');

    final response = await http.post(Uri.parse(loginUrl), body: data);
    if (response.statusCode == 200) {
      final data = response.body.replaceAll("&&&START&&&", "");
      // print(data);
      final Map<String, dynamic> map = json.decode(data);
      if (map["ssecurity"] == null || map["location"] == null) {
        throw "Can`t login";
      }
      final token = await _getServiceToken(map["location"]);

      final authTokens = {
        "security": map["ssecurity"],
        "serviceToken": token,
        "userId": map["userId"]
      };
      this.userName = userName;
      this.password = password;
      _setServiceToken(authTokens);
    } else {
      throw response.body;
    }
  }

  bool isLoggedIn() {
    return serviceToken.isNotEmpty;
  }

  void loginOut() {
    if (!isLoggedIn()) {
      throw 'You are not logged in! Cannot log out!';
    }
    serviceToken = '';
    userId = 0;
    security = '';

    setRegion('cn');

    userName = "";
    password = "";
  }

  void _setServiceToken(tokens) {
    serviceToken = tokens["serviceToken"];
    userId = tokens["userId"];
    security = tokens["security"];
  }

  Future _getServiceToken(String location) async {
    String token;
    final response = await http.get(Uri.parse(location));
    if (response.statusCode == 200) {
      final cookie = response.headers["set-cookie"];
      token = _getCookieValue(cookie!, "serviceToken");
      return token;
    } else {
      throw response.body;
    }
  }

  void refreshServiceToken() {
    security = "";
    userId = 0;
    serviceToken = "";

    if (userName.isNotEmpty && password.isNotEmpty) {
      login(userName, password);
    } else {
      throw 'Please login first!';
    }
  }

  // get mi cloud device list, if deviceIds is null, get all devices
  Future<List<Device>> getDevices({List<String>? deviceIds}) async {
    final req = deviceIds != null
        ? {
            "dids": deviceIds,
          }
        : {
            "getVirtualModel": false,
            "getHuamiDevices": 0,
          };
    const deviceListPath = "/home/device_list";
    final result = await _requestWithEncryption(deviceListPath, req);
    final List<Device> list =
        result['list'].map<Device>((o) => Device.fromJson(o)).toList();
    return list;
  }

  Future<Device> getDeviceData(String did) async {
    final req = {
      "dids": [did],
    };
    const deviceDataPath = "/home/device_list";
    final result = await _requestWithEncryption(deviceDataPath, req);
    if (result['list'].length == 0 || result['list'][0] == null) {
      throw 'Device not found';
    }
    final deviceData = Device.fromJson(result['list'][0]);
    return deviceData;
  }

  // ignore: type_annotate_public_apis
  Future getMiotProps(params) async {
    final req = {
      "params": params,
    };
    final data = await _requestWithEncryption('/miotspec/prop/get', req);
    // var result = ActionResData.fromJson(data);
    return data;
  }

  // ignore: type_annotate_public_apis
  Future setMiotProps(params) async {
    final req = {
      "params": params,
    };
    final data = await _requestWithEncryption('/miotspec/prop/set', req);
    // var result = ActionResData.fromJson(data);
    return data;
  }

  // ignore: type_annotate_public_apis
  Future<ActionResData> miotAction(params) async {
    final req = {
      "params": params,
    };
    final data = await _requestWithEncryption('/miotspec/action', req);
    final result = ActionResData.fromJson(data);
    return result;
  }

  Future _requestWithEncryption(String path, data) async {
    if (!isLoggedIn()) {
      throw 'Please login first!';
    }
    final nonceMap = _generateNonce(security);
    final signature = _generateSignature(
      path,
      nonceMap["signedNonce"],
      nonceMap["nonce"],
      data,
    );

    final Map<String, String> body = {};
    // ignore: cast_nullable_to_non_nullable
    body.putIfAbsent("_nonce", () => nonceMap["nonce"] as String);
    body.putIfAbsent('signature', () => signature);
    body.putIfAbsent('data', () => json.encode(data));

    final Map<String, String> headers = {};
    headers.putIfAbsent("x-xiaomi-protocal-flag-cli", () => "PROTOCAL-HTTP2");
    headers.putIfAbsent(
      "Cookie",
      () => "userId=${userId.toString()}; serviceToken=$serviceToken",
    );
    final url = _getApiUrl() + path;
    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);
    if (response.statusCode == 200) {
      // print(response.body);
      final res = MiCloudResponse.fromRawJson(response.body);
      if (res.message == "ok") {
        return res.result;
      } else {
        throw res.message;
      }
    } else {
      throw response.body;
    }
  }

  static String _getCookieValue(String cookie, String key) {
    // print(cookie);
    final cookies = cookie.split('; ');
    for (var i = 0; i < cookies.length; i++) {
      final parts = cookies[i].split(',');
      if (parts.length > 1 && parts[1].contains("$key=")) {
        return parts[1].replaceAll("$key=", "");
      }
    }
    throw 'Cookie not found';
  }

  String _getApiUrl() {
    final String regionDomain = region == 'cn' ? '' : '$region.';

    return "https://${regionDomain}api.io.mi.com/app";
  }

  Map<String, String> _generateNonce(String security) {
    final nonceBytes = randomBytes(12);
    // print(nonceBytes);
    final securityBytes = base64Decode(security);
    // print(securityBytes);
    final List<int> value = [];
    value.addAll(securityBytes);
    value.addAll(nonceBytes);

    final nonce = base64Encode(nonceBytes);
    final signedNonce = base64.encode(sha256.convert(value).bytes);

    // print(nonce);
    // print(signedNonce);

    return {"nonce": nonce, "signedNonce": signedNonce};
  }

  String _generateSignature(uri, signedNonce, nonce, data) {
    final signatureParams = [
      uri,
      signedNonce,
      nonce,
      "data=${json.encode(data)}"
    ];
    final signedString = signatureParams.join('&');

    final List<int> messageBytes = utf8.encode(signedString);
    final List<int> key = base64.decode(signedNonce);
    final Hmac hmac = Hmac(sha256, key);
    final Digest digest = hmac.convert(messageBytes);

    return base64.encode(digest.bytes);
  }
}
