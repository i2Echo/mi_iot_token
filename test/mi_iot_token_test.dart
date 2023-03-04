import 'package:mi_iot_token/mi_iot_token.dart';
import 'package:test/test.dart';

void main() {
  // test("login", () async {
  //   var auth = Auth();
  //   await auth.login("your id or name", "your password");
  //   // expect(1, 1);
  // });

  // test("generateNonce", () async {
  //   var api = Api("cn");
  //   await api.generateNonce("WSqb+Xr8kwkTM9ZEysQseQ==");
  //   // expect(1, 1);
  // });

  test("getDevices", () async {
    var auth = Auth();
    var api = Api("cn");
    var user = await auth.login("your id or name", "your password");

    await api.getDeviceList(
        user["userId"], user["ssecurity"], user["token"], "cn");

    //expect(1, 1);
  });
}
