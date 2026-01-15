import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:startwatch/widgets/clock_view.dart';

/// The main stopwatch view
class Startwatch extends StatefulWidget {
  const Startwatch({super.key});

  @override
  State<Startwatch> createState() => _StartwatchState();
}

class _StartwatchState extends State<Startwatch>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;

  bool running = false;

  int _accumulatedMs = 0; 
  int _resumeMs = 0;  

  int get elapsedMs {
    if (!running) return _accumulatedMs;
    final now = DateTime.now().millisecondsSinceEpoch;
    return _accumulatedMs + (now - _resumeMs);
  }

  // get the formatted time string for Y Years, W weeks, D days
  String get formattedDWYs {
    final totalSeconds = elapsedMs ~/ 1000;
    final days = totalSeconds ~/ 86400;
    final weeks = days ~/ 7;
    final years = days ~/ 365;

    final daysStr = days > 0 ? '$days D ' : '';
    final weeksStr = weeks > 0 ? '$weeks W ' : '';
    final yearsStr = years > 0 ? '$years Y ' : '';

    return '$yearsStr$weeksStr$daysStr'.trim();
  }

  /// get the formatted time string for HH:MM:SS.mmm where hours wraps every day
  String get formattedTime {
    final totalSeconds = elapsedMs ~/ 1000;
    final hours = (totalSeconds ~/ 3600) % 24;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    final milliseconds = elapsedMs % 1000; 
    final hoursStr = hours > 0 ? '${hours.toString().padLeft(2, '0')}:' : '';
    final minutesStr = (hours > 0 || minutes > 0)
        ? '${minutes.toString().padLeft(2, '0')}:'
        : '';
        
    final secondsStr = seconds.toString().padLeft(2, '0');
    final millisecondsStr = milliseconds.toString().padLeft(3, '0');  

    return '$hoursStr$minutesStr$secondsStr.$millisecondsStr';
  }

  String get formattedTotalTime {
    final totalSeconds = elapsedMs ~/ 1000;
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    final milliseconds = elapsedMs % 1000; 
    final hoursStr = hours > 0 ? '${hours.toString().padLeft(2, '0')}:' : '';
    final minutesStr = (hours > 0 || minutes > 0)
        ? '${minutes.toString().padLeft(2, '0')}:'
        : '';
        
    final secondsStr = seconds.toString().padLeft(2, '0');
    final millisecondsStr = milliseconds.toString().padLeft(3, '0');  

    return '$hoursStr$minutesStr$secondsStr.$millisecondsStr';
  }

  @override
  void initState() {
    super.initState();

    _ticker = createTicker((_) {
      if (running) setState(() {}); 
    })..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    
    super.dispose();
  }

  void _start() {
    if (running) return;
    setState(() {
      running = true;
      _resumeMs = DateTime.now().millisecondsSinceEpoch;
    });
  }

  void _stop() {
    if (!running) return;
    setState(() {
      _accumulatedMs = elapsedMs; 
      running = false;
    });
  }

  void _reset() {
    setState(() {
      running = false;
      _accumulatedMs = 0;
      _resumeMs = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    var size = mq.size;

    final ms = elapsedMs;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClockView(),
        Text(
          formattedDWYs,
          style: TextStyle(
            fontSize: .05 * size.width, 
            fontWeight: FontWeight.w500
          ),
        ),
        Text(
          '$formattedTime',
          style: TextStyle(
            fontSize: .08 * size.width, 
            fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: running ? null : _start,
              child: const Text('Start'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: running ? _stop : null,
              child: const Text('Stop'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _reset,
              child: const Text('Reset'),
            ),
            // add a debug button to add 1 milion miliseconds t othe thing (subtract from the resumed time thing)
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (running) {
                    _resumeMs -= 100000000;
                  } else {
                    _accumulatedMs += 100000000;
                  }
                });
              },
              child: const Text('+1,000,000 ms'),
            ),
          ],
        ),
      ],
    );
  }
}