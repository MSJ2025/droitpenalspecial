import 'package:flutter/material.dart';

/// Bouton moderne avec dégradé subtil et légère animation de survol.
class ModernGradientButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  const ModernGradientButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  State<ModernGradientButton> createState() => _ModernGradientButtonState();
}

class _ModernGradientButtonState extends State<ModernGradientButton> {
  bool _hovering = false;
  bool _pressed = false;

  void _setHover(bool value) {
    setState(() {
      _hovering = value;
    });
  }

  void _setPressed(bool value) {
    setState(() {
      _pressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    double opacity = 1.0;
    if (_pressed) {
      opacity = 0.82;
    } else if (_hovering) {
      opacity = 0.90;
    }
    return MouseRegion(
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      child: GestureDetector(
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 120),
          opacity: opacity,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFAF9F6), Colors.white, Color(0xFFFAF9F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              icon: Icon(widget.icon),
              label: Text(widget.label),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                textStyle: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w600),
                elevation: 0,
              ),
              onPressed: widget.onPressed,
            ),
          ),
        ),
      ),
    );
  }
}
