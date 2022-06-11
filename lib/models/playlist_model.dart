import 'dart:convert';

class Playlist {
  String id;
  String title;
  List<PlaylistItem> items;

  Playlist({
    required this.id,
    required this.title,
    required this.items,
  });

  factory Playlist.fromJson(String jsonStr) {
    Map jsonMap = json.decode(jsonStr);

    String id = jsonMap['items'][0]['snippet']['playlistId'];
    String title = jsonMap['items'][0]['snippet']['title'];

    List<PlaylistItem> items = [];

    for (var item in jsonMap['items']) {
      items.add(PlaylistItem.fromMap(item));
    }

    return Playlist(
      id: id,
      title: title,
      items: items,
    );
  }
}

class PlaylistItem {
  String title;
  String videoId;
  String channelId;
  String channelTitle;
  String videoOwnerChannelId;
  String videoOwnerChannelTitle;
  String thumbnailUrl;
  String description;

  PlaylistItem({
    required this.videoId,
    required this.title,
    required this.thumbnailUrl,
    required this.description,
    required this.channelId,
    required this.channelTitle,
    required this.videoOwnerChannelId,
    required this.videoOwnerChannelTitle,
  });

  factory PlaylistItem.fromMap(Map item) {
    //Map jsonMap = json.decode(item.replaceAll("'", "\""));

    String videoId = item['snippet']['resourceId']['videoId'];
    String title = item['snippet']['title'];
    String thumbnailUrl = item['snippet']['thumbnails']['default']['url'];
    String description = item['snippet']['description'];
    String channelId = item['snippet']['channelId'];
    String channelTitle = item['snippet']['channelTitle'];
    String videoOwnerChannelId = item['snippet']['videoOwnerChannelId'];
    String videoOwnerChannelTitle = item['snippet']['videoOwnerChannelTitle'];

    return PlaylistItem(
      videoId: videoId,
      title: title,
      thumbnailUrl: thumbnailUrl,
      description: description,
      channelId: channelId,
      channelTitle: channelTitle,
      videoOwnerChannelId: videoOwnerChannelId,
      videoOwnerChannelTitle: videoOwnerChannelTitle,
    );
  }
}
