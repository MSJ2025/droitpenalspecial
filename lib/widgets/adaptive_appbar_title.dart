import 'package:flutter/material.dart';

class AdaptiveAppBarTitle extends StatelessWidget {
  final String text;
  final int maxLines;
  const AdaptiveAppBarTitle(this.text, {super.key, this.maxLines = 2});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(text, maxLines: maxLines, textAlign: TextAlign.center),
    );
  }
}
