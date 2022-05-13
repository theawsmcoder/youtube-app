import 'dart:convert';

class PlayerInfo {
  String title;
  double currentTime = 0.0;
  int? playerState;
  double duration;

  PlayerInfo({
    required this.title,
    required this.currentTime,
    required this.duration,
    this.playerState,
  });

  factory PlayerInfo.fromJson(String jsonStr) {
    Map jsonMap = json.decode(jsonStr.replaceAll("'", "\""));
    String title = jsonMap['title'];
    double currentTime = double.parse(jsonMap['currentTime']);
    double duration = double.parse(jsonMap['duration']);
    int playerState = int.parse(jsonMap['playerState']!);

    return PlayerInfo(
      title: title,
      currentTime: currentTime,
      duration: duration,
      playerState: playerState,
    );
  }

  @override
  String toString() =>
      '{"title": "$title", "currentTime": "$currentTime", "duration": "$duration", "playerState": "$playerState"}';
}
