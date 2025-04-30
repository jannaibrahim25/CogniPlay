import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'detective_game_screen.dart';

class InstructionsPage extends StatefulWidget {
  const InstructionsPage({super.key});

  

  @override
  State<InstructionsPage> createState() => _InstructionsPageState();
}

  class _InstructionsPageState extends State<InstructionsPage> {
  double _demoScale = 1.0;
  double _startGameScale = 1.0;

  Widget instructionItem(int number, String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: Text(
      '$number. $text',
      style: GoogleFonts.quicksand(
        fontSize: 32,
        color: Colors.black87,
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDB825),
      body: SafeArea(
        child: Stack(
          children: [
            // Back Button
            Positioned(
              top: 16,
              left: 16,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      'assets/icons/back.png',
                      width: 80,
                      height: 80,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10), 
                      child: 
                        Text(
                          'EXIT',
                          style: GoogleFonts.luckiestGuy(
                            fontSize: 48,
                            color: Colors.black,
                          ),
                        ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/logo.png',
                        width: 250,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'SHADOW DETECTIVE',
                        style: GoogleFonts.luckiestGuy(
                          fontSize: 52,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Instructions Box
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 150),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha:0.3),
                          blurRadius: 4,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HOW TO PLAY',
                          style: GoogleFonts.luckiestGuy(
                            fontSize: 48,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            instructionItem(1, 'You will be shown a scene with multiple objects!'),
                            instructionItem(2, 'Study the objects carefully before they disappear!'),
                            instructionItem(3, 'After 15 seconds, the objects will disappear.'),
                            instructionItem(4, 'Your job is to find and tap where each object was.'),
                            instructionItem(5, 'You get 3 chances to find all the objects!'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Demo Button with animation
                      GestureDetector(
                        onTapDown: (_) => setState(() => _demoScale = 0.95),
                        onTapUp: (_) {
                          setState(() => _demoScale = 1.0);
                        },
                        onTapCancel: () => setState(() => _demoScale = 1.0),
                        child: AnimatedScale(
                          scale: _demoScale,
                          duration: const Duration(milliseconds: 50),
                          child: SizedBox(
                            width: 300,
                            height: 120,
                            child: ElevatedButton(
                              onPressed: () {
                                // TODO: Handle Demo button action
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF989898),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 36,
                                  vertical: 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 4,
                              ),
                              child: Text(
                                'DEMO',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.luckiestGuy(
                                  color: Colors.white,
                                  fontSize: 42,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTapDown: (_) => setState(() => _startGameScale = 0.95),
                        onTapUp: (_) => setState(() => _startGameScale = 1.0),
                        onTapCancel: () => setState(() => _startGameScale = 1.0),
                        child: AnimatedScale(
                          scale: _startGameScale,
                          duration: const Duration(milliseconds: 50),
                          child: SizedBox(
                            width: 300,
                            height: 120,
                            child: ElevatedButton(
                              onPressed: () {
                                // TODO: Handle Start Game action
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const DetectiveGameScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8C52FF),
                                padding: const EdgeInsets.only(
                                  top: 17,
                                  bottom: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 4,
                              ),
                              child: Text(
                                'START\nGAME',
                                style: GoogleFonts.luckiestGuy(
                                  fontSize: 42,
                                  color: Colors.white,
                                  height: 1.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
