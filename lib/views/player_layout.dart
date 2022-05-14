import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:async';

import './../models/player_info.dart';
import './../controllers/youtube_connector.dart';

class PlayerLayout extends StatefulWidget {
  PlayerInfo playerInfo;
  PlayerLayout({required this.playerInfo});
  @override
  State<PlayerLayout> createState() => _PlayerLayoutState();
}

class _PlayerLayoutState extends State<PlayerLayout> {
  double tempValue = 0.0;
  bool layoutVisible = true;
  Timer? sliderTimer;

  @override
  Widget build(BuildContext context) {
    final youtubeController =
        Provider.of<YoutubeController>(context, listen: false);

    return GestureDetector(
      onTap: () {
        setState(() {
          layoutVisible = !layoutVisible;
        });
      },
      child: Container(
        height: MediaQuery.of(context).size.width * 9 / 16,
        color: Colors.transparent,
        child: layoutVisible
            ? Container(
                color: Colors.black12,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 25,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 2, 0, 2),
                        child: Text(
                          widget.playerInfo.title,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                      ),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black38,
                            Colors.black12,
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: IconButton(
                        onPressed: youtubeController.start
                            ? () {
                                youtubeController.pauseVideo();
                                sliderPause();
                              }
                            : () {
                                var delay = (youtubeController.ping / 2 +
                                        youtubeController.ping / 2)
                                    .toInt();
                                youtubeController.playVideo(delay);
                                sliderStart();
                              },
                        icon: Icon(
                          youtubeController.start
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            timeFormat(tempValue.round()),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: SliderTheme(
                            data: const SliderThemeData(
                                activeTrackColor:
                                    Color.fromARGB(255, 192, 59, 59),
                                inactiveTrackColor: Colors.grey,
                                trackHeight: 3,
                                overlayColor:
                                    Color.fromARGB(100, 252, 139, 139),
                                overlayShape:
                                    RoundSliderOverlayShape(overlayRadius: 7),
                                thumbColor: Color.fromARGB(255, 198, 39, 39),
                                thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 5)),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Slider(
                                max: widget.playerInfo.duration,
                                min: 0,
                                value: tempValue,
                                onChanged: (value) {
                                  setState(() {
                                    tempValue = value;
                                  });
                                  youtubeController.seekTo(value);
                                  sliderPause();
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            timeFormat(widget.playerInfo.duration.round()),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            : const SizedBox.expand(),
      ),
    );
  }

  void sliderStart() {
    sliderTimer?.cancel();
    if (sliderTimer == null || !sliderTimer!.isActive) {
      sliderTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (tempValue <= widget.playerInfo.duration) {
          setState(() {
            tempValue += 1;
          });
        }
      });
    }
  }

  void sliderPause() {
    sliderTimer?.cancel();
  }

  String timeFormat(int time) {
    var duration = Duration(seconds: time);
    var formatted = duration.toString();
    List<int> list =
        formatted.split(':').map((e) => double.parse(e).round()).toList();
    if (list[0] == 0) {
      return "${list[1].toString().padLeft(2, '0')}:${list[2].round().toString().padLeft(2, '0')}";
    }
    return "${list[0].toString().padLeft(2, '0')}:${list[1].toString().padLeft(2, '0')}:${list[2].round().toString().padLeft(2, '0')}";
  }
}
