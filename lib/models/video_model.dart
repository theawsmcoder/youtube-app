import 'dart:convert';

class Video {
  String id;
  String title;
  String channelId;
  String channelTitle;
  DateTime publishedAt;
  String description;

  String viewCount;
  String likeCount;
  String commentCount;

  Video({
    required this.id,
    required this.title,
    required this.channelId,
    required this.channelTitle,
    required this.description,
    required this.publishedAt,
    required this.viewCount,
    required this.likeCount,
    required this.commentCount,
  });

  factory Video.fromJson(String jsonStr) {
    Map jsonMap = json.decode(jsonStr);

    String id = jsonMap['items'][0]['id'];
    String title = jsonMap['items'][0]['snippet']['title'];
    String channelId = jsonMap['items'][0]['snippet']['channelId'];
    String channelTitle = jsonMap['items'][0]['snippet']['channelTitle'];
    String description = jsonMap['items'][0]['snippet']['description'];
    DateTime publishedAt =
        DateTime.parse(jsonMap['items'][0]['snippet']['publishedAt']);
    String viewCount = jsonMap['items'][0]['statistics']['viewCount'];
    String likeCount = jsonMap['items'][0]['statistics']['likeCount'];
    String commentCount = jsonMap['items'][0]['statistics']['commentCount'];

    return Video(
        id: id,
        title: title,
        channelId: channelId,
        channelTitle: channelTitle,
        description: description,
        publishedAt: publishedAt,
        viewCount: viewCount,
        likeCount: likeCount,
        commentCount: commentCount);
  }
}
