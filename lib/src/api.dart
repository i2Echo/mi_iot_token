import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class Api {
  String apiUrl = 'https://api.io.mi.com/app';
  List allowCounty = ["", "ru", "us", "tw", "sg", "cn", "de", "in", "i2"];

  Api(country) {
    this.apiUrl = this.getApiUrl(country);
  }

  getApiUrl(country) {
    if (this.allowCounty.firstWhere((o) => o == country) == false) {
      throw 'Country is not allow';
    }

    var countryDomain = country != null
        ? country == 'cn'
            ? ''
            : country + '.'
        : '';

    return "https://${countryDomain}api.io.mi.com/app";
  }

  generateNonce(security) {
    var nonceBytes = _randomBytes(12);
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

  generateSignature(uri, signedNonce, nonce, data) {
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

  getDeviceList(userId, security, token, country) async {
    var url = country == null ? this.apiUrl : this.getApiUrl(country);

    var nonceMap = this.generateNonce(security);
    var data = {"getVirtualModel": false, "getHuamiDevices": 0};

    var action = '/home/device_list';
    var signature = this.generateSignature(
        action, nonceMap["signedNonce"], nonceMap["nonce"], data);

    Map<String, String> body = Map();
    body.putIfAbsent("_nonce", () => nonceMap["nonce"]);
    body.putIfAbsent('signature', () => signature);
    body.putIfAbsent('data', () => json.encode(data));

    Map<String, String> headers = Map();
    headers.putIfAbsent("x-xiaomi-protocal-flag-cli", () => "PROTOCAL-HTTP2");
    headers.putIfAbsent(
        "Cookie", () => "userId=${userId}; serviceToken=${token}");

    var response =
        await http.post(Uri.parse(url + action), headers: headers, body: body);
    if (response.statusCode == 200) {
      // print(response.body);
      return response.body;
    } else {
      throw response.body;
    }
  }

  Uint8List _randomBytes(int length, {bool secure = false}) {
    assert(length > 0);
    final random = secure ? Random.secure() : Random();
    Uint8List list = Uint8List(length);
    for (var i = 0; i < length; i++) {
      list[i] = random.nextInt(256);
    }
    return list;
  }
}
