import 'package:flappy_bird/ui/theme/AppColors.dart';
import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {
  final double heightRatio;
  final double widthRatio;
  final int skyFlexRatio;
  final int groundFlexRatio;

  const MyBarrier(
      {required this.heightRatio,
      required this.widthRatio,
      required this.skyFlexRatio,
      required this.groundFlexRatio});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width * heightRatio * skyFlexRatio / (skyFlexRatio + groundFlexRatio),
      width: MediaQuery.of(context).size.width * widthRatio,
      decoration: BoxDecoration(
          color: AppColors.green,
          border: Border.all(width: 10, color: AppColors.darkGreen),
          borderRadius: BorderRadius.circular(15)),
    );
  }
}
