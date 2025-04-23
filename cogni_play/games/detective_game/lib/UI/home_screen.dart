import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'instructions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.95);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png', // make sure this matches your asset path
              fit: BoxFit.cover,
            ),
          ),
          // Settings icon (top-left)
          Positioned(
            top: 32,
            left: 20,
            child: IconButton(
              icon: Image.asset('assets/icons/settings.png',
              width: 50, 
              height: 50,
              ),
              onPressed: () {},
            ),
          ),
          // Profile icon (top-right)
          Positioned(
            top: 32,
            right: 20,
            child: Container(
              padding: EdgeInsets.all(8), // controls circle size
              decoration: BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Image.asset(
                  'assets/icons/profile.png',
                  width: 40,
                  height: 40,
                ),
                onPressed: () {},
                iconSize: 40, 
              ),
            ),
          ),
          // COGNIPLAY Logo Text
          Positioned(
            top: 15,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Image.asset('assets/icons/logo.png'),
                Text(
                  'COGNIPLAY',
                  style: GoogleFonts.luckiestGuy(
                    fontSize: 64,
                    color: Colors.black,
                  ),
                  textHeightBehavior: const TextHeightBehavior(
                    applyHeightToFirstAscent: false,
                    applyHeightToLastDescent: false,
                  ),
                ),
                Text(
                  'GAMES',
                  style: GoogleFonts.quicksand(
                    fontSize: 40,
                    color: Color(0xFFFDB825),
                    letterSpacing: 10,
                    fontWeight: FontWeight.w700,
                  ),
                  textHeightBehavior: const TextHeightBehavior(
                    applyHeightToFirstAscent: false,
                    applyHeightToLastDescent: false,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(top:200),
              child: Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Color(0xFFFFECD0),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 8),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'PICK YOUR GAME!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.luckiestGuy(
                        fontSize: 52,
                        color: Color(0xFFF9633E),
                      ),
                      
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTapDown: _onTapDown,
                      onTapUp: _onTapUp,
                      onTapCancel: _onTapCancel,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const InstructionsPage()),
                        );
                      },
                      child: AnimatedScale(
                        scale: _scale,
                        duration: const Duration(milliseconds: 100),
                        child: Container(
                          width: 250,
                          height: 250,
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
                          decoration: BoxDecoration(
                            color: Color(0xFFE2D4FF),
                            borderRadius: BorderRadius.circular(24),
                          ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/icons/search.png',
                              height: 125,
                              width: 125,
                            ),
                            const SizedBox(height: 15),
                            Text(
                              'Shadow Detective',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.luckiestGuy(
                                fontSize: 32,
                                height: 1.2,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          )
        ],
      ),
    );
  }
}
