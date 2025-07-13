import 'package:flutter/material.dart';

class AdaptiveAppBarTitle extends StatelessWidget {
  final String text;
  final int maxLines;
  const AdaptiveAppBarTitle(this.text, {super.key, this.maxLines = 2});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
    );
  }
}
