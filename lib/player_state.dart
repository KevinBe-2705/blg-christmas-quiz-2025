class PlayerStats {
  final String name;
  int games;
  int totalPoints;

  PlayerStats({required this.name, this.games = 0, this.totalPoints = 0});

  double get avgPoints => games == 0 ? 0 : totalPoints / games;
}
