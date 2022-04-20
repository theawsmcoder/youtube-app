import 'package:flutter/material.dart';

class Player extends StatefulWidget {
  final double height;
  final double width;
  final Function play;
  final Function pause;
  Player({
    required this.height,
    required this.width,
    required this.play,
    required this.pause,
  });
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  double _value = 0.0;
  bool _playerVisible = true;
  bool _playing = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _playerVisible = !_playerVisible;
        });
      },
      child: Container(
        height: widget.height,
        width: widget.width,
        color: Colors.transparent,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: _playerVisible ? 1 : 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                decoration: const BoxDecoration(
                  color: Colors.black26,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black,
                      Colors.black12,
                    ],
                  ),
                ),
                child: const Text(
                  "title",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Center(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black12,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      _playing ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _playing ? widget.pause() : widget.play();
                      setState(() {
                        _playing = !_playing;
                      });
                    },
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black26,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black12,
                      Colors.black54,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: _value,
                        min: 0,
                        max: 60,
                        activeColor: Colors.white,
                        onChanged: (value) {
                          setState(() {
                            _value = value;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.speed,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
