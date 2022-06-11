import 'dart:async';
import "dart:math";
import 'package:audioplayers/audioplayers.dart';
import 'package:flappy_bird/ui/screens/home_page/components/barriers.dart';
import 'package:flappy_bird/ui/screens/home_page/components/bird.dart';
import 'package:flappy_bird/ui/theme/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AudioPlayer audioPlayer = AudioPlayer();
  String changingFace = "lib/assets/images/flappy_face.png";
  int score = 0;
  int bestScore = 0;
  late String bestScoreImagePath;
  late String bestScoreSoundPath;
  double birdYaxis = 0;
  double time = 0;
  double height = 0;
  double barrierX1 = 1;
  late double initialHeight = birdYaxis;
  late double barrierX2 = barrierX1 + 1.7;
  bool gameHasStarted = false;
  bool gameEnded = false;

  @override
  initState() {
    getBestScoreAttributes();
  }

  void changeGameText() {
    setState(() {
      gameEnded = false;
    });
  }

  void resetGame() {
    setState(() {
      birdYaxis = 0;
      time = 0;
      height = 0;
      initialHeight = birdYaxis;
      gameHasStarted = false;
      // changingFace = "lib/assets/flappy_face.png";
      score = 0;
      // int bestScore = 0;
      barrierX1 = 1;
      double barrierX2 = barrierX1 + 1.7;
    });
  }

  Future<void> saveBestScoreAttributes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt("bestScoreInt", bestScore);
    await prefs.setString("bestScoreImagePath", "");
    await prefs.setString("bestScoreSoundPath", "");
  }

  Future<void> getBestScoreAttributes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final int? bestScoreIntTaken = prefs.getInt("bestSoreInt");
    final String? bestScoreImagePathTaken = prefs.getString("bestSoreInt");
    final String? bestScoreSoundPathTaken = prefs.getString("bestSoreInt");

    setState(() {
      bestScore = bestScoreIntTaken == null ? 0 : bestScoreIntTaken;
      bestScoreImagePath = bestScoreImagePathTaken == null
          ? "fillImage"
          : bestScoreImagePathTaken;
      bestScoreSoundPath = bestScoreSoundPathTaken == null
          ? "fillSound"
          : bestScoreSoundPathTaken;
    });
  }

  void playLocal() async {
    int result = await audioPlayer.play("", isLocal: true);
  }

  void changeFace() {
    final faces = [
      "lib/assets/images/ahmet_2_son.png",
      "lib/assets/images/ahmet_son.png",
      "lib/assets/images/gercek_semih_son.png",
      "lib/assets/images/ismail_son.png",
      "lib/assets/images/ismail_son_2.png",
      "lib/assets/images/semih_2_son.png",
      "lib/assets/images/semih_son.png",
    ];
    final randomSeed = Random();
    faces.remove(changingFace);
    var faceElement = faces[randomSeed.nextInt(faces.length)];
    debugPrint(faceElement);

    setState(() {
      changingFace = faceElement;
    });
  }

  void jump() {
    changeFace();
    setState(() {
      time = 0;
      score += 1;
      initialHeight = birdYaxis;
    });
  }

  bool faceDead() {
    setState(() {
      gameEnded = true;
    });
    if (birdYaxis < -1.1 || birdYaxis > 1.1) {
      print("1");
      return true;
    }

    if (barrierX1 <= 30 &&
        barrierX1 + 100 >= -30 &&
        (birdYaxis <= -1 + 200 || birdYaxis + 30 >= 1 - 200)) {
      print("2");
      return true;
    }
    if (barrierX2 <= 30 &&
        barrierX2 + 100 >= -30 &&
        (birdYaxis <= -1 + 250 || birdYaxis + 30 >= 1 - 250)) {
      print("3");
      return true;
    }
    return false;
  }

  void startGame() {
    setState(() {
      gameHasStarted = true;
    });
    Timer.periodic(const Duration(milliseconds: 40), (timer) {
      time += 0.04;
      height = -4.9 * time * time + 2.8 * time;
      setState(() {
        birdYaxis = initialHeight - height;
      });
      setState(() {
        if (barrierX1 < -1.7) {
          barrierX1 += 3.5;
        } else {
          barrierX1 -= 0.05;
        }
      });
      setState(() {
        if (barrierX2 < -1.7) {
          barrierX2 += 4.5;
        } else {
          barrierX2 -= 0.05;
        }
      });

      if (birdYaxis < -1.1 || birdYaxis > 1.1) {
        timer.cancel();
        faceDead();
        // resetGame();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          debugPrint("game started: " + gameHasStarted.toString());
          if (gameEnded) {
            changeGameText();
            resetGame();
          } else if (gameHasStarted) {
            gameHasStarted = gameHasStarted ? true : false;
            debugPrint("game continues");
            jump();
          } else {
            debugPrint("game is started");
            startGame();
          }
        },
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                  flex: 4,
                  child: Stack(children: [
                    AnimatedContainer(
                      alignment: Alignment(0, birdYaxis),
                      duration: const Duration(milliseconds: 0),
                      color: AppColors.blue,
                      child: MyFlappy(
                        face: changingFace,
                      ),
                    ),
                    AnimatedContainer(
                        alignment: Alignment(barrierX1, 1.1),
                        duration: const Duration(milliseconds: 0),
                        child: const MyBarrier(size: 200.0)),
                    AnimatedContainer(
                        alignment: Alignment(barrierX1, -1.1),
                        duration: const Duration(milliseconds: 0),
                        child: const MyBarrier(size: 200.0)),
                    AnimatedContainer(
                        alignment: Alignment(barrierX2, 1.1),
                        duration: const Duration(milliseconds: 0),
                        child: const MyBarrier(size: 250.0)),
                    AnimatedContainer(
                        alignment: Alignment(barrierX2, -1.1),
                        duration: const Duration(milliseconds: 0),
                        child: const MyBarrier(size: 250.0)),
                    Container(
                      alignment: const Alignment(0, -0.3),
                      child: !gameHasStarted && !gameEnded
                          ? const Text(
                              "B A Ş L A",
                              style: TextStyle(
                                  fontSize: 30, color: AppColors.white),
                            )
                          : null,
                    ),
                    Container(
                      alignment: const Alignment(0, -0.3),
                      child: gameEnded
                          ? const Text(
                              "O L U R   Ö Y L E",
                              style: TextStyle(
                                  fontSize: 30, color: AppColors.white),
                            )
                          : null,
                    ),
                    Container(
                      alignment: const Alignment(0, -0.1),
                      child: gameEnded
                          ? const Text(
                              "-- O L U R   M U   Ö Y L E !",
                              style: TextStyle(
                                  fontSize: 26, color: AppColors.white),
                            )
                          : null,
                    ),
                  ])),
              Container(
                height: 15,
                color: AppColors.green,
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    color: AppColors.brown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Score",
                              style: TextStyle(
                                  color: AppColors.white, fontSize: 20),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              "$score",
                              style: const TextStyle(
                                  color: AppColors.white, fontSize: 35),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Best",
                              style: TextStyle(
                                  color: AppColors.white, fontSize: 20),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              bestScore.toString(),
                              style: const TextStyle(
                                  color: AppColors.white, fontSize: 35),
                            )
                          ],
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ));
  }
}
