import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart';

import '../models/youtube_search_models.dart';
import '../utilities/key.dart';
import '../models/video_model.dart';
import '../models/channel_model.dart';
import '../models/playlist_model.dart';

class YoutubeDataApiService {
  final baseUrl = 'youtube.googleapis.com';
  String nextPageToken = '';
  String prevPageToken = '';
  List<dynamic> searchResults = [];

  YoutubeDataApiService._instantiate();

  static final YoutubeDataApiService instance =
      YoutubeDataApiService._instantiate();

  Future<Response> httpRequest(
      String route, Map<String, String> parameters) async {
    Uri uri = Uri.https(
      baseUrl,
      route,
      parameters,
    );

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    var response = await get(uri, headers: headers);
    if (response.statusCode == 200) {
      return response;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  List getSearchResults(String jsonStr) {
    Map jsonMap = json.decode(jsonStr);
    List<dynamic> results = [];

    for (var result in jsonMap['items']) {
      if (result['id']['kind'] == 'youtube#video') {
        if (result['snippet']['liveBroadcastContent'] == 'none') {
          results.add(VideoResult.fromMap(result));
        }
      } else if (result['id']['kind'] == 'youtube#channel') {
        results.add(ChannelResult.fromMap(result));
      } else if (result['id']['kind'] == 'youtube#playlist') {
        results.add(PlaylistResult.fromMap(result));
      }
    }
    nextPageToken = jsonMap['nextPageToken'] ?? '';
    prevPageToken = jsonMap['prevPageToken'] ?? '';
    searchResults.addAll(results);

    return results;
  }

  Future<List> search(
      {required String searchString,
      String? pageToken,
      String? channelId}) async {
    const String route = '/youtube/v3/search';

    Map<String, String> parameters = {
      'part': 'snippet',
      'q': searchString,
      'key': key,
      'pageToken': pageToken ?? '',
      'channelId': channelId ?? '',
      'maxResults': '10',
    };

    Response response = await httpRequest(route, parameters);

    var results = getSearchResults(response.body);
    return results;
  }

  Future<Video> getVideo({required String videoId}) async {
    const String route = '/youtube/v3/videos';
    Map<String, String> parameters = {
      'part': 'snippet,statistics',
      'key': key,
      'id': videoId,
    };

    Response response = await httpRequest(route, parameters);
    var video = Video.fromJson(response.body);
    return video;
  }

  Future<Channel> getChannel({required String channelId}) async {
    const String route = '/youtube/v3/channels';
    Map<String, String> parameters = {
      'part': 'snippet,statistics',
      'key': key,
      'id': channelId,
    };

    Response response = await httpRequest(route, parameters);
    var channel = Channel.fromJson(response.body);
    return channel;
  }

  Future<Playlist> getPlaylist({required String playlistId}) async {
    const String route = '/youtube/v3/playlistItems';
    Map<String, String> parameters = {
      'part': 'snippet',
      'key': key,
      'playlistId': playlistId,
    };

    Response response = await httpRequest(route, parameters);
    var playlist = Playlist.fromJson(response.body);
    return playlist;
  }

  void clear() {
    nextPageToken = '';
    prevPageToken = '';
    searchResults = [];
  }
}

void main() async {
  YoutubeDataApiService instance = YoutubeDataApiService._instantiate();
  //var results = await instance.search(
  //searchString: 'valorant', channelId: 'UCNF0LEQ2abMr0PAX3cfkAMg');

  Video video = await instance.getVideo(videoId: '_qRvhoJn2nY');
  print(video.title);
  Channel channel =
      await instance.getChannel(channelId: 'UCNF0LEQ2abMr0PAX3cfkAMg');
  Playlist playlist = await instance.getPlaylist(
      playlistId: "PLhDcNtvAa1Itk1lbxGdQDvgrkOo6Cur-z");
  print(playlist.title);
  print(playlist.items[1].title);

  /*for (var result in results.results) {
    if (result is VideoResult) {
      print("video result:${result.title}");
      Video video = await instance.getVideo(videoId: result.id);
      print(video.title);
    } else if (result is ChannelResult) {
      print("channel result:${result.title}");
    } else if (result is PlaylistResult) {
      print("playlist result:${result.title}");
    }
  }*/
}
