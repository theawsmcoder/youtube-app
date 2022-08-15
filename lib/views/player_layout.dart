import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:async';

import './../controllers/youtube_connector.dart';

class PlayerLayout extends StatefulWidget {
  @override
  State<PlayerLayout> createState() => _PlayerLayoutState();
}

class _PlayerLayoutState extends State<PlayerLayout> {
  double tempValue = 0.0;
  bool layoutVisible = true;
  Timer? sliderTimer;
  late YoutubeController youtubeController;

  @override
  Widget build(BuildContext context) {
    youtubeController = Provider.of<YoutubeController>(context);
    //tempValue = youtubeController.playerInfo.currentTime;
    print(youtubeController.playerInfo.duration);
    print(tempValue);
    print(youtubeController.playerInfo.playerState);

    /*if (youtubeController.playerInfo.playerState == -1 ||
        youtubeController.playerInfo.playerState == 0 ||
        youtubeController.playerInfo.playerState == 5) {
      tempValue = 0;
      sliderPause();
    } else if (youtubeController.playerInfo.playerState == 1 ||
        youtubeController.playerInfo.playerState == 3) {
      sliderPause();
    } else if (youtubeController.playerInfo.playerState == 2) {
      //tempValue = youtubeController.playerInfo.currentTime;
      sliderStart();
    }*/

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
                          youtubeController.playerInfo.title,
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
                        onPressed: () {
                          switch (youtubeController.playerInfo.playerState) {
                            //unstarted
                            case -1:
                              var delay = (youtubeController.ping / 2 +
                                      youtubeController.max_ping / 2)
                                  .toInt();
                              youtubeController.playVideo(delay);

                              sliderStart();
                              break;

                            //ended
                            // for now im using same code as play here
                            case 0:
                              var delay = (youtubeController.ping / 2 +
                                      youtubeController.max_ping / 2)
                                  .toInt();
                              youtubeController.playVideo(delay);

                              sliderStart();
                              break;

                            //pause
                            case 1:
                              youtubeController.seekTo(tempValue);
                              sliderPause();
                              break;

                            //play
                            case 2:
                              var delay = (youtubeController.ping / 2 +
                                      youtubeController.max_ping / 2)
                                  .toInt();
                              youtubeController.playVideo(delay);

                              sliderStart();
                              break;

                            //buffering
                            // for now im using same code as pause here
                            case 3:
                              youtubeController.seekTo(tempValue);
                              sliderPause();
                              break;

                            //cued
                            // same code as play
                            case 5:
                              var delay = (youtubeController.ping / 2 +
                                      youtubeController.max_ping / 2)
                                  .toInt();
                              youtubeController.playVideo(delay);

                              sliderStart();
                              break;
                          }
                        },
                        icon: Icon(
                          (getIcon(youtubeController.playerInfo.playerState!)),
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
                                max: youtubeController.playerInfo.duration,
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
                            timeFormat(
                                youtubeController.playerInfo.duration.round()),
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
        if (tempValue <= youtubeController.playerInfo.duration) {
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

  IconData getIcon(int playerState) {
    switch (playerState) {
      case -1:
        return Icons.play_arrow;
      case 0:
        return Icons.play_arrow;
      case 1:
        return Icons.pause;
      case 2:
        return Icons.play_arrow;
      case 3:
        return Icons.pause;
      case 5:
        return Icons.play_arrow;
      default:
        return Icons.dangerous;
    }
  }
}
