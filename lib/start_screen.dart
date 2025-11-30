// --- Start-Screen -----------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:weihnachtsquiz_blg_2025/app_colors.dart';
import 'package:weihnachtsquiz_blg_2025/highscore_section.dart';
import 'package:weihnachtsquiz_blg_2025/quiz_screen.dart';
import 'package:weihnachtsquiz_blg_2025/snowfall_background.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final _player1Controller = TextEditingController(text: "Spieler 1");
  final _player2Controller = TextEditingController(text: "Spieler 2");

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _player1Controller.dispose();
    _player2Controller.dispose();
    super.dispose();
  }

  void _startGame() {
    final p1 = _player1Controller.text.trim().isEmpty
        ? "Spieler 1"
        : _player1Controller.text.trim();
    final p2 = _player2Controller.text.trim().isEmpty
        ? "Spieler 2"
        : _player2Controller.text.trim();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QuizScreen(player1: p1, player2: p2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final maxWidth = size.width > 500 ? 500.0 : size.width * 0.9;

    return Scaffold(
      body: SnowfallBackground(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(maxWidth: maxWidth),
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: xmasRed.withValues(alpha: 0.35)),
                boxShadow: [
                  BoxShadow(
                    color: companyBlue.withValues(alpha: 0.12),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.ac_unit, size: 48, color: companyBlue),

                  const SizedBox(height: 12),
                  const Text(
                    "Weihnachtsquiz-Duell 🎄",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: xmasGreen,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _player1Controller,
                    decoration: const InputDecoration(
                      labelText: "Name Spieler 1",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _player2Controller,
                    decoration: const InputDecoration(
                      labelText: "Name Spieler 2",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _startGame,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          "Spiel starten",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  HighscoreSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
