import 'package:flutter/material.dart';

class SnapchatDismiss extends StatefulWidget {
  final Widget child;
  final double dismissHeight;
  final double additionalRadius;

  SnapchatDismiss({
    this.child,
    this.dismissHeight = 150.0,
    this.additionalRadius = 125.0,
  });

  @override
  _SnapchatDismissState createState() => _SnapchatDismissState();
}

class _SnapchatDismissState extends State<SnapchatDismiss>
    with TickerProviderStateMixin {
  double startPosition, dragHeight;
  bool isDragging = false, isCompleted = false;
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 350));
    _animation = Tween().animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onVerticalDragStart: (details) {
        isDragging = true;
        startPosition = details.globalPosition.dy;
        setState(() {});
      },
      onVerticalDragUpdate: (details) {
        dragHeight = details.globalPosition.dy - startPosition;
        setState(() {});
        if (dragHeight > widget.dismissHeight && isCompleted == false) {
          isCompleted = true;

          double end = screenSize.height / 2 + widget.additionalRadius / 2 - 25;
          _animation = Tween(begin: widget.dismissHeight, end: end)
              .animate(_animationController);
          _animationController.forward();

          _animationController.addListener(() {
            if (_animationController.isCompleted) {
              Navigator.pop(context);
            }
          });
        }
      },
      onVerticalDragEnd: (details) {
        if (isCompleted == false) {
          isDragging = false;
          dragHeight = null;
          setState(() {});
        }
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return ClipOval(
            clipper: _MyCircleClipper(
              screenSize,
              isCompleted ? _animation.value : dragHeight,
              isDragging,
              widget.additionalRadius,
            ),
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

class _MyCircleClipper extends CustomClipper<Rect> {
  final Size screenSize;
  final double dragHeight;
  final bool isDragging;
  final double additionalRadius;

  _MyCircleClipper(
    this.screenSize,
    this.dragHeight,
    this.isDragging,
    this.additionalRadius,
  );

  @override
  Rect getClip(Size size) {
    double width, height;
    if (isDragging != null && isDragging && dragHeight != null) {
      width = screenSize.height + additionalRadius - dragHeight * 2;
      height = screenSize.height + additionalRadius - dragHeight * 2;
    } else {
      width = screenSize.height + additionalRadius;
      height = screenSize.height + additionalRadius;
    }

    Rect rect = Rect.fromCenter(
      center: Offset(screenSize.width / 2, screenSize.height / 2),
      width: width,
      height: height,
    );
    return rect;
  }

  @override
  bool shouldReclip(_MyCircleClipper oldClipper) {
    return oldClipper.dragHeight != dragHeight;
  }
}
