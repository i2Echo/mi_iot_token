
A xiaomi iot token extractor.

[![pub package](https://img.shields.io/pub/v/mi_iot_token.svg)](https://pub.dev/packages/mi_iot_token)

## Features

You can login to your mi iot account by your id & password, and get device list. 

## Getting started
### Add dependency

```yaml
dependencies:
  mi_iot_token: ^0.0.2
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
## License

Released under the [MIT](https://kujohnln.mit-license.org) License.