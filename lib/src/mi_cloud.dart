import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:mi_iot_token/src/models/action_res.dart';
import 'package:mi_iot_token/src/models/device.dart';
import 'package:mi_iot_token/src/utils.dart';

import 'models/mi_cloud_res.dart';

class MiCloud {
  final String loginUrl = 'https://account.xiaomi.com/pass/serviceLoginAuth2';

  String apiUrl = 'https://api.io.mi.com/app';
  String region = 'cn';

  var userName = null;
  var password = null;
  var serviceToken = null;
  var userId = null;
  var security = null;
  var nonce = null;
  var signedNonce = null;

  final List allowCountry = ['ru', 'us', 'tw', 'sg', 'cn', 'de', 'in', 'i2'];

  // set your mi account region, if you don't have one, please use empty string represent all regions.
  setRegion(String rg) {
    if (this.allowCountry.firstWhere((o) => o == rg, orElse: () => null) ==
        null) {
      throw 'Country is not allow';
    }
    this.region = rg;
  }

  login(String userName, String password) async {
    if (this.isLoggedIn()) {
      throw 'You are already logged in with username ${this.userName}. Login not required!';
    }

    Map<String, String> data = Map();
    data.putIfAbsent("sid", () => 'xiaomiio');
    data.putIfAbsent('hash', () => Utils.convertToHash(password));
    data.putIfAbsent('user', () => userName);
    data.putIfAbsent('_json', () => 'true');

    var response = await http.post(Uri.parse(loginUrl), body: data);
    if (response.statusCode == 200) {
      var data = response.body.replaceAll("&&&START&&&", "");
      // print(data);
      Map<String, dynamic> map = json.decode(data);
      if (map["ssecurity"] == null || map["location"] == null) {
        throw "Can`t login";
      }
      var token = await _getServiceToken(map["location"]);

      var authTokens = {
        "security": map["ssecurity"],
        "serviceToken": token,
        "userId": map["userId"]
      };
      this.userName = userName;
      this.password = password;
      this._setServiceToken(authTokens);
    } else {
      throw response.body;
    }
  }

  isLoggedIn() {
    return !(serviceToken == null);
  }

  loginOut() {
    if (!this.isLoggedIn()) {
      throw 'You are not logged in! Cannot log out!';
    }
    this.serviceToken = null;
    this.userId = null;
    this.security = null;

    this.setRegion('cn');

    this.userName = null;
    this.password = null;
  }

  _setServiceToken(tokens) {
    this.serviceToken = tokens["serviceToken"];
    this.userId = tokens["userId"];
    this.security = tokens["security"];
  }

  _getServiceToken(String location) async {
    var token = null;
    var response = await http.get(Uri.parse(location));
    if (response.statusCode == 200) {
      var cookie = response.headers["set-cookie"];
      token = _getCookieValue(cookie!, "serviceToken");
    }
    return token;
  }

  refreshServiceToken() {
    this.security = null;
    this.userId = null;
    this.serviceToken = null;
    this.login(this.userName, this.password);
  }

  // get mi cloud device list, if deviceIds is null, get all devices
  Future<List<Device>> getDevices({List<String>? deviceIds}) async {
    var req = deviceIds != null
        ? {
            "dids": deviceIds,
          }
        : {
            "getVirtualModel": false,
            "getHuamiDevices": 0,
          };
    const deviceListPath = "/home/device_list";
    var result = await this._requestWithEncryption(deviceListPath, req);
    var list = result['list'].map<Device>((o) => Device.fromJson(o)).toList();
    return list;
  }

  Future<Device> getDeviceData(String did) async {
    var req = {
      "dids": [did],
    };
    const deviceDataPath = "/home/device_list";
    var result = await this._requestWithEncryption(deviceDataPath, req);
    if (result['list'].length == 0 || result['list'][0] == null) {
      throw 'Device not found';
    }
    var deviceData = Device.fromJson(result['list'][0]);
    return deviceData;
  }

  getMiotProps(params) async {
    var req = {
      "params": params,
    };
    var data = await this._requestWithEncryption('/miotspec/prop/get', req);
    // var result = ActionResData.fromJson(data);
    return data;
  }

  setMiotProps(params) async {
    var req = {
      "params": params,
    };
    var data = await this._requestWithEncryption('/miotspec/prop/set', req);
    // var result = ActionResData.fromJson(data);
    return data;
  }

  miotAction(params) async {
    var req = {
      "params": params,
    };
    var data = await this._requestWithEncryption('/miotspec/action', req);
    var result = ActionResData.fromJson(data);
    return result;
  }

  _requestWithEncryption(String path, data) async {
    if (!this.isLoggedIn()) {
      throw 'Please login first!';
    }
    var nonceMap = this._generateNonce(security);
    var signature = this._generateSignature(
        path, nonceMap["signedNonce"], nonceMap["nonce"], data);

    Map<String, String> body = Map();
    body.putIfAbsent("_nonce", () => nonceMap["nonce"]);
    body.putIfAbsent('signature', () => signature);
    body.putIfAbsent('data', () => json.encode(data));

    Map<String, String> headers = Map();
    headers.putIfAbsent("x-xiaomi-protocal-flag-cli", () => "PROTOCAL-HTTP2");
    headers.putIfAbsent("Cookie",
        () => "userId=${this.userId}; serviceToken=${this.serviceToken}");
    String url = this._getApiUrl(this.region) + path;
    var response =
        await http.post(Uri.parse(url), headers: headers, body: body);
    if (response.statusCode == 200) {
      // print(response.body);
      var res = MiCloudResponse.fromRawJson(response.body);
      if (res.message == "ok") {
        return res.result;
      } else {
        throw res.message;
      }
    } else {
      throw response.body;
    }
  }

  static _getCookieValue(String cookie, String key) {
    // print(cookie);
    var cookies = cookie.split('; ');
    for (var i = 0, l = cookies.length; i < l; i++) {
      var parts = cookies[i].split(',');
      if (parts.length > 1 && parts[1].indexOf(key + "=") > -1) {
        return parts[1].replaceAll(key + "=", "");
      }
    }
  }

  _getApiUrl(String country) {
    country = country != null ? country.toLowerCase() : '';

    String countryDomain = country == 'cn' ? '' : country + '.';

    return "https://${countryDomain}api.io.mi.com/app";
  }

  _generateNonce(security) {
    var nonceBytes = Utils.randomBytes(12);
    // print(nonceBytes);
    var securityBytes = base64Decode(security);
    // print(securityBytes);
    List<int> value = [];
    value.addAll(securityBytes);
    value.addAll(nonceBytes);

    var nonce = base64Encode(nonceBytes);
    var signedNonce = base64.encode(sha256.convert(value).bytes);

    // print(nonce);
    // print(signedNonce);

    return {"nonce": nonce, "signedNonce": signedNonce};
  }

  _generateSignature(uri, signedNonce, nonce, data) {
    var signatureParams = [
      uri,
      signedNonce,
      nonce,
      "data=" + json.encode(data)
    ];
    var signedString = signatureParams.join('&');

    List<int> messageBytes = utf8.encode(signedString);
    List<int> key = base64.decode(signedNonce);
    Hmac hmac = new Hmac(sha256, key);
    Digest digest = hmac.convert(messageBytes);

    return base64.encode(digest.bytes);
  }
}
