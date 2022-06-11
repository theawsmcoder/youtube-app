import 'dart:convert';

class Channel {
  String title;
  String id;
  String thumbnailUrl;
  String description;

  String viewCount;
  String subCount;
  String videoCount;

  Channel({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.description,
    required this.viewCount,
    required this.subCount,
    required this.videoCount,
  });

  factory Channel.fromJson(String jsonStr) {
    Map jsonMap = json.decode(jsonStr);

    String id = jsonMap['items'][0]['id'];
    String title = jsonMap['items'][0]['snippet']['title'];
    String thumbnailUrl =
        jsonMap['items'][0]['snippet']['thumbnails']['default']['url'];
    String description = jsonMap['items'][0]['snippet']['description'];
    String viewCount = jsonMap['items'][0]['statistics']['viewCount'];
    String subCount = jsonMap['items'][0]['statistics']['subscriberCount'];
    String videoCount = jsonMap['items'][0]['statistics']['videoCount'];

    return Channel(
        id: id,
        title: title,
        thumbnailUrl: thumbnailUrl,
        description: description,
        viewCount: viewCount,
        subCount: subCount,
        videoCount: videoCount);
  }
}
