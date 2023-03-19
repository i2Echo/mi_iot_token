import 'dart:io';
import 'dart:convert';

import 'package:mi_iot_token/mi_iot_token.dart';
import 'package:test/test.dart';

void main() async {
  late MiCloud miCloud = MiCloud();
  var account = null;
  var deviceConfig = null;

  setUpAll(() async {
    final configFile = File(
        './example/my_config.json'); // your can find config example in config.example.json
    final jsonString = await configFile.readAsString();
    final dynamic jsonMap = jsonDecode(jsonString);

    account = jsonMap['account'];
    deviceConfig = jsonMap['device'];
    await miCloud.login(account["username"], account['password']);
    print("login success");
  });
  tearDownAll(() {
    miCloud.loginOut();
  });

  test("getDevices", () async {
    print(miCloud.serviceToken);
    expect(miCloud.isLoggedIn(), isTrue);
    var devices = await miCloud.getDevices();
    print(devices);
    // expect(1, 1);
  });

  test("getDeviceData", () async {
    expect(miCloud.isLoggedIn(), isTrue);
    var device = await miCloud.getDeviceData(deviceConfig['did']);
    print(device);
    // expect(1, 1);
  });

  test("getMiotProps", () async {
    expect(miCloud.isLoggedIn(), isTrue);
    var result = await miCloud.getMiotProps(deviceConfig['getProps']);
    print(result);
    // expect(1, 1);
  });
  test("setMiotProps", () async {
    expect(miCloud.isLoggedIn(), isTrue);
    var result = await miCloud.setMiotProps(deviceConfig['setProps']);
    print(result);
    // expect(1, 1);
  });
  test("miotAction", () async {
    expect(miCloud.isLoggedIn(), isTrue);
    var result = await miCloud.miotAction(deviceConfig['action']);
    print(result);
    // expect(1, 1);
  });
}
