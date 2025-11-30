// --- Ergebnis-Screen (mit Highscore-Update + Persistenz) --------------------

import 'package:flutter/material.dart';
import 'package:weihnachtsquiz_blg_2025/app_colors.dart';
import 'package:weihnachtsquiz_blg_2025/highscore_storage.dart';
import 'package:weihnachtsquiz_blg_2025/match_result.dart';
import 'package:weihnachtsquiz_blg_2025/snowfall_background.dart';
import 'package:weihnachtsquiz_blg_2025/start_screen.dart';

class ResultScreen extends StatefulWidget {
  final String player1;
  final String player2;
  final int score1;
  final int score2;
  final int totalQuestions;

  const ResultScreen({
    super.key,
    required this.player1,
    required this.player2,
    required this.score1,
    required this.score2,
    required this.totalQuestions,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _isNewHighscore = false;

  bool get _isPerfectScoreP1 =>
      widget.score1 == widget.totalQuestions && widget.totalQuestions > 0;

  bool get _isPerfectScoreP2 =>
      widget.score2 == widget.totalQuestions && widget.totalQuestions > 0;

  bool get _isPerfectBoth => _isPerfectScoreP1 && _isPerfectScoreP2;

  @override
  void initState() {
    super.initState();

    final result = MatchResult(
      player1: widget.player1,
      player2: widget.player2,
      score1: widget.score1,
      score2: widget.score2,
      playedAt: DateTime.now(),
    );

    globalHighscore.add(result);

    // Sortierung: nach Gesamtpunkten absteigend
    globalHighscore.sort((a, b) {
      final totalA = a.score1 + a.score2;
      final totalB = b.score1 + b.score2;
      return totalB.compareTo(totalA);
    });

    if (globalHighscore.length > 10) {
      globalHighscore.removeRange(10, globalHighscore.length);
    }

    // persistieren
    HighscoreStorage.save(globalHighscore);

    // Rang dieses Ergebnisses bestimmen
    final rank = globalHighscore.indexOf(result);
    _isNewHighscore = rank == 0;
  }

  String? get _easterEggText {
    final s1 = widget.score1;
    final s2 = widget.score2;

    // Easter Egg 1: beide 0 Punkte
    if (s1 == 0 && s2 == 0) {
      return "Ihr seid offiziell die Anti-Weihnachts-Genies 😅\nVielleicht doch nochmal den Glühwein zur Seite stellen?";
    }

    // Easter Egg 2: Perfektes Weihnachtswunder
    if (_isPerfectBoth) {
      return "Beide perfekt?! 🎄✨\nDas ist ein doppeltes Weihnachtswunder!";
    }
    if (_isPerfectScoreP1) {
      return "${widget.player1} hat ein\n🎁 PERFEKTES WEIHNACHTSWUNDER 🎁\ngeschafft!";
    }
    if (_isPerfectScoreP2) {
      return "${widget.player2} hat ein\n🎁 PERFEKTES WEIHNACHTSWUNDER 🎁\nvollbracht!";
    }

    return null;
  }

  String get _resultText {
    if (widget.score1 > widget.score2) {
      return "${widget.player1} hat gewonnen! 🎉";
    } else if (widget.score2 > widget.score1) {
      return "${widget.player2} hat gewonnen! 🎉";
    } else {
      return "Unentschieden! 🤝";
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final maxWidth = size.width > 500 ? 500.0 : size.width * 0.9;

    return Scaffold(
      body: SnowfallBackground(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: xmasRed.withValues(alpha: 0.35)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                if (_isNewHighscore)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: companyGold.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: companyBlue, width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.emoji_events),
                        const SizedBox(width: 8),
                        Text(
                          "Neuer Highscore!",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.emoji_events),
                      ],
                    ),
                  ),
                const Icon(Icons.celebration, size: 48),
                const SizedBox(height: 12),
                Text(
                  _resultText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_easterEggText != null &&
                    (_isPerfectScoreP1 || _isPerfectScoreP2 || _isPerfectBoth))
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(top: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          companyGold.withValues(alpha: 0.3),
                          xmasRed.withValues(alpha: 0.3),
                          companyBlue.withValues(alpha: 0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.shade700.withValues(alpha: 0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                      border: Border.all(
                        color: Colors.amber.shade700,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _easterEggText!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_easterEggText != null) ...[const SizedBox(height: 12)],
                const SizedBox(height: 24),
                Text(
                  "${widget.player1}: ${widget.score1} Punkte",
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  "${widget.player2}: ${widget.score2} Punkte",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const StartScreen()),
                        (route) => false,
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        "Nochmal spielen",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
