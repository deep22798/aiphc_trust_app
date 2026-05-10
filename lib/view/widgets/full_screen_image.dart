
import 'dart:math' as math;

import 'package:flutter/material.dart';

class FullImageViewer extends StatefulWidget {
  final String tag;
  final String imageUrl;

  const FullImageViewer({
    super.key,
    required this.tag,
    required this.imageUrl,
  });

  @override
  State<FullImageViewer> createState() => _FullImageViewerState();
}

class _FullImageViewerState extends State<FullImageViewer> {
  final TransformationController _controller = TransformationController();

  double _rotation = 0;

  void _zoomIn() {
    _controller.value = _controller.value.scaled(1.2);
  }

  void _zoomOut() {
    _controller.value = _controller.value.scaled(0.8);
  }

  void _reset() {
    _controller.value = Matrix4.identity();

    setState(() {
      _rotation = 0;
    });
  }

  void _rotateImage() {
    setState(() {
      _rotation += math.pi / 2; // 90 degree
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _rotateImage,
            icon: const Icon(Icons.rotate_right),
          ),
          IconButton(
            onPressed: _reset,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: InteractiveViewer(
              transformationController: _controller,
              minScale: 1,
              maxScale: 5,
              panEnabled: true,
              boundaryMargin: const EdgeInsets.all(100),
              child: Center(
                child: Transform.rotate(
                  angle: _rotation,
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (
                        context,
                        child,
                        loadingProgress,
                        ) {
                      if (loadingProgress == null) return child;

                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorBuilder: (_, __, ___) {
                      return const Center(
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.white,
                          size: 70,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white.withOpacity(0.15),
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}