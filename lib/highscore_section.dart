import 'package:flutter/material.dart';
import 'package:weihnachtsquiz_blg_2025/app_colors.dart';
import 'package:weihnachtsquiz_blg_2025/highscore_storage.dart';
import 'package:weihnachtsquiz_blg_2025/match_result.dart';
import 'package:weihnachtsquiz_blg_2025/player_state.dart';

class HighscoreSection extends StatefulWidget {
  const HighscoreSection({super.key});

  @override
  State<HighscoreSection> createState() => _HighscoreSectionState();
}

class _HighscoreSectionState extends State<HighscoreSection> {
  bool loadingHighscore = true;

  @override
  void initState() {
    super.initState();
    loadHighscore();
  }

  Future<void> loadHighscore() async {
    final loaded = await HighscoreStorage.load();
    setState(() {
      globalHighscore
        ..clear()
        ..addAll(loaded);
      loadingHighscore = false;
    });
  }

  Future<void> resetHighscore() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Highscore zurücksetzen?"),
        content: const Text(
          "Alle gespeicherten Spiele und Statistiken werden gelöscht.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text("Abbrechen"),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text("Löschen"),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      globalHighscore.clear();
    });

    await HighscoreStorage.save(globalHighscore);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (loadingHighscore)
          const Center(child: CircularProgressIndicator())
        else if (globalHighscore.isNotEmpty) ...[
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Highscore 🏆",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: companyBlue,
              ),
            ),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: globalHighscore.length > 10
                ? 10
                : globalHighscore.length,
            itemBuilder: (context, index) {
              final result = globalHighscore[index];
              return _buildHighscoreCard(result, index);
            },
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Spieler-Statistik 📊",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: xmasGreen,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Builder(
            builder: (context) {
              final stats = _buildPlayerStats();
              if (stats.isEmpty) {
                return const Text("Noch keine Spiele gespielt.");
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: stats.length,
                itemBuilder: (context, index) {
                  return _buildPlayerStatsCard(stats[index], index);
                },
              );
            },
          ),
        ],
        if (globalHighscore.isNotEmpty) ...[
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: resetHighscore,
              icon: const Icon(Icons.delete_outline),
              label: const Text("Highscore zurücksetzen"),
            ),
          ),
        ],
      ],
    );
  }

  List<PlayerStats> _buildPlayerStats() {
    final Map<String, PlayerStats> map = {};

    for (final m in globalHighscore) {
      void addPlayer(String name, int points) {
        final key = name.trim().isEmpty ? "Unbekannt" : name.trim();
        final stats = map.putIfAbsent(key, () => PlayerStats(name: key));
        stats.games++;
        stats.totalPoints += points;
      }

      addPlayer(m.player1, m.score1);
      addPlayer(m.player2, m.score2);
    }

    final list = map.values.toList();
    // sortieren nach Gesamtpunkten
    list.sort((a, b) => b.totalPoints.compareTo(a.totalPoints));
    return list;
  }

  Widget _buildPlayerStatsCard(PlayerStats stats, int index) {
    final avg = stats.avgPoints.toStringAsFixed(1);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              child: Text("${index + 1}", style: const TextStyle(fontSize: 14)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stats.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Spiele: ${stats.games} · Gesamt: ${stats.totalPoints} · Ø: $avg",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighscoreCard(MatchResult result, int index) {
    final total = result.score1 + result.score2;

    // Podestfarben
    Color? background;
    if (index == 0) {
      background = companyGold.withValues(alpha: 0.35); // Gold
    } else if (index == 1) {
      background = companyBlue.withValues(alpha: 0.12); // Blau
    } else if (index == 2) {
      background = xmasGreen.withValues(alpha: 0.15); // Grün
    }

    final medal = _medalEmojiForIndex(index);

    return Card(
      color: background,
      elevation: index <= 2 ? 2 : 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              child: Text(
                medal ?? "${index + 1}",
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${result.player1} (${result.score1}) vs ${result.player2} (${result.score2})",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Gesamt: $total Punkte · ${_formatDate(result.playedAt)}",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _medalEmojiForIndex(int index) {
    switch (index) {
      case 0:
        return "🥇";
      case 1:
        return "🥈";
      case 2:
        return "🥉";
      default:
        return null;
    }
  }

  String _formatDate(DateTime dt) {
    // ganz simpel: TT.MM.JJ HH:MM
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final year = (dt.year % 100).toString().padLeft(2, '0');
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return "$day.$month.$year $hour:$minute";
  }
}
