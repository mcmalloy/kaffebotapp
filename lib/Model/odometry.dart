
class Odometry{
  double linearVelocity;
  double turnVelocity;

  Odometry(this.linearVelocity, this.turnVelocity) {
    this.linearVelocity = linearVelocity;
    this.turnVelocity = turnVelocity;

  }

  Odometry.fromJson(Map<String, dynamic> json)
      : linearVelocity = json['velocity'] as double,
        turnVelocity = json['rotation'] as double;

}