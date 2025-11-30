import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weihnachtsquiz_blg_2025/match_result.dart';

class HighscoreStorage {
  static const _key = 'highscore_v1';

  static Future<void> save(List<MatchResult> results) async {
    final prefs = await SharedPreferences.getInstance();
    final list = results.map((r) => r.toJson()).toList();
    final jsonString = jsonEncode(list);
    await prefs.setString(_key, jsonString);
  }

  static Future<List<MatchResult>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null || jsonString.isEmpty) return [];
    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded
          .map((e) => MatchResult.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // Falls etwas korrupt ist, einfach leere Liste zurückgeben
      return [];
    }
  }
}

// einfache globale Highscore-Liste (wird beim Start aus Storage geladen)
final List<MatchResult> globalHighscore = [];
