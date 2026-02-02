import 'dart:async';
import 'package:flutter/material.dart';

class LiveTimer extends StatefulWidget {
  final DateTime startTime;

  const LiveTimer({super.key, required this.startTime});

  @override
  State<LiveTimer> createState() => _LiveTimerState();
}

class _LiveTimerState extends State<LiveTimer> {
  late Timer timer;
  late Duration diff;

  @override
  void initState() {
    super.initState();
    diff = DateTime.now().difference(widget.startTime);

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        diff = DateTime.now().difference(widget.startTime);
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Widget timeBox(String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        timeBox('${diff.inDays}', 'd'),
        const SizedBox(width: 6),
        timeBox('${diff.inHours % 24}', 'h'),
        const SizedBox(width: 6),
        timeBox('${diff.inMinutes % 60}', 'm'),
        const SizedBox(width: 6),
        timeBox('${diff.inSeconds % 60}', 's'),
      ],
    );
  }
}
