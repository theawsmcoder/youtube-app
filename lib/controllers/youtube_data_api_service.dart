import 'dart:io';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import '../models/youtube_search_models.dart';
import '../utilities/key.dart';
import '../models/video_model.dart';
import '../models/channel_model.dart';
import '../models/playlist_model.dart';

class YoutubeDataApiService with ChangeNotifier {
  final baseUrl = 'youtube.googleapis.com';
  String nextPageToken = '';
  String prevPageToken = '';
  List<dynamic> searchResults = [];
  String lastSearchString = '';
  int totalResults = 0;
  bool isLoading = false;
  Video? video;
  Channel? channel;
  Playlist? playlist;

  YoutubeDataApiService._instantiate();

  static final YoutubeDataApiService instance =
      YoutubeDataApiService._instantiate();

  void updateResultsList(List<dynamic> results) {
    searchResults.addAll(results);
    notifyListeners();
  }

  void updateParameters(String nextPageToken, String prevPageToken,
      int totalResults, List<dynamic> results) {
    this.nextPageToken = nextPageToken;
    this.prevPageToken = prevPageToken;
    this.totalResults = totalResults;
    searchResults.addAll(results);
    isLoading = false;
    notifyListeners();
  }

  void updateVideo(Video video) {
    this.video = video;
    isLoading = false;
    notifyListeners();
  }

  void updateChannel(Channel channel) {
    this.channel = channel;
    isLoading = false;
    notifyListeners();
  }

  void updatePlaylist(Playlist playlist) {
    this.playlist = playlist;
    isLoading = false;
    notifyListeners();
  }

  void updateIsLoading(bool status) {
    isLoading = status;
    notifyListeners();
  }

  void clear() {
    nextPageToken = '';
    prevPageToken = '';
    searchResults = [];
    lastSearchString = '';
    video = null;
    channel = null;
    playlist = null;
    isLoading = false;
    notifyListeners();
  }

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

  List<dynamic> getSearchResults(String jsonStr) {
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
    totalResults = jsonMap['pageInfo']['totalResults'] ?? 0;
    updateParameters(nextPageToken, prevPageToken, totalResults, results);

    return results;
  }

  Future<List<dynamic>> search(
      {required String searchString,
      String? pageToken,
      String? channelId}) async {
    updateIsLoading(true);
    lastSearchString = searchString;
    const String route = '/youtube/v3/search';

    Map<String, String> parameters = {
      'part': 'snippet',
      'q': searchString,
      'key': key,
      'pageToken': pageToken ?? '',
      'channelId': channelId ?? '',
      'maxResults': '30',
    };
    //print(searchString);
    //print(pageToken);

    Response response = await httpRequest(route, parameters);

    var results = getSearchResults(response.body);

    return results;
  }

  Future<Video> getVideo({required String videoId}) async {
    updateIsLoading(true);
    const String route = '/youtube/v3/videos';
    Map<String, String> parameters = {
      'part': 'snippet,statistics',
      'key': key,
      'id': videoId,
    };

    Response response = await httpRequest(route, parameters);
    var video = Video.fromJson(response.body);

    updateVideo(video);

    return video;
  }

  Future<Channel> getChannel({required String channelId}) async {
    updateIsLoading(true);
    const String route = '/youtube/v3/channels';
    Map<String, String> parameters = {
      'part': 'snippet,statistics',
      'key': key,
      'id': channelId,
    };

    Response response = await httpRequest(route, parameters);
    var channel = Channel.fromJson(response.body);

    updateChannel(channel);

    return channel;
  }

  Future<Playlist> getPlaylist({required String playlistId}) async {
    updateIsLoading(true);
    const String route = '/youtube/v3/playlistItems';
    Map<String, String> parameters = {
      'part': 'snippet',
      'key': key,
      'playlistId': playlistId,
    };

    Response response = await httpRequest(route, parameters);
    var playlist = Playlist.fromJson(response.body);

    updatePlaylist(playlist);

    return playlist;
  }

  Future<List<dynamic>> loadMoreVideos() async {
    List<dynamic> results =
        await search(searchString: lastSearchString, pageToken: nextPageToken);
    return results;
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
