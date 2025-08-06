import 'package:flutter/material.dart';

class GradientExpansionTile extends StatefulWidget {
  final Widget title;
  final List<Widget> children;
  final bool initiallyExpanded;

  const GradientExpansionTile({
    super.key,
    required this.title,
    required this.children,
    this.initiallyExpanded = false,
  });

  @override
  State<GradientExpansionTile> createState() => _GradientExpansionTileState();
}

class _GradientExpansionTileState extends State<GradientExpansionTile> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final decoration = _expanded
        ? BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade200, Colors.green.shade400],
            ),
          )
        : null;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: decoration,
        child: ExpansionTile(
          initiallyExpanded: widget.initiallyExpanded,
          onExpansionChanged: (value) {
            setState(() {
              _expanded = value;
            });
          },
          title: DefaultTextStyle.merge(
            style: const TextStyle(fontWeight: FontWeight.bold),
            child: widget.title,
          ),
          childrenPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          children: _expanded
              ? widget.children
                  .map((child) => DefaultTextStyle.merge(
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        child: child,
                      ))
                  .toList()
              : widget.children,
        ),
      ),
    );
  }
}
