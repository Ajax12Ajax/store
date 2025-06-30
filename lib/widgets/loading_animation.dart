import 'package:flutter/material.dart';

class LoadingAnimation extends StatefulWidget {
  const LoadingAnimation({super.key});

  @override
  LoadingAnimationState createState() => LoadingAnimationState();
}

class LoadingAnimationState extends State<LoadingAnimation> with TickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    duration: const Duration(milliseconds: 1400),
    vsync: this,
  )..repeat();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (Rect bounds) {
            double wavePosition = _animationController.value;
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black,
                Colors.black,
                Colors.transparent,
                Colors.transparent,
                Colors.black45,
                Colors.black,
                Colors.black,
              ],
              stops: [
                (wavePosition - 0.3).clamp(0.0, 1.0),
                (wavePosition - 0.2).clamp(0.0, 1.0),
                (wavePosition - 0.1).clamp(0.0, 1.0),
                wavePosition.clamp(0.0, 1.0),
                (wavePosition + 0.1).clamp(0.0, 1.0),
                (wavePosition + 0.2).clamp(0.0, 1.0),
                (wavePosition + 0.3).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          child: const Text(
            "Store",
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 48,
              fontWeight: FontWeight.w800,
              color: Color(0xFF000000),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
