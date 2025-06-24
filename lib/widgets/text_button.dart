import 'package:flutter/material.dart';

class CustomTextButton extends StatefulWidget {
  final String text;
  final double size;
  final FontWeight weight;
  final Color fontColor;
  final double maxWidth;
  final double maxHeight;
  final Function() onPressed;

  const CustomTextButton({
    super.key,
    required this.text,
    required this.size,
    required this.weight,
    required this.fontColor,
    required this.maxWidth,
    required this.maxHeight,
    required this.onPressed,
  });

  @override
  CustomTextButtonState createState() => CustomTextButtonState();
}

class CustomTextButtonState extends State<CustomTextButton> {
  double _opacity = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _opacity = 0.5;
        });
      },
      onTapUp: (_) {
        setState(() {
          _opacity = 1.0;
          widget.onPressed();
        });
      },
      onTapCancel: () {
        setState(() {
          _opacity = 1.0;
        });
      },
      child: AnimatedOpacity(
        opacity: _opacity,
        duration: Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: Container(
          color: Colors.transparent,
          width: widget.maxWidth,
          height: widget.maxHeight,
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: widget.size,
                fontWeight: widget.weight,
                color: widget.fontColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
