import 'package:flutter/material.dart';

/// [ShimmerEffect] Shimmer widget optimized with performance improvements
/// and intelligent animation handling.
///
class ShimmerEffect extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration duration;

  const ShimmerEffect({
    super.key,
    required this.child,
    required this.baseColor,
    required this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    /// [ANIMATION OPTIMIZATION]
    /// Use a more efficient interpolator and optimized range
    _animation = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _controller.repeat();
  }

  @override
  void didUpdateWidget(ShimmerEffect oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// [RESOURCE OPTIMIZATION]
    /// Only update duration if it actually changed, avoiding unnecessary recreations
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
      // Restart animation with new duration
      _controller.reset();
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// [REPAINT OPTIMIZATION]
    /// RepaintBoundary isolates the shimmer animation from the rest of the widget tree,
    /// preventing unnecessary repaints in parent widgets when the animation changes
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (bounds) {
              /// [GRADIENT OPTIMIZATION]
              /// Optimized gradient configuration for better visual performance
              return LinearGradient(
                begin: Alignment(
                  _animation.value - 1.0,
                  0.0,
                ),
                end: Alignment(
                  _animation.value,
                  0.0,
                ),
                colors: [
                  widget.baseColor,
                  widget.highlightColor,
                  widget.baseColor,
                ],
                stops: const [
                  0.1,
                  0.5,
                  0.9
                ], // [SMOOTH TRANSITION] Optimized stops
              ).createShader(bounds);
            },
            child: widget.child,
          );
        },
        child: widget.child, // [OPTIMIZATION] Cached child for AnimatedBuilder
      ),
    );
  }
}
