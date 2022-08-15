import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/youtube_data_api_service.dart';
import 'result_tile.dart';

class SearchWidget extends StatelessWidget {
  TextEditingController searchTextController = TextEditingController();
  YoutubeDataApiService youtubeDataApiService = YoutubeDataApiService.instance;
  SearchWidget({Key? key}) : super(key: key);

  Widget get _searchBar => Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              controller: searchTextController,
            ),
          ),
          IconButton(
              onPressed: () async {
                youtubeDataApiService.clear();

                await youtubeDataApiService.search(
                  searchString: searchTextController.text,
                );
              },
              icon: const Icon(Icons.search))
        ],
      ));

  Widget _buildListView(BuildContext context, ScrollController controller) {
    double appbarHeight = AppBar(
      title: const Text('data'),
    ).preferredSize.height;

    return SizedBox(
      height: 0.9 *
              (MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom -
                  appbarHeight) -
          85,
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollNotification) {
          if (!youtubeDataApiService.isLoading &&
              youtubeDataApiService.searchResults.length <=
                  youtubeDataApiService.totalResults &&
              scrollNotification.metrics.pixels ==
                  scrollNotification.metrics.maxScrollExtent) {
            youtubeDataApiService.loadMoreVideos();
          }
          return false;
        },
        child: ListView.builder(
          controller: controller,
          itemBuilder: (context, index) {
            if (index < youtubeDataApiService.searchResults.length) {
              return ResultTile(
                result: youtubeDataApiService.searchResults[index],
              );
            }
            return const Center(child: LinearProgressIndicator());
          },
          itemCount: youtubeDataApiService.searchResults.length + 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //youtubeDataApiService = Provider.of<YoutubeDataApiService>(context);
    return DraggableScrollableSheet(
      initialChildSize: 1,
      maxChildSize: 1,
      minChildSize: 0.5,
      builder: (_, controller) => Column(children: [
        const Expanded(
          flex: 1,
          child: SizedBox.expand(),
        ),
        Expanded(
          flex: 2,
          child: Container(
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 47, 47, 47)),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _searchBar,
                  youtubeDataApiService.searchResults.isEmpty &&
                          youtubeDataApiService.isLoading
                      ? const Padding(
                          padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : youtubeDataApiService.searchResults.isEmpty &&
                              !youtubeDataApiService.isLoading
                          ? const Text("no data")
                          : _buildListView(context, controller)
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
