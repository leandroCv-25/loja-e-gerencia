//flutter
import 'package:flutter/material.dart';

class BodyBack extends StatelessWidget {
  final colorBegin;
  final colorEnd;

  BodyBack(this.colorBegin,this.colorEnd);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorBegin, colorEnd],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
