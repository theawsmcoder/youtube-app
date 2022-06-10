import 'package:flutter/material.dart';
import 'package:sample/controllers/youtube_data_api_service.dart';

import '../models/youtube_search_models.dart';
import '../models/video_model.dart';
import '../models/channel_model.dart';
import '../models/playlist_model.dart';

class YoutubeSearchScreen extends StatefulWidget {
  const YoutubeSearchScreen({Key? key}) : super(key: key);

  @override
  State<YoutubeSearchScreen> createState() => _YoutubeSearchScreenState();
}

class _YoutubeSearchScreenState extends State<YoutubeSearchScreen> {
  late TextEditingController searchController;
  late YoutubeDataApiService youtubeDataApiService;
  late YoutubeSearchResults youtubeSearchResults;

  @override
  void initState() {
    youtubeSearchResults = YoutubeSearchResults();
    youtubeDataApiService = YoutubeDataApiService.instance;
    searchController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Search"),
        ),
        body: Column(
          children: [
            Row(
              children: [
                TextField(
                  controller: searchController,
                ),
                IconButton(
                    onPressed: () async {
                      youtubeSearchResults = await youtubeDataApiService.search(
                        searchString: searchController.text,
                      );
                    },
                    icon: const Icon(Icons.search))
              ],
            ),
            ListView.builder(
              itemBuilder: (context, index) {
                return _ytSearchTile(
                    youtubeSearchResults.resultDataList![index]);
              },
              itemCount: youtubeSearchResults.resultDataList?.length ?? 0,
            ),
          ],
        ));
  }

  Widget _ytSearchTile(dynamic result) {
    return result is VideoResult
        ? SizedBox(
            child: Row(children: [
              Image.network(result.thumbnailUrl),
              Column(
                children: [
                  Text(result.videoTitle),
                  Text(result.channelName),
                  Text(result.videoDescription),
                  Text(result.publishedTime.toString()),
                ],
              )
            ]),
          )
        : Container();
  }
}
