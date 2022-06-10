import "package:flutter/material.dart";

class MyFlappy extends StatelessWidget {
  const MyFlappy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      child: Image.asset(
        "lib/images/flappy_face.png",
        // height: 48,
        // width: 48,
      ),
    );
  }
}
