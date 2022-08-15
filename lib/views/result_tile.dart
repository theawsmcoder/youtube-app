import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sample/controllers/youtube_connector.dart';
import 'package:sample/controllers/youtube_data_api_service.dart';

import '../models/youtube_search_models.dart';

class ResultTile extends StatelessWidget {
  final dynamic result;
  static DateFormat dateFormat = DateFormat.yMMMMd();
  const ResultTile({Key? key, this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final YoutubeDataApiService youtubeDataApiService =
        YoutubeDataApiService.instance;
    return result is VideoResult
        ? GestureDetector(
            onTap: (() async {
              await youtubeDataApiService.getVideo(videoId: result.id);
              YoutubeController.instance.loadVideo(result.id);
            }),
            child: _buildVideoResultTile(context))
        : result is ChannelResult
            ? _buildChannelResultTile(context)
            : result is PlaylistResult
                ? _buildPlaylistResultTile(context)
                : const Center(child: Text("Not a result"));
  }

  Card _buildPlaylistResultTile(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(2.0),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(children: [
          Image.network(
            result.thumbnailUrl,
            fit: BoxFit.contain,
            width: 150,
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                // -168 considering width of image, padding and margin
                width: MediaQuery.of(context).size.width - 168,
                child: const Text(
                  "Playlist",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  //textWidthBasis: TextWidthBasis.parent,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                // -168 considering width of image, padding and margin
                width: MediaQuery.of(context).size.width - 168,
                child: Text(
                  result.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  //textWidthBasis: TextWidthBasis.parent,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: MediaQuery.of(context).size.width - 168,
                child: Text(
                  result.channelTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  //textWidthBasis: TextWidthBasis.parent,
                ),
              ),
              //Text(result.videoDescription),
              Text(
                dateFormat.format(result.publishedTime),
                style: const TextStyle(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                //textWidthBasis: TextWidthBasis.parent,
              ),
            ],
          )
        ]),
      ),
    );
  }

  Card _buildChannelResultTile(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(2.0),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: SizedBox(
          height: 80,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(result.thumbnailUrl),
                ),
                SizedBox(
                  // -168 considering width of image, padding and margin
                  width: MediaQuery.of(context).size.width - 168,

                  child: Text(
                    result.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,

                    //textWidthBasis: TextWidthBasis.parent,
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  Card _buildVideoResultTile(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(2.0),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(children: [
          Image.network(
            result.thumbnailUrl,
            fit: BoxFit.contain,
            width: 150,
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                // -168 considering width of image, padding and margin
                width: MediaQuery.of(context).size.width - 168,
                child: Text(
                  result.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  //textWidthBasis: TextWidthBasis.parent,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: MediaQuery.of(context).size.width - 168,
                child: Text(
                  result.channelTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  //textWidthBasis: TextWidthBasis.parent,
                ),
              ),
              //Text(result.videoDescription),
              Text(
                dateFormat.format(result.publishedTime),
                style: const TextStyle(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                //textWidthBasis: TextWidthBasis.parent,
              ),
            ],
          )
        ]),
      ),
    );
  }
}
