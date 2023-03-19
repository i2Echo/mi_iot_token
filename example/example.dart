import 'dart:convert';
import 'dart:io';

import 'package:mi_iot_token/mi_iot_token.dart';

void main() async {
  MiCloud miCloud = MiCloud();
  var account = null;
  var deviceConfig = null;

  // your can find config example in config.example.json
  final configFile = File('./example/my_config.json');
  final jsonString = await configFile.readAsString();
  final dynamic jsonMap = jsonDecode(jsonString);

  account = jsonMap['account'];
  deviceConfig = jsonMap['device'];
  await miCloud.login(account["username"], account['password']);
  print("login success");

  // set region, if not sure, may be unset that.
  miCloud.setRegion('cn');
  // get mi cloud device list by device ids, if deviceIds is null, get all devices.
  var devices = await miCloud.getDevices();
  print(devices);

  // get a devices by device id
  var device = await miCloud.getDeviceData(deviceConfig['did']);
  print(device);

  // get device props
  var result = await miCloud.getMiotProps(deviceConfig['getProps']);
  print(result);

  // set device props
  var setResult = await miCloud.setMiotProps(deviceConfig['setProps']);
  print(setResult);

  // call device action
  var actionResult = await miCloud.miotAction(deviceConfig['action']);
  print(actionResult);
}
