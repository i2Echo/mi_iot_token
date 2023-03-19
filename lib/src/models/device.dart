import 'dart:convert';

class Device {
  Device({
    required this.did,
    required this.token,
    required this.longitude,
    required this.latitude,
    required this.name,
    required this.pid,
    required this.localip,
    required this.mac,
    required this.ssid,
    required this.bssid,
    required this.parentId,
    required this.parentModel,
    required this.showMode,
    required this.model,
    required this.adminFlag,
    required this.shareFlag,
    required this.permitLevel,
    required this.isOnline,
    required this.desc,
    required this.extra,
    required this.uid,
    required this.pdId,
    required this.password,
    required this.p2PId,
    required this.rssi,
    required this.familyId,
    required this.resetFlag,
  });

  String did;
  String token;
  String longitude;
  String latitude;
  String name;
  String pid;
  String localip;
  String mac;
  String ssid;
  String bssid;
  String parentId;
  String parentModel;
  int showMode;
  String model;
  int adminFlag;
  int shareFlag;
  int permitLevel;
  bool isOnline;
  String desc;
  DeviceExtra extra;
  int uid;
  int pdId;
  String password;
  String p2PId;
  int rssi;
  int familyId;
  int resetFlag;

  Device copyWith({
    String? did,
    String? token,
    String? longitude,
    String? latitude,
    String? name,
    String? pid,
    String? localip,
    String? mac,
    String? ssid,
    String? bssid,
    String? parentId,
    String? parentModel,
    int? showMode,
    String? model,
    int? adminFlag,
    int? shareFlag,
    int? permitLevel,
    bool? isOnline,
    String? desc,
    DeviceExtra? extra,
    int? uid,
    int? pdId,
    String? password,
    String? p2PId,
    int? rssi,
    int? familyId,
    int? resetFlag,
  }) =>
      Device(
        did: did ?? this.did,
        token: token ?? this.token,
        longitude: longitude ?? this.longitude,
        latitude: latitude ?? this.latitude,
        name: name ?? this.name,
        pid: pid ?? this.pid,
        localip: localip ?? this.localip,
        mac: mac ?? this.mac,
        ssid: ssid ?? this.ssid,
        bssid: bssid ?? this.bssid,
        parentId: parentId ?? this.parentId,
        parentModel: parentModel ?? this.parentModel,
        showMode: showMode ?? this.showMode,
        model: model ?? this.model,
        adminFlag: adminFlag ?? this.adminFlag,
        shareFlag: shareFlag ?? this.shareFlag,
        permitLevel: permitLevel ?? this.permitLevel,
        isOnline: isOnline ?? this.isOnline,
        desc: desc ?? this.desc,
        extra: extra ?? this.extra,
        uid: uid ?? this.uid,
        pdId: pdId ?? this.pdId,
        password: password ?? this.password,
        p2PId: p2PId ?? this.p2PId,
        rssi: rssi ?? this.rssi,
        familyId: familyId ?? this.familyId,
        resetFlag: resetFlag ?? this.resetFlag,
      );

  factory Device.fromRawJson(String str) => Device.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Device.fromJson(Map<String, dynamic> json) => Device(
        did: json["did"],
        token: json["token"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        name: json["name"],
        pid: json["pid"],
        localip: json["localip"],
        mac: json["mac"],
        ssid: json["ssid"],
        bssid: json["bssid"],
        parentId: json["parent_id"],
        parentModel: json["parent_model"],
        showMode: json["show_mode"],
        model: json["model"],
        adminFlag: json["adminFlag"],
        shareFlag: json["shareFlag"],
        permitLevel: json["permitLevel"],
        isOnline: json["isOnline"],
        desc: json["desc"],
        extra: DeviceExtra.fromJson(json["extra"]),
        uid: json["uid"],
        pdId: json["pd_id"],
        password: json["password"],
        p2PId: json["p2p_id"],
        rssi: json["rssi"],
        familyId: json["family_id"],
        resetFlag: json["reset_flag"],
      );

  Map<String, dynamic> toJson() => {
        "did": did,
        "token": token,
        "longitude": longitude,
        "latitude": latitude,
        "name": name,
        "pid": pid,
        "localip": localip,
        "mac": mac,
        "ssid": ssid,
        "bssid": bssid,
        "parent_id": parentId,
        "parent_model": parentModel,
        "show_mode": showMode,
        "model": model,
        "adminFlag": adminFlag,
        "shareFlag": shareFlag,
        "permitLevel": permitLevel,
        "isOnline": isOnline,
        "desc": desc,
        "extra": extra.toJson(),
        "uid": uid,
        "pd_id": pdId,
        "password": password,
        "p2p_id": p2PId,
        "rssi": rssi,
        "family_id": familyId,
        "reset_flag": resetFlag,
      };
}

class DeviceExtra {
  DeviceExtra({
    required this.isSetPincode,
    required this.pincodeType,
    this.platform,
    this.fwVersion,
    this.needVerifyCode,
    this.isPasswordEncrypt,
    this.mcuVersion,
  });

  int isSetPincode;
  int pincodeType;
  String? platform;
  String? fwVersion;
  int? needVerifyCode;
  int? isPasswordEncrypt;
  String? mcuVersion;

  DeviceExtra copyWith({
    int? isSetPincode,
    int? pincodeType,
    String? platform,
    String? fwVersion,
    int? needVerifyCode,
    int? isPasswordEncrypt,
    String? mcuVersion,
  }) =>
      DeviceExtra(
        isSetPincode: isSetPincode ?? this.isSetPincode,
        pincodeType: pincodeType ?? this.pincodeType,
        platform: platform ?? this.platform,
        fwVersion: fwVersion ?? this.fwVersion,
        needVerifyCode: needVerifyCode ?? this.needVerifyCode,
        isPasswordEncrypt: isPasswordEncrypt ?? this.isPasswordEncrypt,
        mcuVersion: mcuVersion ?? this.mcuVersion,
      );

  factory DeviceExtra.fromRawJson(String str) =>
      DeviceExtra.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DeviceExtra.fromJson(Map<String, dynamic> json) => DeviceExtra(
        isSetPincode: json["isSetPincode"],
        pincodeType: json["pincodeType"],
        platform: json["platform"],
        fwVersion: json["fw_version"],
        needVerifyCode: json["needVerifyCode"],
        isPasswordEncrypt: json["isPasswordEncrypt"],
        mcuVersion: json["mcu_version"],
      );

  Map<String, dynamic> toJson() => {
        "isSetPincode": isSetPincode,
        "pincodeType": pincodeType,
        "platform": platform,
        "fw_version": fwVersion,
        "needVerifyCode": needVerifyCode,
        "isPasswordEncrypt": isPasswordEncrypt,
        "mcu_version": mcuVersion,
      };
}
