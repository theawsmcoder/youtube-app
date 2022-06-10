import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart';

import '../models/youtube_search_models.dart';
import '../utilities/key.dart';
import '../models/video_model.dart';
import '../models/channel_model.dart';
import '../models/playlist_model.dart';

class YoutubeDataApiService {
  final baseUrl = 'https://youtube.googleapis.com';
  String nextPageToken = '';

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

  Future<YoutubeSearchResults> search(
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
    };

    Response response = await httpRequest(route, parameters);

    var results = YoutubeSearchResults.fromJson(response.body);
    return results;
  }

  Future<Video> getVideo({required String videoId}) async {
    const String route = '/youtube/v3/video';
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
    const String route = '/youtube/v3/channel';
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
}
