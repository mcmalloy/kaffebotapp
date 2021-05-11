import 'dart:io';

class BatteryStatus {
  double batteryCharge;
  double batteryCapacity;
  double batteryVoltage;
  double batteryCurrent;
  int batteryTemp;
  double batteryPercent;

  BatteryStatus(
      this.batteryCharge, this.batteryCapacity, this.batteryVoltage, this.batteryCurrent, this.batteryTemp, this.batteryPercent) {
    this.batteryCharge = batteryCharge;
    this.batteryCapacity = batteryCapacity;
    this.batteryVoltage = batteryVoltage;
    this.batteryCurrent = batteryCurrent;
    this.batteryTemp = batteryTemp;
    this.batteryPercent = batteryPercent;
  }

  BatteryStatus.fromJson(Map<String, dynamic> json)
      : batteryCharge = json['batteryCharge'] as double,
        batteryCapacity = json['batteryCapacity'] as double,
        batteryVoltage = json['batteryVoltage'] as double,
        batteryCurrent = json['batteryCurrent'] as double,
        batteryTemp = json['batteryTemp'] as int,
        batteryPercent = json['batteryPercent'] as double;
}
