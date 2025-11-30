// --- Quiz -------------------------------------------------------------------

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:weihnachtsquiz_blg_2025/app_colors.dart';
import 'package:weihnachtsquiz_blg_2025/result_screen.dart';
import 'package:weihnachtsquiz_blg_2025/snowfall_background.dart';

class QuizScreen extends StatefulWidget {
  final String player1;
  final String player2;

  const QuizScreen({super.key, required this.player1, required this.player2});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class Question {
  final String text;
  final List<String> answers;
  final int correctIndex;
  final Difficulty difficulty;

  Question({
    required this.text,
    required this.answers,
    required this.correctIndex,
    required this.difficulty,
  });
}

class _QuizScreenState extends State<QuizScreen> {
  static const int questionTimeSeconds = 20;

  late List<Question> _questions;
  int _currentQuestionIndex = 0;
  int _currentPlayerIndex = 0; // 0 = player1, 1 = player2
  final List<int> _scores = [0, 0];

  int? _selectedAnswerIndex;
  bool _answered = false;

  // Timer
  int _remainingSeconds = questionTimeSeconds;
  Timer? _timer;
  Color? _partyMessageBackgroundColor;

  // Party-Mode
  final Random _random = Random();
  String? _partyMessage;

  final List<String> _partyCorrectMessages = const [
    "Ho ho ho, das war richtig! 🎅",
    "Volltreffer unter dem Weihnachtsbaum! 🎁",
    "Du bist der Stern auf der Tanne! ⭐",
    "Glühwein-Intelligenz aktiviert! 🍷",
    "Das Christkind applaudiert dir! 👼",
    "Mehr Treffer als ein Rentier auf Red Bull! 🦌⚡",
    "Du bist heißer als der Ofen voller Plätzchen! 🍪🔥",
    "Santa ruft an: Er will deine Skills! 📞🎅",
    "Das war weihnachtlich präzise! 🎄",
    "Du bist offiziell Elite-Elf! 🧝‍♂️",
    "Goldene Glocke für dich! 🔔✨",
    "Du triffst härter als Schneebälle im Dezember! ❄️👊",
    "Das war süßer als gebrannte Mandeln! 😋",
    "Sauber! Der Nikolaus nickt zufrieden. 🎅👍",
    "Ein Treffer wie frisch vom Nordpol geliefert! 📦❄️",
    "Du bist der Geist der Weihnacht… der cleveren Weihnacht! 👻🎄",
    "Bessere Antwort als jede Weihnachtsplaylist! 🎶",
    "Du wärst ein Top-Kandidat für Santas Quizteam! 🏆",
    "So hell wie die Lichterkette! ✨",
    "Das war smarter als jeder Schrottwichtel-Gag! 😂🎁",
  ];

  final List<String> _partyWrongMessages = const [
    "Ups, das war wohl der falsche Schlitten… 🛷",
    "Der Weihnachtsmann schüttelt den Kopf. 😅",
    "Fast! Die Elfen applaudieren trotzdem. 🧝",
    "Das Rentier hat gelacht – aber nicht vor Freude. 🦌",

    "Oh je… das Geschenk war leer. 🎁😬",
    "So daneben wie ein schiefer Weihnachtsbaum! 🎄↪️",
    "Das Christkind schreibt gerade einen Beschwerdebrief… 😇📝",
    "Das war ein Eiszapfen-Moment. 🧊",
    "Kling Glöckchen… oh wait. Falsch. 🔔😵‍💫",
    "Die Kekse waren wohl doch zu hart. 🍪💔",
    "Das hat selbst Rudolph nicht kommen sehen. 😭🦌",
    "Santa stampft frustriert im Schnee. ❄️😤",
    "Uff… da rutscht die Tanne weg. 🌲💥",
    "Vom Nordpol kommt ein enttäuschtes ‚Oof‘. 📡😅",
    "Plätzchenpunkt geht an jemand anderen! 🍪➡️🤷",
    "Das war ein Geschenk mit falschem Etikett. 🎁❌",
    "Die Lichterkette ist ausgefallen… wie deine Antwort. 💡😬",
    "Das Rentierteam diskutiert deine Entscheidung. 🦌🦌🦌",
    "Falscher Weg zum Schlitten. GPS recalculating. 🛰️😅",
    "Vielleicht morgen weniger Glühwein? 🍷😂",
  ];

  final List<String> _partyTimeoutMessages = const [
    "Die Zeit ist geschmolzen wie Schnee! ❄️",
    "Zu spät – der Schlitten ist schon weg! 🛷",
    "Zeit abgelaufen! Vielleicht zu viel Plätzchen? 🍪",
    "Santauhr sagt: Nope! ⏰😂",
    "Das war langsamer als ein Rentier ohne Frühstück. 🦌🥱",
    "Die Elfen haben dich überholt – und die sind winzig! 🧝‍♀️💨",
    "Der Weihnachtsmann hat weitergeklickt. 📱🎅",
    "Zu spät! Das Geschenk ist schon verteilt. 🎁➡️😢",
    "Die Lichterkette hat länger gehalten als du. 💡⏳",
    "Tannennadel-Moment: *zu spät!*. 🌲⏰",
    "Das war eine sehr… besinnliche Pause. 😴🎄",
  ];

  @override
  void initState() {
    super.initState();
    _questions = _buildQuestions();
    _questions.shuffle();
    if (_questions.length > 20) {
      _questions = _questions.sublist(0, 20);
    }
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  List<Question> _buildQuestions() {
    return [
      // ------------------------------
      // EASY (20 Fragen)
      // ------------------------------
      Question(
        text: "Was stellt man traditionell in den Adventskranz?",
        answers: ["Zwei Kerzen", "Drei Kerzen", "Vier Kerzen", "Keine Kerzen"],
        correctIndex: 2,
        difficulty: Difficulty.easy,
      ),
      Question(
        text: "Welche Farbe haben klassische Christbaumkugeln oft?",
        answers: ["Pink", "Rot", "Schwarz", "Lila"],
        correctIndex: 1,
        difficulty: Difficulty.easy,
      ),
      Question(
        text: "Was isst man oft zu Weihnachten?",
        answers: ["Sushi", "Kartoffelsalat & Würstchen", "Pommes", "Burger"],
        correctIndex: 1,
        difficulty: Difficulty.easy,
      ),
      Question(
        text: "Welches Tier hat eine rote Nase?",
        answers: ["Blitzen", "Rudolph", "Comet", "Donner"],
        correctIndex: 1,
        difficulty: Difficulty.easy,
      ),
      Question(
        text: "Was sagt man häufig an Weihnachten?",
        answers: [
          "Frohe Ostern!",
          "Guten Rutsch!",
          "Frohe Weihnachten!",
          "Mahlzeit!",
        ],
        correctIndex: 2,
        difficulty: Difficulty.easy,
      ),
      Question(
        text: "Welche Süßigkeit ist besonders zu Weihnachten beliebt?",
        answers: ["Gummibärchen", "Lebkuchen", "Kaubonbons", "Weingummi"],
        correctIndex: 1,
        difficulty: Difficulty.easy,
      ),
      Question(
        text: "Welche Figur bringt in vielen Filmen Geschenke?",
        answers: ["Batman", "Der Weihnachtsmann", "Der Superheld", "Der Koch"],
        correctIndex: 1,
        difficulty: Difficulty.easy,
      ),
      Question(
        text: "Wann feiert man Weihnachten?",
        answers: ["1. April", "24.–26. Dezember", "6. Juni", "1. Januar"],
        correctIndex: 1,
        difficulty: Difficulty.easy,
      ),
      Question(
        text: "Welche Pflanze ist typisch zu Weihnachten?",
        answers: [
          "Gänseblümchen",
          "Palmblatt",
          "Weihnachtsstern",
          "Sonnenblume",
        ],
        correctIndex: 2,
        difficulty: Difficulty.easy,
      ),
      Question(
        text: "Welche Figur wohnt am Nordpol?",
        answers: ["Zahnfee", "Weihnachtsmann", "Osterhase", "Kobold"],
        correctIndex: 1,
        difficulty: Difficulty.easy,
      ),
      Question(
        text: "Welche Farbe hat der Bart des Weihnachtsmannes?",
        answers: ["Schwarz", "Rot", "Weiß", "Braun"],
        correctIndex: 2,
        difficulty: Difficulty.easy,
      ),
      Question(
        text: "Welches Getränk ist traditionell warm?",
        answers: ["Glühwein", "Eistee", "Cola", "Milchshake"],
        correctIndex: 0,
        difficulty: Difficulty.easy,
      ),
      Question(
        text: "Was hängt man an einen Tannenbaum?",
        answers: ["Luftballons", "Kugeln & Lichter", "Poster", "Socken"],
        correctIndex: 1,
        difficulty: Difficulty.easy,
      ),
      Question(
        text: "Wie nennt man den 24. Dezember?",
        answers: ["Heiligabend", "Nikolausabend", "Silvester", "Krampusnacht"],
        correctIndex: 0,
        difficulty: Difficulty.easy,
      ),
      Question(
        text: "Wer hilft dem Weihnachtsmann?",
        answers: ["Polizisten", "Elfen", "Drachen", "Katzen"],
        correctIndex: 1,
        difficulty: Difficulty.easy,
      ),
      Question(
        text: "In welchem Monat liegt Heiligabend?",
        answers: ["Oktober", "November", "Dezember", "Januar"],
        correctIndex: 2,
        difficulty: Difficulty.easy,
      ),
      Question(
        text: "Was ist ein typisches Weihnachtslied?",
        answers: ["Happy Birthday", "Jingle Bells", "Atemlos", "YMCA"],
        correctIndex: 1,
        difficulty: Difficulty.easy,
      ),
      Question(
        text: "Welches Tier sieht man oft als Figur zu Weihnachten?",
        answers: ["Elefant", "Rentier", "Giraffe", "Pinguin"],
        correctIndex: 1,
        difficulty: Difficulty.easy,
      ),
      Question(
        text: "Was macht man typischerweise im Advent?",
        answers: [
          "Schwimmen gehen",
          "Geschenke kaufen",
          "Rasen mähen",
          "Eier bemalen",
        ],
        correctIndex: 1,
        difficulty: Difficulty.easy,
      ),
      Question(
        text: "Womit backt man typischerweise Plätzchen?",
        answers: ["Holz", "Teig", "Sand", "Steine"],
        correctIndex: 1,
        difficulty: Difficulty.easy,
      ),

      // ------------------------------
      // MEDIUM (20 Fragen)
      // ------------------------------
      Question(
        text: "Wie heißt das Rentier mit der roten Nase?",
        answers: ["Rudolph", "Comet", "Dasher", "Prancer"],
        correctIndex: 0,
        difficulty: Difficulty.medium,
      ),
      Question(
        text:
            "Welches Land gilt als Ursprung des modernen Weihnachtsmannbildes?",
        answers: ["Deutschland", "USA", "Norwegen", "Russland"],
        correctIndex: 1,
        difficulty: Difficulty.medium,
      ),
      Question(
        text: "Was bedeutet der Begriff 'Advent'?",
        answers: ["Ankunft", "Fest", "Winter", "Frohsinn"],
        correctIndex: 0,
        difficulty: Difficulty.medium,
      ),
      Question(
        text: "Welcher Brauch stammt aus Deutschland?",
        answers: ["Adventskranz", "Thanksgiving", "Halloween", "Valentinstag"],
        correctIndex: 0,
        difficulty: Difficulty.medium,
      ),
      Question(
        text:
            "Welche Süßigkeit ist besonders in der Schweiz zu Weihnachten beliebt?",
        answers: ["Zopf", "Mailänderli", "Marzipanbrot", "Mousse au Chocolat"],
        correctIndex: 1,
        difficulty: Difficulty.medium,
      ),
      Question(
        text: "Welcher Name gehört NICHT zu den acht traditionellen Rentieren?",
        answers: ["Dancer", "Vixen", "Krampus", "Cupid"],
        correctIndex: 2,
        difficulty: Difficulty.medium,
      ),
      Question(
        text: "Welche Farbe hat ein traditioneller Adventskranz?",
        answers: ["Blau", "Gold", "Grün", "Schwarz"],
        correctIndex: 2,
        difficulty: Difficulty.medium,
      ),
      Question(
        text: "Wie heißt der 6. Dezember?",
        answers: ["Nikolaustag", "Heiligabend", "Dreikönige", "Lichterfest"],
        correctIndex: 0,
        difficulty: Difficulty.medium,
      ),
      Question(
        text: "Welches Getränk ist typisch in den USA an Weihnachten?",
        answers: ["Eggnog", "Mate", "Buttermilch", "Margarita"],
        correctIndex: 0,
        difficulty: Difficulty.medium,
      ),
      Question(
        text: "Wie heißt das Fest am 26. Dezember in UK?",
        answers: ["Gift Day", "Boxing Day", "Present Day", "Santa Day"],
        correctIndex: 1,
        difficulty: Difficulty.medium,
      ),
      Question(
        text: "Wo steht laut Tradition der Weihnachtsmann?",
        answers: ["Südpol", "Nordpol", "Mittelmeer", "Schwarzwald"],
        correctIndex: 1,
        difficulty: Difficulty.medium,
      ),
      Question(
        text: "Welche Süßigkeit kommt oft in den Nikolausstiefel?",
        answers: ["Chips", "Orangen & Nüsse", "Lakritz", "Kuchen"],
        correctIndex: 1,
        difficulty: Difficulty.medium,
      ),
      Question(
        text: "Wer bringt in Italien die Geschenke?",
        answers: ["La Befana", "Il Babbo", "Die Hexe Clara", "Ein Rentier"],
        correctIndex: 0,
        difficulty: Difficulty.medium,
      ),
      Question(
        text: "Was zündet man an Heiligabend oft an?",
        answers: ["Raketen", "Wunderkerzen", "Fackeln", "Feuerwerk"],
        correctIndex: 1,
        difficulty: Difficulty.medium,
      ),
      Question(
        text: "Welcher Weihnachtsfilm ist extrem bekannt?",
        answers: [
          "Kevin – Allein zu Haus",
          "Jurassic Park",
          "Batman Returns",
          "Terminator 2",
        ],
        correctIndex: 0,
        difficulty: Difficulty.medium,
      ),
      Question(
        text: "Was basteln Kinder oft im Advent?",
        answers: ["Drachen", "Weihnachtssterne", "Segelboote", "Laternen"],
        correctIndex: 1,
        difficulty: Difficulty.medium,
      ),
      Question(
        text: "Was ist 'Spekulatius'?",
        answers: ["Fleischgericht", "Gewürzkeks", "Getränk", "Gemüse"],
        correctIndex: 1,
        difficulty: Difficulty.medium,
      ),
      Question(
        text: "Was kommt bei vielen Bräuchen an den Weihnachtsbaum?",
        answers: ["Eier", "Lichter & Kugeln", "Schlüssel", "Flaschen"],
        correctIndex: 1,
        difficulty: Difficulty.medium,
      ),
      Question(
        text: "Was macht man im Adventskalender?",
        answers: [
          "Fahrräder reparieren",
          "Täglich ein Türchen öffnen",
          "Singen",
          "Putzen",
        ],
        correctIndex: 1,
        difficulty: Difficulty.medium,
      ),

      // ------------------------------
      // HARD (20 Fragen)
      // ------------------------------
      Question(
        text: "In welchem Land gibt es den Brauch 'Julbock'?",
        answers: ["Dänemark", "Schweden", "Island", "Estland"],
        correctIndex: 1,
        difficulty: Difficulty.hard,
      ),
      Question(
        text: "Wie heißt der Weihnachtsmann in Russland?",
        answers: ["Väterchen Frost", "Ded Rakia", "Novy Moroz", "Frostnik"],
        correctIndex: 0,
        difficulty: Difficulty.hard,
      ),
      Question(
        text: "Wer schrieb das Lied 'Stille Nacht'?",
        answers: ["Joseph Mohr", "Johann Bach", "Ludwig Mozart", "Hugo Stein"],
        correctIndex: 0,
        difficulty: Difficulty.hard,
      ),
      Question(
        text:
            "Wie viele Rentiere zieht der Schlitten laut Gedicht 'A Visit from St. Nicholas'?",
        answers: ["6", "8", "9", "12"],
        correctIndex: 1,
        difficulty: Difficulty.hard,
      ),
      Question(
        text: "Welche Süßigkeit ist in Spanien Heiligabend typisch?",
        answers: ["Churros", "Turrón", "Flan", "Roscón"],
        correctIndex: 1,
        difficulty: Difficulty.hard,
      ),
      Question(
        text: "Was ist 'Krampus'?",
        answers: [
          "Österreichischer Dämon",
          "Norwegischer Troll",
          "Russische Hexe",
          "Italienischer Elf",
        ],
        correctIndex: 0,
        difficulty: Difficulty.hard,
      ),
      Question(
        text: "Welche Stadt gilt als Geburtsort des Adventskalenders?",
        answers: ["München", "Augsburg", "Berlin", "Hamburg"],
        correctIndex: 1,
        difficulty: Difficulty.hard,
      ),
      Question(
        text: "Wie heißt die israelische Variante des Lichterfestes?",
        answers: ["Purim", "Yom Kippur", "Chanukka", "Sukkot"],
        correctIndex: 2,
        difficulty: Difficulty.hard,
      ),
      Question(
        text: "Welche Pflanze symbolisiert in Großbritannien den Kussbrauch?",
        answers: ["Efeu", "Tannenzweig", "Misteln", "Zedernzweig"],
        correctIndex: 2,
        difficulty: Difficulty.hard,
      ),
      Question(
        text:
            "Wie viele Geschenke bekommt man laut ‚12 Days of Christmas‘ insgesamt?",
        answers: ["28", "78", "364", "144"],
        correctIndex: 2,
        difficulty: Difficulty.hard,
      ),
      Question(
        text: "In welchem Jahr wurde 'Last Christmas' veröffentlicht?",
        answers: ["1984", "1990", "1998", "1977"],
        correctIndex: 0,
        difficulty: Difficulty.hard,
      ),
      Question(
        text: "Welche Figur kommt in Island zu Weihnachten?",
        answers: [
          "13 Weihnachtskerle",
          "Der Schneemagier",
          "Der Eiswolf",
          "Der Winterdrache",
        ],
        correctIndex: 0,
        difficulty: Difficulty.hard,
      ),
      Question(
        text: "Wie heißt die traditionelle französische Weihnachtsspeise?",
        answers: ["Bouillabaisse", "Bûche de Noël", "Coq Rouge", "Pain Rouge"],
        correctIndex: 1,
        difficulty: Difficulty.hard,
      ),
      Question(
        text: "Welches deutsche Lied beginnt mit „Macht hoch die Tür“?",
        answers: [
          "Kirchenchorlied",
          "Adventslied",
          "Abendlied",
          "Nikolauslied",
        ],
        correctIndex: 1,
        difficulty: Difficulty.hard,
      ),
      Question(
        text:
            "Welcher Weihnachtsbaum war der erste kommerziell beleuchtete Baum?",
        answers: [
          "New York 1899",
          "London 1820",
          "New York 1882",
          "Berlin 1910",
        ],
        correctIndex: 2,
        difficulty: Difficulty.hard,
      ),
      Question(
        text: "Welche nordische Kreatur bringt Kindern Kohle?",
        answers: ["Jolakotturinn", "Joulupukki", "Knecht Pudding", "Tomte"],
        correctIndex: 0,
        difficulty: Difficulty.hard,
      ),
      Question(
        text: "Welches Getränk war früher ein Luxusgut zu Weihnachten?",
        answers: ["Kakao", "Kaffee", "Bier", "Apfelsaft"],
        correctIndex: 0,
        difficulty: Difficulty.hard,
      ),
      Question(
        text:
            "In welchem deutschen Bundesland steht der berühmte Dresdner Striezelmarkt?",
        answers: ["Bayern", "Sachsen", "NRW", "Hessen"],
        correctIndex: 1,
        difficulty: Difficulty.hard,
      ),
      Question(
        text: "Welches Geschenk brachte laut Bibel keiner der drei Weisen?",
        answers: ["Gold", "Myrrhe", "Wein", "Weihrauch"],
        correctIndex: 2,
        difficulty: Difficulty.hard,
      ),
      Question(
        text: "Wie heißt der berühmte Nussknacker aus Tchaikovskys Werk?",
        answers: ["Der Prinz", "Der König", "Der Knirps", "Der Soldat"],
        correctIndex: 0,
        difficulty: Difficulty.hard,
      ),

      // ------------------------------
      // EXPERT (20 Fragen)
      // ------------------------------
      Question(
        text:
            "In welchem Jahr wurde der erste belegte Weihnachtsbaum aufgestellt?",
        answers: ["1419", "1597", "1833", "1901"],
        correctIndex: 0,
        difficulty: Difficulty.expert,
      ),
      Question(
        text:
            "Welche Nation führt weltweit den pro-Kopf-Verbrauch von Zimt zur Weihnachtszeit an?",
        answers: ["Schweden", "Deutschland", "USA", "Kanada"],
        correctIndex: 1,
        difficulty: Difficulty.expert,
      ),
      Question(
        text: "Wie viele Lichter besitzt der traditionelle Herrnhuter Stern?",
        answers: ["18", "20", "26", "32"],
        correctIndex: 2,
        difficulty: Difficulty.expert,
      ),
      Question(
        text: "Welcher Komponist schrieb das Weihnachtsoratorium?",
        answers: ["Bach", "Händel", "Mozart", "Telemann"],
        correctIndex: 0,
        difficulty: Difficulty.expert,
      ),
      Question(
        text:
            "Wie viele Türchen hatte der erste aufs Papier gedruckte Adventskalender?",
        answers: ["12", "24", "30", "31"],
        correctIndex: 1,
        difficulty: Difficulty.expert,
      ),
      Question(
        text: "Welches ist das älteste bekannte Weihnachtslied?",
        answers: [
          "Resonet in Laudibus",
          "In Dulci Jubilo",
          "Stille Nacht",
          "O Come Emmanuel",
        ],
        correctIndex: 0,
        difficulty: Difficulty.expert,
      ),
      Question(
        text:
            "In welchem Land wird der Weihnachtsschinken ‚Julskinka‘ gegessen?",
        answers: ["Finnland", "Schweden", "Island", "Norwegen"],
        correctIndex: 1,
        difficulty: Difficulty.expert,
      ),
      Question(
        text: "Wie lange dauerte das Komponieren von „Stille Nacht“?",
        answers: ["1 Tag", "10 Jahre", "3 Monate", "2 Wochen"],
        correctIndex: 0,
        difficulty: Difficulty.expert,
      ),
      Question(
        text:
            "Wie viele Gaben brachte die heilige Lucia in der Legende mit sich?",
        answers: ["7", "10", "12", "3"],
        correctIndex: 2,
        difficulty: Difficulty.expert,
      ),
      Question(
        text:
            "Welche Farbe hatte der ursprüngliche Weihnachtsmann der Coca-Cola Kampagne?",
        answers: ["Grün", "Schwarz", "Rot", "Gelb"],
        correctIndex: 2,
        difficulty: Difficulty.expert,
      ),
      Question(
        text:
            "Wie lange dauerte die Entstehung des Nürnberger Christkindlesmarkts historisch?",
        answers: ["Über 400 Jahre", "50 Jahre", "200 Jahre", "80 Jahre"],
        correctIndex: 0,
        difficulty: Difficulty.expert,
      ),
      Question(
        text: "Welcher Weihnachtsbrauch entstand durch Martin Luther?",
        answers: [
          "Christkind statt Nikolaus",
          "Tannenbaum dekorieren",
          "Weihnachtskugeln benutzen",
          "Schneebälle werfen",
        ],
        correctIndex: 0,
        difficulty: Difficulty.expert,
      ),
      Question(
        text:
            "Wie viele Pfeifen trägt der Nussknacker-König in historischen Darstellungen?",
        answers: ["1", "3", "5", "Keine"],
        correctIndex: 3,
        difficulty: Difficulty.expert,
      ),
      Question(
        text:
            "Wie viele Versionen des Liedes ‚Last Christmas‘ existieren offiziell?",
        answers: ["23", "52", "109", "über 500"],
        correctIndex: 3,
        difficulty: Difficulty.expert,
      ),
      Question(
        text: "Welches Land exportiert weltweit die meisten Weihnachtsbäume?",
        answers: ["Kanada", "Dänemark", "Deutschland", "USA"],
        correctIndex: 1,
        difficulty: Difficulty.expert,
      ),
      Question(
        text: "Was bedeutet der Name ‚Nikolaus‘ ursprünglich?",
        answers: [
          "Sieger des Volkes",
          "Gabe der Götter",
          "Weiser Mann",
          "Freund der Kinder",
        ],
        correctIndex: 0,
        difficulty: Difficulty.expert,
      ),
      Question(
        text: "Welches Material wurde vor Kugeln an Tannen gehängt?",
        answers: ["Äpfel", "Keramik", "Zuckerbrot", "Metallnägel"],
        correctIndex: 0,
        difficulty: Difficulty.expert,
      ),
      Question(
        text: "Wie viele Strophen hat das Lied ‚O Tannenbaum‘?",
        answers: ["2", "3", "4", "5"],
        correctIndex: 1,
        difficulty: Difficulty.expert,
      ),
      Question(
        text:
            "Aus welchem Land stammt die Tradition der Glas-Weihnachtskugeln?",
        answers: ["Frankreich", "Tschechien", "Deutschland", "Österreich"],
        correctIndex: 2,
        difficulty: Difficulty.expert,
      ),
      Question(
        text:
            "Welches Jahr gilt als Startpunkt der modernen Weihnachtsbräuche?",
        answers: ["1600", "1800", "1840", "1912"],
        correctIndex: 2,
        difficulty: Difficulty.expert,
      ),
    ];
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = questionTimeSeconds;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 1) {
        timer.cancel();
        _onTimeUp();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  String _randomPartyMessage(bool correct, {bool timedOut = false}) {
    _setPartyMessageBackgroundColor(correct, timedOut: timedOut);
    if (timedOut) {
      return _partyTimeoutMessages[_random.nextInt(
        _partyTimeoutMessages.length,
      )];
    }
    if (correct) {
      return _partyCorrectMessages[_random.nextInt(
        _partyCorrectMessages.length,
      )];
    } else {
      return _partyWrongMessages[_random.nextInt(_partyWrongMessages.length)];
    }
  }

  Color _setPartyMessageBackgroundColor(bool correct, {bool timedOut = false}) {
    if (timedOut) {
      return Colors.orangeAccent.withValues(alpha: 0.4);
    }
    if (correct) {
      return Colors.greenAccent.withValues(alpha: 0.4);
    } else {
      return Colors.redAccent.withValues(alpha: 0.4);
    }
  }

  void _onTimeUp() {
    if (_answered) return;
    setState(() {
      _answered = true;
      _selectedAnswerIndex = null; // niemand hat geantwortet
      _partyMessage = _randomPartyMessage(false, timedOut: true);
      _partyMessageBackgroundColor = _setPartyMessageBackgroundColor(
        false,
        timedOut: true,
      );
    });
  }

  void _onAnswerTap(int index) {
    if (_answered) return;

    _timer?.cancel();

    final question = _questions[_currentQuestionIndex];
    final isCorrect = index == question.correctIndex;

    setState(() {
      _selectedAnswerIndex = index;
      _answered = true;

      if (isCorrect) {
        _scores[_currentPlayerIndex]++;
      }

      _partyMessage = _randomPartyMessage(isCorrect);
      _partyMessageBackgroundColor = _setPartyMessageBackgroundColor(isCorrect);
    });
  }

  void _nextQuestion() {
    _timer?.cancel();

    if (_currentQuestionIndex + 1 >= _questions.length) {
      // Quiz zu Ende
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            player1: widget.player1,
            player2: widget.player2,
            score1: _scores[0],
            score2: _scores[1],
            totalQuestions: _questions.length,
          ),
        ),
      );
    } else {
      setState(() {
        _currentQuestionIndex++;
        _currentPlayerIndex = 1 - _currentPlayerIndex; // Spieler wechseln
        _selectedAnswerIndex = null;
        _answered = false;
        _partyMessage = null;
        _partyMessageBackgroundColor = null;
      });
      _startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];
    final currentPlayerName = _currentPlayerIndex == 0
        ? widget.player1
        : widget.player2;

    final size = MediaQuery.of(context).size;
    final maxWidth = size.width > 700 ? 700.0 : size.width * 0.95;

    Color timerColor;
    if (_remainingSeconds > 10) {
      timerColor = xmasGreen;
    } else if (_remainingSeconds > 5) {
      timerColor = companyGold;
    } else {
      timerColor = xmasRed;
    }

    return Scaffold(
      body: SnowfallBackground(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: companyBlue.withValues(alpha: 0.25)),
            ),
            child: Column(
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
                // Punktestand + Frage
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildScoreChip(
                      widget.player1,
                      _scores[0],
                      isActive: _currentPlayerIndex == 0,
                    ),
                    Column(
                      children: [
                        Text(
                          "Frage ${_currentQuestionIndex + 1} von ${_questions.length}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.timer, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              "${_remainingSeconds}s",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: timerColor,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    _buildScoreChip(
                      widget.player2,
                      _scores[1],
                      isActive: _currentPlayerIndex == 1,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text(
                        "Am Zug: ",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        currentPlayerName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: xmasGreen,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 2,
                        color: companyGold.withValues(alpha: 0.35),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 40,
                          ),
                          child: Text(
                            question.text,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 12,
                      top: 12,
                      child: question.difficulty.buildDifficultyIcon(),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
                Expanded(
                  child: ListView.builder(
                    itemCount: question.answers.length,
                    itemBuilder: (context, index) {
                      final answerText = question.answers[index];
                      final isSelected = _selectedAnswerIndex == index;
                      final isCorrect = question.correctIndex == index;

                      Color? tileColor;
                      if (_answered && isSelected && isCorrect) {
                        tileColor = xmasGreen.withValues(alpha: 0.7);
                      } else if (_answered && isSelected && !isCorrect) {
                        tileColor = xmasRed.withValues(alpha: 0.3);
                      } else if (_answered && !isSelected && isCorrect) {
                        tileColor = xmasGreen.withValues(alpha: 0.18);
                      }

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        color: tileColor,
                        child: ListTile(
                          onTap: () => _onAnswerTap(index),
                          title: Text(
                            answerText,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (_partyMessage != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _partyMessageBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _partyMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 40),
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: _answered ? _nextQuestion : null,
                    child: Text(
                      _currentQuestionIndex + 1 >= _questions.length
                          ? "Ergebnis anzeigen"
                          : "Nächste Frage",
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

  Widget _buildScoreChip(String name, int score, {bool isActive = false}) {
    return Chip(
      avatar: isActive ? Icon(Icons.star, color: Colors.amber[900]) : null,
      label: Row(
        children: [
          Text("$name:", style: const TextStyle(fontSize: 16)),
          Text(
            " $score",
            style: const TextStyle(
              fontSize: 20,
              color: companyBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

enum Difficulty {
  easy,
  medium,
  hard,
  expert;

  String difficultyName(Difficulty level) {
    switch (level) {
      case Difficulty.easy:
        return "easy";
      case Difficulty.medium:
        return "medium";
      case Difficulty.hard:
        return "hard";
      case Difficulty.expert:
        return "expert";
    }
  }

  Widget buildDifficultyIcon() {
    int starCount;
    Color color;
    double size = 28;

    switch (this) {
      case Difficulty.easy:
        starCount = 1;
        color = xmasGreen;
        break;
      case Difficulty.medium:
        starCount = 2;
        color = companyGold;
        break;
      case Difficulty.hard:
        starCount = 3;
        color = xmasRed;
        break;
      case Difficulty.expert:
        starCount = 4;
        color = Colors.purple;
        size = 32;
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        starCount,
        (i) => Icon(Icons.park, color: color, size: size),
        // )..add(const Icon(Icons.c, color: Colors.green, size: 24)), // Christmas tree-like icon
      ),
    );
  }
}
