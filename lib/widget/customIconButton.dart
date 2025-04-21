import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomIconButton extends StatefulWidget {
  final String iconPath;
  final double iconWidth;
  final double iconHeight;
  final double maxWidth;
  final double maxHeight;
  final Function() onPressed;

  const CustomIconButton({
    super.key,
    required this.iconPath,
    required this.iconWidth,
    required this.iconHeight,
    required this.maxWidth,
    required this.maxHeight,
    required this.onPressed,
  });

  @override
  CustomIconButtonState createState() => CustomIconButtonState();
}

class CustomIconButtonState extends State<CustomIconButton> {
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
            child: SvgPicture.asset(
              widget.iconPath,
              width: widget.iconWidth,
              height: widget.iconHeight,
            ),
          ),
        ),
      ),
    );
  }
}
