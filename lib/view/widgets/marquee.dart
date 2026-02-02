import 'dart:async';
import 'package:flutter/material.dart';

class InfiniteMarquee extends StatefulWidget {
  final String text;
  final double speed; // pixels per second
  final TextStyle? style;

  const InfiniteMarquee({
    super.key,
    required this.text,
    this.speed = 50,
    this.style,
  });

  @override
  State<InfiniteMarquee> createState() => _InfiniteMarqueeState();
}

class _InfiniteMarqueeState extends State<InfiniteMarquee>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startScrolling();
    });
  }

  void _startScrolling() {
    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!_scrollController.hasClients) return;

      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;

      final nextScroll = currentScroll + widget.speed / 60;

      if (nextScroll >= maxScroll) {
        _scrollController.jumpTo(0);
      } else {
        _scrollController.jumpTo(nextScroll);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Row(
            children: [
              Text(widget.text, style: widget.style),
              const SizedBox(width: 50),
              Text(widget.text, style: widget.style), // duplicate
            ],
          ),
        ],
      ),
    );
  }
}
