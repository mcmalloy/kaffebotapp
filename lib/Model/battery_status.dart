import 'dart:io';

class BatteryStatus {
  double batteryPercentage;
  double batteryVoltage;
  double batteryCurrent;

  BatteryStatus(
      this.batteryPercentage, this.batteryVoltage, this.batteryCurrent) {
    this.batteryPercentage = batteryPercentage;
    this.batteryVoltage = batteryVoltage;
    this.batteryCurrent = batteryCurrent;
  }

  BatteryStatus.fromJson(Map<String, dynamic> json)
      : batteryPercentage = json['batteryPercent'] as double,
        batteryVoltage = json['batteryVoltage'] as double,
        batteryCurrent = json['batteryCurrent'] as double;
}
