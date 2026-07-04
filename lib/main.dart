import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MathRushGame());
}

class MathRushGame extends StatelessWidget {
  const MathRushGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math Rush Global',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.amber,
        scaffoldBackgroundColor: const Color(0xff121212),
      ),
      home: const GameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int num1 = 0;
  int num2 = 0;
  String operator = '+';
  int correctAnswer = 0;
  List<int> options = [];
  int score = 0;
  int timeLeft = 10;
  Timer? timer;
  bool isPlaying = false;

  void generateQuestion() {
    final random = Random();
    int opType = random.nextInt(3); 

    if (opType == 0) {
      operator = '+';
      num1 = random.nextInt(50) + 1;
      num2 = random.nextInt(50) + 1;
      correctAnswer = num1 + num2;
    } else if (opType == 1) {
      operator = '-';
      num1 = random.nextInt(50) + 20;
      num2 = random.nextInt(num1 - 1) + 1;
      correctAnswer = num1 - num2;
    } else {
      operator = '×';
      num1 = random.nextInt(12) + 1;
      num2 = random.nextInt(12) + 1;
      correctAnswer = num1 * num2;
    }

    options = [correctAnswer];
    while (options.length < 4) {
      int wrongAns = correctAnswer + random.nextInt(20) - random.nextInt(20);
      if (!options.contains(wrongAns) && wrongAns >= 0) {
        options.add(wrongAns);
      }
    }
    options.shuffle();
  }

  void startTimer() {
    timer?.cancel();
    timeLeft = 10;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          gameOver();
        }
      });
    });
  }

  void startGame() {
    setState(() {
      score = 0;
      isPlaying = true;
      generateQuestion();
      startTimer();
    });
  }

  void checkAnswer(int selectedAnswer) {
    if (selectedAnswer == correctAnswer) {
      setState(() {
        score += 10;
        generateQuestion();
        startTimer();
      });
    } else {
      gameOver();
    }
  }

  void gameOver() {
    timer?.cancel();
    setState(() {
      isPlaying = false;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Over 💥', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('तुमचा स्कोर: $score', textAlign: TextAlign.center, style: const TextStyle(fontSize: 20)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              startGame();
            },
            child: const Text('पुन्हा खेळा 🔄', style: TextStyle(color: Colors.amber, fontSize: 16)),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: isPlaying
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('स्कोर: $score', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
                        Text('वेळ: ${timeLeft}s', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: timeLeft <= 3 ? Colors.red : Colors.amber)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xff1e1e1e),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Text(
                        '$num1 $operator $num2 = ?',
                        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, letterSpacing: 2),
                      ),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff252525),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            side: const BorderSide(color: Colors.white24),
                          ),
                          onPressed: () => checkAnswer(options[index]),
                          child: Text(options[index].toString(), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                        );
                      },
                    ),
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🧮 MATH RUSH GLOBAL ⚡', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.amber, letterSpacing: 1)),
                      const SizedBox(height: 10),
                      const Text('तुमच्या डोक्याला द्या गती!', style: TextStyle(fontSize: 16, color: Colors.grey)),
                      const SizedBox(height: 50),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        onPressed: startGame,
                        child: const Text('गेम सुरू करा 🎮', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
