import 'package:flutter/material.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    // Start the jump animation after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Screen size for positioning
    final size = MediaQuery.of(context).size;
    // Define start and end positions (circle centers) as offsets
    final startX = size.width * 0.2;
    final startY = size.height * 0.7;
    final endX = size.width * 0.8;
    final endY = size.height * 0.4;
    final jumpHeight = 100.0; // Peak height of the jump
    // Character image size
    final charWidth = 50.0;
    final charHeight = 50.0;
    // Differences for interpolation
    final dx = endX - startX;
    final dy = endY - startY;

    return Scaffold(
      body: Stack(
        children: [
          // Background covers entire screen
          Positioned.fill(
            child: Image.asset('assets/background.png', fit: BoxFit.cover),
          ),
          // Current level marker (circle)
          Positioned(
            left: startX - 25, // center the 50px circle
            top: startY - 25,
            child: Container(
              width: 50, height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
            ),
          ),
          // Next level marker (circle)
          Positioned(
            left: endX - 25,
            top: endY - 25,
            child: Container(
              width: 50, height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
            ),
          ),
          // Animated character image
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final t = _controller.value;
              // Compute current position: linear + parabolic offset
              final xPos = startX + dx * t - charWidth / 2;
              final yPos = startY + dy * t - charHeight / 2
                             - 4 * jumpHeight * t * (1 - t);
              return Positioned(
                left: xPos,
                top: yPos,
                child: child!,
              );
            },
            // The character image (use your own asset path)
            child: Image.asset('assets/character.png',
                                width: charWidth, height: charHeight),
          ),
        ],
      ),
    );
  }
}
