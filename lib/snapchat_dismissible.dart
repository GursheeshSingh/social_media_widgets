import 'package:flutter/material.dart';

//TODO: Make additional radius compatible of screen size
//TODO: Add option to only close screen when drag ends
//TODO: If last drag action increased height, then goes back
//TODO: If last drag action decreased height, close screen
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

  double circleOffset = 0.0;
  bool canMoveCircle = false;
  double horizontalDrag = 0.0;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onPanStart: (details) {
        isDragging = true;
        startPosition = details.globalPosition.dy;
      },
      onPanUpdate: (details) {
        if (details.delta.dy != 0) {
          dragHeight = details.globalPosition.dy - startPosition;
          setState(() {});
          if (dragHeight > widget.dismissHeight && isCompleted == false) {
            isCompleted = true;

            double end =
                screenSize.height / 2 + widget.additionalRadius / 2 - 25;
            _animation = Tween(begin: widget.dismissHeight, end: end)
                .animate(_animationController);
            _animationController.forward();

            _animationController.addListener(() {
              if (_animationController.isCompleted) {
                Navigator.pop(context);
              }
            });
          }
        }

        if (details.delta.dx != 0) {
          if (canMoveCircle) {
            circleOffset = circleOffset + details.delta.dx;
            setState(() {});
          } else {
            if (circleOffset != 0) {
              circleOffset = 0.0;
              setState(() {});
            }
          }
        }
      },
      onPanEnd: (details) {
        if (isCompleted == false) {
          circleOffset = 0.0;
          isDragging = false;
          dragHeight = null;
          setState(() {});
        }
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(circleOffset, 0),
            child: ClipOval(
              clipper: _MyCircleClipper(
                screenSize,
                isCompleted ? _animation.value : dragHeight,
                isDragging,
                widget.additionalRadius,
                onChanged: (width, height) {
                  if (screenSize.width > width) {
                    canMoveCircle = true;
                  } else {
                    canMoveCircle = false;
                  }
                },
              ),
              child: child,
            ),
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
  final Function(double width, double height) onChanged;

  _MyCircleClipper(
    this.screenSize,
    this.dragHeight,
    this.isDragging,
    this.additionalRadius, {
    this.onChanged,
  });

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

    if (onChanged != null) {
      onChanged(width, height);
    }

    return rect;
  }

  @override
  bool shouldReclip(_MyCircleClipper oldClipper) {
    return oldClipper.dragHeight != dragHeight;
  }
}
