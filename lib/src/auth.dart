import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class Auth {
  String loginUrl = 'https://account.xiaomi.com/pass/serviceLoginAuth2';

  getPasswordHash(password) {
    return md5
        .convert(new Utf8Encoder().convert(password))
        .toString()
        .toUpperCase();
  }

  login(login, password) async {
    Map<String, String> data = Map();
    data.putIfAbsent("sid", () => 'xiaomiio');
    data.putIfAbsent('hash', () => this.getPasswordHash(password));
    data.putIfAbsent('user', () => login);
    data.putIfAbsent('_json', () => 'true');

    var response = await http.post(Uri.parse(loginUrl), body: data);
    if (response.statusCode == 200) {
      var data = response.body.replaceAll("&&&START&&&", "");
      // print(data);
      Map<String, dynamic> map = json.decode(data);
      if (map["ssecurity"] == null || map["location"] == null) {
        throw "Can`t login";
      }
      var token = await getServiceToken(map["location"]);

      return {
        "ssecurity": map["ssecurity"],
        "token": token,
        "userId": map["userId"]
      };
    }
  }

  getServiceToken(String location) async {
    var token = null;
    var response = await http.get(Uri.parse(location));
    if (response.statusCode == 200) {
      var cookie = response.headers["set-cookie"];
      token = getCookieValue(cookie!, "serviceToken");
    }
    return token;
  }

  //String _decode(s) => Uri.decodeComponent(s.replaceAll(r"\+", ' '));

  getCookieValue(String cookie, String key) {
    // print(cookie);
    var cookies = cookie.split('; ');
    for (var i = 0, l = cookies.length; i < l; i++) {
      var parts = cookies[i].split(',');
      if (parts.length > 1 && parts[1].indexOf(key + "=") > -1) {
        return parts[1].replaceAll(key + "=", "");
      }
    }
  }
}
