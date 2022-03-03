import 'package:flutter/material.dart';

class WaveBar extends StatelessWidget {
  final double? barHeight;
  final Color? barColor;

  const WaveBar({
    Key? key,
    this.barHeight,
    this.barColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 4,
      child: Center(
        child: Container(
          height: barHeight,
          color: barColor,
        ),
      ),
    );
  }
}
