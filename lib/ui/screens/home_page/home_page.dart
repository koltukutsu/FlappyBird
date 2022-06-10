import 'dart:async';

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

  void jump() {
    setState(() {
      time = 0;
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
        gameHasStarted = true;
        // setState(() {
        // });
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
                      child: const MyFlappy(),
                    )),
                Container(
                  alignment: Alignment(0, -0.3),
                  child: gameHasStarted
                      ? null
                      : const Text(
                          "T A P   T O   P L A Y",
                          style:
                              TextStyle(fontSize: 30, color: AppColors.white),
                        ),
                ),
                AnimatedContainer(
                  alignment: Alignment(0.0, 1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(size: 200.0))
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
                      children: const [
                        Text(
                          "Score",
                          style:
                              TextStyle(color: AppColors.white, fontSize: 20),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "0",
                          style:
                              TextStyle(color: AppColors.white, fontSize: 35),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Best",
                          style:
                              TextStyle(color: AppColors.white, fontSize: 20),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "0",
                          style:
                              TextStyle(color: AppColors.white, fontSize: 35),
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
