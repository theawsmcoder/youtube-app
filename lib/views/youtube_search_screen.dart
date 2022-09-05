import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sample/controllers/youtube_data_api_service.dart';
import 'package:sample/views/search_widget.dart';

import '../models/youtube_search_models.dart';
import 'result_tile.dart';
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
  //YoutubeDataApiService? youtubeDataApiService;

  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //youtubeDataApiService ??=
    //Provider.of<YoutubeDataApiService>(context, listen: false);

    return Center(
      child: TextButton(
        onPressed: () => showBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) => Consumer<YoutubeDataApiService>(
            builder: (context, value, child) => WillPopScope(
              onWillPop: () async => false,
              child: SearchWidget(),
            ),
          ),
        ),
        child: const Text('search a video'),
      ),
    );
  }
}


/* TextButton(
        onPressed: () => Scaffold.of(context).showBottomSheet<void>(
          (context) => Consumer<YoutubeDataApiService>(
            builder: (context, value, child) => WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: SearchWidget(),
            ),
          ),
        ),
        child: const Text('search a video'),
      ),*/
