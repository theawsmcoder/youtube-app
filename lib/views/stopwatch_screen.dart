import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '.././controllers/stopwatch.dart';

class StopwatchScreen extends StatelessWidget {
  StopwatchScreen({Key? key}) : super(key: key);
  late Stopwatch stopwatch;

  @override
  Widget build(BuildContext context) {
    final stopwatch = Provider.of<Stopwatch>(context, listen: false);

    var appBar = AppBar(
      title: const Text(
        "stopwatch",
        textAlign: TextAlign.center,
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Consumer<Stopwatch>(
              builder: (context, value, child) => Container(
                width: double.infinity,
                child: Text(
                  stopwatch.ping.toString(),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
            Consumer<Stopwatch>(
              builder: (context, value, child) => Text(
                stopwatch.stopwatch.toString().substring(0, 10),
                style: const TextStyle(fontSize: 24),
              ),
            ),
            Consumer<Stopwatch>(
              builder: (context, value, child) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: stopwatch.start
                        ? () {
                            stopwatch
                                .pauseTimer(stopwatch.stopwatch.inMilliseconds);
                          }
                        :
                        //here it will play after max_ping/2 + ping/2 (called the function in stopwtch_screen.dart)
                        //meaning it will play after time taken for the message to go to the farthest user
                        //the json however will only have max_ping/2 as argument and the receiving user will play after max_ping/2 - their ping (called the function in Stopwatch.commandsHandler())
                        () {
                            stopwatch.startTimer(
                                (stopwatch.ping / 2 + stopwatch.max_ping / 2)
                                    .toInt());
                          },
                    child: Text(stopwatch.start ? "pause" : "start"),
                  ),
                  const SizedBox(
                    width: 100,
                  ),
                  ElevatedButton(
                    onPressed: stopwatch.resetTimer,
                    child: const Text("reset"),
                  ),
                ],
              ),
            ),
            Consumer<Stopwatch>(
              builder: (context, value, child) => TextButton(
                onPressed: stopwatch.isConnected
                    ? stopwatch.disconnect
                    : stopwatch.connectAndListen,
                child: stopwatch.isConnected
                    ? const Text("disconnect")
                    : const Text("connect"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
