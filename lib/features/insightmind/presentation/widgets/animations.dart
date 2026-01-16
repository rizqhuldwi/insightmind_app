import 'package:flutter/material.dart';

class StaggeredFadeIn extends StatelessWidget {
  final Widget child;
  final Duration delay;
  final Offset offset;

  const StaggeredFadeIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.offset = const Offset(0, 30),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutQuart,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(offset.dx * (1 - value), offset.dy * (1 - value)),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(top: delay.inMilliseconds / 20), // Artificial delay spacing if needed
        child: child,
      ),
    );
  }
}

// A more proper way to handle delay in TweenAnimationBuilder is to use a Timer or a custom Delay widget
// but for simplicity and "WOW" effect without complex state, we can use an AnimatedWidget with delay.

class AnimationDelay extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const AnimationDelay({super.key, required this.child, required this.delay});

  @override
  State<AnimationDelay> createState() => _AnimationDelayState();
}

class _AnimationDelayState extends State<AnimationDelay> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: _visible ? Offset.zero : const Offset(0, 0.1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutQuart,
      child: AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 600),
        child: widget.child,
      ),
    );
  }
}
