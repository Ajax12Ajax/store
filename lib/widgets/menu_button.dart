import 'package:flutter/material.dart';

class MenuButton extends StatefulWidget {
  final String text;
  final double size;
  final FontWeight weight;
  final VoidCallback onPressed;

  const MenuButton({
    super.key,
    required this.text,
    required this.size,
    required this.weight,
    required this.onPressed,
  });

  @override
  MenuButtonState createState() => MenuButtonState();
}

class MenuButtonState extends State<MenuButton> {
  double _opacity = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _opacity = 0.5),
      onTapUp: (_) {
        setState(() {
          _opacity = 1.0;
          widget.onPressed();
        });
      },
      onTapCancel: () => setState(() => _opacity = 1.0),
      child: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: Container(
          color: Colors.transparent,
          alignment: Alignment.centerLeft,
          height: 39,
          child: Text(
            widget.text,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: widget.size,
              fontWeight: widget.weight,
              color: const Color(0xFF000000),
            ),
          ),
        ),
      ),
    );
  }
}
