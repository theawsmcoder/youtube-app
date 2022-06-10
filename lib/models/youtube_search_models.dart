import 'dart:convert';

class YoutubeSearchResults {
  String? nextPageToken;
  String? prevPageToken;
  List<dynamic>? resultDataList = [];

  YoutubeSearchResults({
    this.nextPageToken,
    this.prevPageToken,
    this.resultDataList,
  });

  factory YoutubeSearchResults.fromJson(String jsonStr) {
    Map jsonMap = json.decode(jsonStr.replaceAll("'", "\""));

    String? nextPageToken = jsonMap['nextPageToken'];
    String? prevPageToken = jsonMap['prevPageToken'];
    List<dynamic>? results = [];

    for (var result in jsonMap['items']) {
      if (result.kind == 'youtube#video') {
        results.add(VideoResult.fromMap(result));
      } else if (result.kind == 'youtube#channel') {
        results.add(ChannelResult.fromMap(result));
      } else if (result.kind == 'youtube#playlist') {
        results.add(PlaylistResult.fromMap(result));
      }
    }

    return YoutubeSearchResults(
      nextPageToken: nextPageToken,
      prevPageToken: prevPageToken,
      resultDataList: results,
    );
  }
}

class VideoResult {
  String kind;
  String videoId;
  String videoTitle;
  String videoDescription;
  DateTime publishedTime;

  String thumbnailUrl;
  int thumbnailHeight;
  int thumbnailWidth;

  String channelId;
  String channelName;

  VideoResult({
    required this.kind,
    required this.videoId,
    required this.videoTitle,
    required this.videoDescription,
    required this.thumbnailUrl,
    required this.thumbnailHeight,
    required this.thumbnailWidth,
    required this.channelId,
    required this.channelName,
    required this.publishedTime,
  });

  factory VideoResult.fromMap(Map result) {
    //Map jsonMap = json.decode(jsonStr.replaceAll("'", "\""));

    String kind = result['id']['kind'];
    String videoId = result['id']['videoId'];
    String channelId = result['snippet']['channelId'];
    String channelName = result['snippet']['channelTitle'];
    String videoTitle = result['snippet']['title'];
    DateTime publishedTime = DateTime.parse(result['snippet']['publishedAt']);
    String videoDescription = result['snippet']['description'];
    String thumbnailUrl = result['snippet']['thumbnails']['medium']['url'];
    int thumbnailHeight = result['snippet']['thumbnails']['medium']['height'];
    int thumbnailWidth = result['snippet']['thumbnails']['medium']['width'];

    return VideoResult(
      kind: kind,
      channelId: channelId,
      channelName: channelName,
      videoId: videoId,
      videoTitle: videoTitle,
      videoDescription: videoDescription,
      thumbnailUrl: thumbnailUrl,
      publishedTime: publishedTime,
      thumbnailHeight: thumbnailHeight,
      thumbnailWidth: thumbnailWidth,
    );
  }
}

class ChannelResult {
  String kind;
  String description;
  DateTime publishedTime;
  String thumbnailUrl;
  String channelId;
  String channelName;

  ChannelResult({
    required this.kind,
    required this.description,
    required this.thumbnailUrl,
    required this.channelId,
    required this.channelName,
    required this.publishedTime,
  });

  factory ChannelResult.fromMap(Map result) {
    //Map jsonMap = json.decode(jsonStr.replaceAll("'", "\""));

    String kind = result['id']['kind'];
    String channelId = result['snippet']['channelId'];
    String channelName = result['snippet']['channelTitle'];
    DateTime publishedTime = DateTime.parse(result['snippet']['publishedAt']);
    String description = result['snippet']['description'];
    String thumbnailUrl = result['snippet']['thumbnails']['medium']['url'];

    return ChannelResult(
      kind: kind,
      channelId: channelId,
      channelName: channelName,
      description: description,
      thumbnailUrl: thumbnailUrl,
      publishedTime: publishedTime,
    );
  }
}

class PlaylistResult {
  String kind;
  String playlistId;
  String description;
  DateTime publishedTime;
  String thumbnailUrl;
  String channelId;
  String channelName;

  PlaylistResult({
    required this.kind,
    required this.playlistId,
    required this.description,
    required this.thumbnailUrl,
    required this.channelId,
    required this.channelName,
    required this.publishedTime,
  });

  factory PlaylistResult.fromMap(Map result) {
    //Map jsonMap = json.decode(jsonStr.replaceAll("'", "\""));

    String kind = result['id']['kind'];
    String playlistId = result['id']['playlistId'];
    String channelId = result['snippet']['channelId'];
    String channelName = result['snippet']['channelTitle'];
    DateTime publishedTime = DateTime.parse(result['snippet']['publishedAt']);
    String description = result['snippet']['description'];
    String thumbnailUrl = result['snippet']['thumbnails']['medium']['url'];

    return PlaylistResult(
      kind: kind,
      playlistId: playlistId,
      channelId: channelId,
      channelName: channelName,
      description: description,
      thumbnailUrl: thumbnailUrl,
      publishedTime: publishedTime,
    );
  }
}

void main() {
  String jsonStr = '''{
    "kind": "youtube#searchListResponse",
    "etag": "DyEcg6KRswsz7GBdheOSzqb9cV4",
    "nextPageToken": "CBsQAA",
    "prevPageToken": "CBkQAQ",
    "regionCode": "IN",
    "pageInfo": {
        "totalResults": 1000000,
        "resultsPerPage": 2
    },
    "items": [
        {
            "kind": "youtube#searchResult",
            "etag": "5WGM3G0bWKnoCAMRZcqkCo6TXJg",
            "id": {
                "kind": "youtube#video",
                "videoId": "uPRxBmMmnGQ"
            },
            "snippet": {
                "publishedAt": "2022-06-04T15:18:55Z",
                "channelId": "UCzVgCrOcBAWYEHTtVOMPAtw",
                "title": "2022 VCT Stage2 - Challengers JAPAN Week2 Main Event Day1",
                "description": "0:00 オープニング 55:36 REIGNITE VS Sengoku Gaming Map1:Icebox 1:51:05 REIGNITE VS Sengoku Gaming Map2:Haven ...",
                "thumbnails": {
                    "default": {
                        "url": "https://i.ytimg.com/vi/uPRxBmMmnGQ/default.jpg",
                        "width": 120,
                        "height": 90
                    },
                    "medium": {
                        "url": "https://i.ytimg.com/vi/uPRxBmMmnGQ/mqdefault.jpg",
                        "width": 320,
                        "height": 180
                    },
                    "high": {
                        "url": "https://i.ytimg.com/vi/uPRxBmMmnGQ/hqdefault.jpg",
                        "width": 480,
                        "height": 360
                    }
                },
                "channelTitle": "VALORANT // JAPAN",
                "liveBroadcastContent": "none",
                "publishTime": "2022-06-04T15:18:55Z"
            }
        },
        {
            "kind": "youtube#searchResult",
            "etag": "2mqqmSb7aMQKwd7jBlcwCkAfOXQ",
            "id": {
                "kind": "youtube#video",
                "videoId": "A2OxJ2p-5bY"
            },
            "snippet": {
                "publishedAt": "2022-05-30T09:15:40Z",
                "channelId": "UCgtbMb3djcXKj6CHerHwZ-A",
                "title": "Valorant Tips And Tricks Sent By You - Part 27",
                "description": "From developer Super Evil Megacorp, Catalyst Black is bringing action-packed gameplay and insane graphics to all mobile ...",
                "thumbnails": {
                    "default": {
                        "url": "https://i.ytimg.com/vi/A2OxJ2p-5bY/default.jpg",
                        "width": 120,
                        "height": 90
                    },
                    "medium": {
                        "url": "https://i.ytimg.com/vi/A2OxJ2p-5bY/mqdefault.jpg",
                        "width": 320,
                        "height": 180
                    },
                    "high": {
                        "url": "https://i.ytimg.com/vi/A2OxJ2p-5bY/hqdefault.jpg",
                        "width": 480,
                        "height": 360
                    }
                },
                "channelTitle": "MrLowlander",
                "liveBroadcastContent": "none",
                "publishTime": "2022-05-30T09:15:40Z"
              }
          }
      ]
  }''';

  Map jsonMap = json.decode(jsonStr);
  //print(jsonMap['kind']);
  List items = jsonMap['items'];
  //print(items[0]['snippet']);
  print(items[0]['snippet']['channelId']);
  VideoResult resultData = VideoResult.fromMap(items[0]);
  print(resultData.channelId);

  YoutubeSearchResults ytsr = YoutubeSearchResults.fromJson(jsonStr);
  print(ytsr.resultDataList![0].channelId);
}
