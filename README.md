<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

A xiaomi iot device extractor.

## Features

You can login to your mi iot account by your id & password, and get device list. 

## Getting started
### Add dependency

```yaml
dependencies:
  mi_iot_token: ^0.0.1
```

## Usage

```dart
void main() async {
  var auth = Auth();
  var api = Api("cn"); // your country code
  var user = await auth.login(
      "your id or name", "password"); // your id or name and password

  var data = await api.getDeviceList(
      user["userId"], user["ssecurity"], user["token"], "cn");

  print(data);
}
```
