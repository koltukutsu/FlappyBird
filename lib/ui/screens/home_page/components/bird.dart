import "package:flutter/material.dart";

class MyFlappy extends StatelessWidget {
  const MyFlappy({Key? key, required this.face}) : super(key: key);
  final String face;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(
        face,
        height: 60,
        width: 60,
        // "lib/assets/flappy_face.png",
        // height: 48,
        // width: 48,
      ),
    );
  }
}
