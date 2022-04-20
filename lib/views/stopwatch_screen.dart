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
                        ? stopwatch.pauseTimer
                        : stopwatch.startTimer,
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
