import 'package:flappy_bird/ui/theme/AppColors.dart';
import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {
  final size;

  const MyBarrier({this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.green,
      ),
    );
  }
}
