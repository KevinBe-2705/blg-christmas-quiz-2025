class MatchResult {
  final String player1;
  final String player2;
  final int score1;
  final int score2;
  final DateTime playedAt;

  MatchResult({
    required this.player1,
    required this.player2,
    required this.score1,
    required this.score2,
    required this.playedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'player1': player1,
      'player2': player2,
      'score1': score1,
      'score2': score2,
      'playedAt': playedAt.toIso8601String(),
    };
  }

  factory MatchResult.fromJson(Map<String, dynamic> json) {
    return MatchResult(
      player1: json['player1'] as String,
      player2: json['player2'] as String,
      score1: json['score1'] as int,
      score2: json['score2'] as int,
      playedAt: DateTime.parse(json['playedAt'] as String),
    );
  }
}
