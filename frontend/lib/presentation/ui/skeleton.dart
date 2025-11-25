import 'package:flutter/material.dart';

class Skeleton extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const Skeleton.rect(
      {super.key,
      this.width = double.infinity,
      this.height = 16,
      this.borderRadius})
      : _isCircle = false;
  const Skeleton.circle(
      {super.key, this.width = 40, this.height = 40, this.borderRadius})
      : _isCircle = true;

  final bool _isCircle;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 900))
    ..repeat(reverse: true);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.6, end: 1.0).animate(_ctrl),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: widget._isCircle
              ? BorderRadius.circular(999)
              : (widget.borderRadius ?? BorderRadius.circular(6)),
        ),
      ),
    );
  }
}
