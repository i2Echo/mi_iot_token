
A xiaomi iot token extractor and device controller for dart.

[![pub package](https://img.shields.io/pub/v/mi_iot_token.svg)](https://pub.dev/packages/mi_iot_token)

## Features
Your can control your xiaomi devices by this package.

* Get xiaomi cloud iot token by username and password.
* Get device list.
* Get device properties.
* Set device properties.
* Call device action.

## Getting started
### Add dependency

```yaml
dependencies:
  mi_iot_token: ^1.0.0
```

## Usage

```dart
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
```

### Device spec reference
* [Official miot spec](https://home.miot-spec.com/)

* [Official doc](https://iot.mi.com/new/doc/accesses/direct-access/other-platform-access/control-api#%E5%9F%BA%E7%A1%80%E6%A6%82%E5%BF%B5)

* [A miotspec metadata fetcher](https://www.merdok.org/miotspec/)

### regions (Unverified)
If your not sure which region to use, you can try to unset it.

Here are the two-letter codes for all countries or region(case-insensitive):

- Afghanistan: AF
- Albania: AL
- Algeria: DZ
- American Samoa: AS
- Andorra: AD
- Angola: AO
- Anguilla: AI
- Antarctica: AQ
- Antigua and Barbuda: AG
- Argentina: AR
- Armenia: AM
- Aruba: AW
- Australia: AU
- Austria: AT
- Azerbaijan: AZ
- Bahamas: BS
- Bahrain: BH
- Bangladesh: BD
- Barbados: BB
- Belarus: BY
- Belgium: BE
- Belize: BZ
- Benin: BJ
- Bermuda: BM
- Bhutan: BT
- Bolivia: BO
- Bosnia and Herzegovina: BA
- Botswana: BW
- Bouvet Island: BV
- Brazil: BR
- British Indian Ocean Territory: IO
- Brunei Darussalam: BN
- Bulgaria: BG
- Burkina Faso: BF
- Burundi: BI
- Cambodia: KH
- Cameroon: CM
- Canada: CA
- Cape Verde: CV
- Cayman Islands: KY
- Central African Republic: CF
- Chad: TD
- Chile: CL
- China: CN
- Christmas Island: CX
- Cocos (Keeling) Islands: CC
- Colombia: CO
- Comoros: KM
- Congo: CG
- Congo, the Democratic Republic of the: CD
- Cook Islands: CK
- Costa Rica: CR
- Cote d'Ivoire: CI
- Croatia: HR
- Cuba: CU
- Cyprus: CY
- Czech Republic: CZ
- Denmark: DK
- Djibouti: DJ
- Dominica: DM
- Dominican Republic: DO
- Ecuador: EC
- Egypt: EG
- El Salvador: SV
- Equatorial Guinea: GQ
- Eritrea: ER
- Estonia: EE
- Ethiopia: ET
- Falkland Islands (Malvinas): FK
- Faroe Islands: FO
- Fiji: FJ
- Finland: FI
- France: FR
- French Guiana: GF
- French Polynesia: PF
- French Southern Territories: TF
- Gabon: GA
- Gambia: GM
- Georgia: GE
- Germany: DE
- Ghana: GH
- Gibraltar: GI
- Greece: GR
- Greenland: GL
- Grenada: GD
- Guadeloupe: GP
- Guam: GU
- Guatemala: GT
- Guernsey: GG
- Guinea: GN
- Guinea-Bissau: GW
- Guyana: GY
- Haiti: HT
- Heard Island and McDonald Islands: HM
- Holy See (Vatican City State): VA
- Honduras: HN
- Hong Kong: HK
- Hungary: HU
- Iceland: IS
- India: IN
- Indonesia: ID
- Iran, Islamic Republic of: IR
- Iraq: IQ
- Ireland: IE
- Isle of Man: IM
- Israel: IL
- Italy: IT
- Jamaica: JM
- Japan: JP
- Jersey: JE
- Jordan: JO
- Kazakhstan: KZ
- Kenya: KE
- Kiribati: KI
- Korea, Democratic People's Republic of: KP
- Korea, Republic of: KR
- Kuwait: KW
- Kyrgyzstan: KG
- Lao People's Democratic Republic: LA
- Latvia: LV
- Lebanon: LB
- Lesotho: LS
- Liberia: LR
- Libyan Arab Jamahiriya: LY
- Liechtenstein: LI
- Lithuania: LT
- Luxembourg: LU
- Macao: MO
- Macedonia, the former Yugoslav Republic of: MK
- Madagascar: MG
- Malawi: MW
- Malaysia: MY
- Maldives: MV
- Mali: ML
- Malta: MT
- Marshall Islands: MH
- Martinique: MQ
- Mauritania: MR
- Mauritius: MU
- Mayotte: YT
- Mexico: MX
- Micronesia, Federated States of: FM
- Moldova, Republic of: MD
- Monaco: MC
- Mongolia: MN
- Montenegro: ME
- Montserrat: MS
- Morocco: MA
- Mozambique: MZ
- Myanmar: MM
- Namibia: NA
- Nauru: NR
- Nepal: NP
- Netherlands: NL
- Netherlands Antilles: AN
- New Caledonia: NC
- New Zealand: NZ
- Nicaragua: NI
- Niger: NE
- Nigeria: NG
- Niue: NU
- Norfolk Island: NF
- Northern Mariana Islands: MP
- Norway: NO
- Oman: OM
- Pakistan: PK
- Palau: PW
- Palestinian Territory, Occupied: PS
- Panama: PA
- Papua New Guinea: PG
- Paraguay: PY
- Peru: PE
- Philippines: PH
- Pitcairn: PN
- Poland: PL
- Portugal: PT
- Puerto Rico: PR
- Qatar: QA
- Reunion: RE
- Romania: RO
- Russian Federation: RU
- Rwanda: RW
- Saint Barthelemy: BL
- Saint Helena: SH
- Saint Kitts and Nevis: KN
- Saint Lucia: LC
- Saint Martin (French part): MF
- Saint Pierre and Miquelon: PM
- Saint Vincent and the Grenadines: VC
- Samoa: WS
- San Marino: SM
- Sao Tome and Principe: ST
- Saudi Arabia: SA
- Senegal: SN
- Serbia: RS
- Seychelles: SC
- Sierra Leone: SL
- Singapore: SG
- Slovakia: SK
- Slovenia: SI
- Solomon Islands: SB
- Somalia: SO
- South Africa: ZA
- South Georgia and the South Sandwich Islands: GS
- Spain: ES
- Sri Lanka: LK
- Sudan: SD
- Suriname: SR
- Svalbard and Jan Mayen: SJ
- Swaziland: SZ
- Sweden: SE
- Switzerland: CH
- Syrian Arab Republic: SY
- Taiwan, Province of China: TW
- Tajikistan: TJ
- Tanzania, United Republic of: TZ
- Thailand: TH
- Timor-Leste: TL
- Togo: TG
- Tokelau: TK
- Tonga: TO
- Trinidad and Tobago: TT
- Tunisia: TN
- Turkey: TR
- Turkmenistan: TM
- Turks and Caicos Islands: TC
- Tuvalu: TV
- Uganda: UG
- Ukraine: UA
- United Arab Emirates: AE
- United Kingdom: GB
- United States: US
- United States Minor Outlying Islands: UM
- Uruguay: UY
- Uzbekistan: UZ
- Vanuatu: VU
- Venezuela: VE
- Viet Nam: VN
- Virgin Islands, British: VG
- Virgin Islands, U.S.: VI
- Wallis and Futuna: WF
- Western Sahara: EH
- Yemen: YE
- Zambia: ZM
- Zimbabwe: ZW

## Thanks
This project was inspired by [homebridge-miot](https://github.com/merdok/homebridge-miot).
## License

Released under the [MIT](https://kujohnln.mit-license.org) License.