import 'dart:async';
import "dart:math";
import 'package:glob/glob.dart';
import 'package:flappy_bird/ui/screens/home_page/components/barriers.dart';
import 'package:flappy_bird/ui/screens/home_page/components/bird.dart';
import 'package:flappy_bird/ui/theme/AppColors.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double birdYaxis = 0;
  double time = 0;
  double height = 0;
  late double initialHeight = birdYaxis;
  bool gameHasStarted = false;
  String changingFace = "lib/images/flappy_face.png";
  int score = 0;
  int bestScore = 0;

  void changeFace() {
    // final faces = Glob("**").listSync();
    // debugPrint(faces.toString());
    // final random = Random();
    // var element = faces[random.nextInt(faces.length)].path;
    // debugPrint("this is : " + element.toString());
    // setState(() {});
    final faces = [
      "lib/images/ahmet_2_son.png",
      "lib/images/ahmet_son.png",
      "lib/images/gercek_semih_son.png",
      "lib/images/ismail_son.png",
      "lib/images/ismail_son_2.png",
      "lib/images/semih_2_son.png",
      "lib/images/semih_son.png",
    ];
    final randomSeed = Random();
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
      score += score;
      initialHeight = birdYaxis;
    });
  }

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      time += 0.04;
      height = -4.9 * time * time + 2.8 * time;
      setState(() {
        birdYaxis = initialHeight - height;
      });
      if (birdYaxis < -1) {
        birdYaxis = -1;
      }
      if (birdYaxis > 1) {
        timer.cancel();
        gameHasStarted = false;

        setState(() {
          birdYaxis = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              flex: 4,
              child: Stack(children: [
                GestureDetector(
                    onTap: () {
                      if (gameHasStarted) {
                        debugPrint("pressed");
                        jump();
                      } else {
                        debugPrint("starting press");
                        startGame();
                      }
                    },
                    child: AnimatedContainer(
                      alignment: Alignment(0, birdYaxis),
                      duration: const Duration(milliseconds: 0),
                      color: AppColors.blue,
                      child: MyFlappy(
                        face: changingFace,
                      ),
                    )),
                Container(
                  alignment: const Alignment(0, -0.3),
                  child: gameHasStarted
                      ? null
                      : const Text(
                          "T A P   T O   P L A Y",
                          style:
                              TextStyle(fontSize: 30, color: AppColors.white),
                        ),
                ),
                AnimatedContainer(
                    alignment: const Alignment(0.0, 1),
                    duration: const Duration(milliseconds: 0),
                    child: const MyBarrier(size: 200.0))
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
                          style:
                              TextStyle(color: AppColors.white, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          score.toString(),
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
                          style:
                              TextStyle(color: AppColors.white, fontSize: 20),
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
    );
  }
}
