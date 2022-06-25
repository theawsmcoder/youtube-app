import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/youtube_search_models.dart';

class ResultTile extends StatelessWidget {
  final dynamic result;
  static DateFormat dateFormat = DateFormat.yMMMMd();
  const ResultTile({Key? key, this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
