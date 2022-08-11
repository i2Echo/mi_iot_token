import 'package:mi_iot_token/mi_iot_token.dart';

void main() async {
  var auth = Auth();
  var api = Api("cn"); // your country code
  var user = await auth.login(
      "your id or name", "password"); // your id or name and password

  var data = await api.getDeviceList(
      user["userId"], user["ssecurity"], user["token"], "cn");

  print(data);
}
