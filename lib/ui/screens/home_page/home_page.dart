import 'dart:async';

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

  void jump() {
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        birdYaxis -= 0.1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              flex: 2,
              child: Container(
                color: AppColors.blue,
                child: GestureDetector(
                  onTap: jump,
                  child: AnimatedContainer(
                    alignment: Alignment(0, birdYaxis),
                    duration: const Duration(milliseconds: 0),
                    child: const MyFlappy(),
                  ),
                ),
              )),
          Expanded(
              child: Container(
            color: AppColors.green,
          )),
        ],
      ),
    );
  }
}
