import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LevelIntroOverlay extends StatefulWidget {
  final int levelNumber;
  final VoidCallback onDismiss;

  const LevelIntroOverlay({
    Key? key,
    required this.levelNumber,
    required this.onDismiss,
  }) : super(key: key);

  @override
  _LevelIntroOverlayState createState() => _LevelIntroOverlayState();
}

class _LevelIntroOverlayState extends State<LevelIntroOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0), // from the right
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    Future.delayed(const Duration(seconds: 8), () async {
      await _controller.reverse();
      widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/ocean_level.jpg',
                fit: BoxFit.fill,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(right: 0, top: 150),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/character.png', width: 300),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(bottom: 200),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(240),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Congrats! You are on level ${widget.levelNumber}! \nStudy the objects carefully \nThey will disappear in 15 seconds!',
                        style: GoogleFonts.luckiestGuy(
                          fontSize: 32,
                          height: 1.5,
                          color: Color(0xFFF9633E),
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
