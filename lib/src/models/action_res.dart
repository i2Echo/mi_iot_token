import 'dart:convert';

class ActionResData {
  ActionResData({
    required this.did,
    required this.miid,
    required this.siid,
    required this.aiid,
    required this.code,
    required this.exeTime,
    required this.netCost,
    this.otCost,
    required this.otlocalts,
    required this.oaRpcCost,
    required this.withLatency,
  });

  String did;
  int miid;
  int siid;
  int aiid;
  int code;
  int exeTime;
  int netCost;
  int? otCost;
  int otlocalts;
  int oaRpcCost;
  int withLatency;

  ActionResData copyWith({
    String? did,
    int? miid,
    int? siid,
    int? aiid,
    int? code,
    int? exeTime,
    int? netCost,
    int? otCost,
    int? otlocalts,
    int? oaRpcCost,
    int? withLatency,
  }) =>
      ActionResData(
        did: did ?? this.did,
        miid: miid ?? this.miid,
        siid: siid ?? this.siid,
        aiid: aiid ?? this.aiid,
        code: code ?? this.code,
        exeTime: exeTime ?? this.exeTime,
        netCost: netCost ?? this.netCost,
        otCost: otCost ?? this.otCost,
        otlocalts: otlocalts ?? this.otlocalts,
        oaRpcCost: oaRpcCost ?? this.oaRpcCost,
        withLatency: withLatency ?? this.withLatency,
      );

  factory ActionResData.fromRawJson(String str) =>
      ActionResData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ActionResData.fromJson(Map<String, dynamic> json) => ActionResData(
        did: json["did"],
        miid: json["miid"],
        siid: json["siid"],
        aiid: json["aiid"],
        code: json["code"],
        exeTime: json["exe_time"],
        netCost: json["net_cost"],
        otCost: json["ot_cost"] ?? 0,
        otlocalts: json["otlocalts"],
        oaRpcCost: json["_oa_rpc_cost"],
        withLatency: json["withLatency"],
      );

  Map<String, dynamic> toJson() => {
        "did": did,
        "miid": miid,
        "siid": siid,
        "aiid": aiid,
        "code": code,
        "exe_time": exeTime,
        "net_cost": netCost,
        "ot_cost": otCost,
        "otlocalts": otlocalts,
        "_oa_rpc_cost": oaRpcCost,
        "withLatency": withLatency,
      };
}
