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
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          YoutubeSearchResults temp;
                          temp = await youtubeDataApiService.search(
                            searchString: searchController.text,
                          );
                          setState(() {
                            youtubeSearchResults = temp;
                          });
                        },
                        icon: const Icon(Icons.search))
                  ],
                ),
              ),
              youtubeSearchResults.results.isEmpty
                  ? const Text("no data")
                  : SizedBox(
                      height: 500,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return _ytSearchTile(
                              youtubeSearchResults.results[index]);
                        },
                        itemCount: youtubeSearchResults.results.length,
                      ),
                    ),
            ],
          ),
        ));
  }

  Widget _ytSearchTile(dynamic result) {
    return result is VideoResult
        ? SizedBox(
            child: Row(children: [
              Image.network(result.thumbnailUrl),
              Column(
                children: [
                  Text(result.title),
                  Text(result.channelTitle),
                  Text(result.videoDescription),
                  Text(result.publishedTime.toString()),
                ],
              )
            ]),
          )
        : Container();
  }
}
