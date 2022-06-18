import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  List<dynamic> searchResults = [];
  DateFormat dateFormat = DateFormat.yMMMMd();

  @override
  void initState() {
    youtubeDataApiService = YoutubeDataApiService.instance;
    searchController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () => showBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) => buildSearchWidget()),
        child: const Text('search a video'),
      ),
    );
  }

  Widget resultWidget(dynamic result, BuildContext context) {
    return result is VideoResult
        ? Card(
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
          )
        : result is ChannelResult
            ? Card(
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
              )
            : result is PlaylistResult
                ? Card(
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
                                "Playlst",
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
                  )
                : const Center(child: Text("Not a result"));
  }

  Widget buildSearchWidget() {
    double appbarHeight = AppBar(
      title: const Text('data'),
    ).preferredSize.height;
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(color: Color.fromARGB(255, 47, 47, 47)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          List<dynamic> temp;
                          temp = await youtubeDataApiService.search(
                            searchString: searchController.text,
                          );
                          setState(() {
                            youtubeDataApiService.clear();
                            searchResults = temp;
                          });
                        },
                        icon: const Icon(Icons.search))
                  ],
                ),
              ),
              searchResults.isEmpty
                  ? const Text("no data")
                  : SizedBox(
                      height: 0.9 *
                              (MediaQuery.of(context).size.height -
                                  MediaQuery.of(context).padding.top -
                                  MediaQuery.of(context).padding.bottom -
                                  appbarHeight) -
                          85,
                      child: ListView.builder(
                        controller: controller,
                        itemBuilder: (context, index) {
                          return resultWidget(searchResults[index], context);
                        },
                        itemCount: searchResults.length,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
