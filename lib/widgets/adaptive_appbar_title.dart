import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class AdaptiveAppBarTitle extends StatelessWidget {
  final String text;
  final int maxLines;
  const AdaptiveAppBarTitle(this.text, {super.key, this.maxLines = 2});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final style = Theme.of(context).appBarTheme.titleTextStyle ??
            Theme.of(context).textTheme.titleLarge;
        final textPainter = TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout();

        final bool needsScroll = maxLines == 1 &&
            textPainter.width > constraints.maxWidth;

        if (needsScroll) {
          return SizedBox(
            height: kToolbarHeight,
            child: Marquee(
              text: text,
              blankSpace: 32.0,
              velocity: 40.0,
              startAfter: const Duration(seconds: 1),
              style: style,
            ),
          );
        }

        return Text(
          text,
          maxLines: maxLines,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: style,
        );
      },
    );
  }
}
