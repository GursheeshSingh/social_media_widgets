import 'package:flutter/material.dart';

//TODO: Make additional radius compatible of screen size
//TODO: Add API docs
//TODO: After circles turns to less than width of the screen- Can also move down
//TODO: If behind screen is visible, lower its opacity and increase opacity as circle radius decreases --ADDED
class SnapchatDismiss extends StatefulWidget {
  final Widget? child;
  final double dismissHeight;
  final double additionalRadius;
  final bool closeAfterDragEnds;

  SnapchatDismiss({
    this.child,
    this.dismissHeight = 150.0,
    this.additionalRadius = 125.0,
    this.closeAfterDragEnds = true,
  });

  @override
  _SnapchatDismissState createState() => _SnapchatDismissState();
}

class _SnapchatDismissState extends State<SnapchatDismiss>
    with TickerProviderStateMixin {
  double? startPosition, dragHeight;
  bool isDragging = false,
      isCompleted = false,
      greaterThanDismissHeight = false;
  late AnimationController _animationController;
  late Animation _animation;

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
  bool wasLastDragGrowth = false;

  void _reset() {
    circleOffset = 0.0;
    isDragging = false;
    isCompleted = false;
    greaterThanDismissHeight = false;
    wasLastDragGrowth = false;
    dragHeight = null;
    setState(() {});
  }

  void _complete(Size screenSize) {
    isCompleted = true;
    double end = screenSize.height / 2 + widget.additionalRadius / 2 - 25;
    _animation =
        Tween(begin: dragHeight, end: end).animate(_animationController);
    _animationController.forward();

    _animationController.addListener(() {
      if (_animationController.isCompleted) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onPanStart: (details) {
        isDragging = true;
        startPosition = details.globalPosition.dy;
      },
      onPanUpdate: (details) {
        if (details.delta.dy > 0) {
          wasLastDragGrowth = false;
        } else if (details.delta.dy < 0) {
          wasLastDragGrowth = true;
        }

        if (details.delta.dy != 0) {
          dragHeight = details.globalPosition.dy - startPosition!;
          setState(() {});
          greaterThanDismissHeight = dragHeight! > widget.dismissHeight;
          if (greaterThanDismissHeight &&
              widget.closeAfterDragEnds == false &&
              isCompleted == false) {
            _complete(screenSize);
            return;
          }
        }

        if (details.delta.dx != 0) {
          if (canMoveCircle) {
            circleOffset = circleOffset + details.delta.dx;
          } else {
            if (circleOffset != 0) {
              circleOffset = 0.0;
            }
          }
          setState(() {});
        }
      },
      onPanEnd: (details) {
        if (isCompleted) {
          return;
        }
        if (greaterThanDismissHeight) {
          if (wasLastDragGrowth) {
            _reset();
            return;
          }

          _complete(screenSize);
          return;
        }

        _reset();
      },
      child: Stack(
        children: <Widget>[
          Container(
            color: Colors.black.withOpacity(
                (1.0 - (0.8 / (screenSize.height)) * (dragHeight ?? 1.0) * 1.5)
                    .clamp(0.0, 1.0)),
          ),
          AnimatedBuilder(
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
        ],
      ),
    );
  }
}

class _MyCircleClipper extends CustomClipper<Rect> {
  final Size screenSize;
  final double? dragHeight;
  final bool isDragging;
  final double additionalRadius;
  final Function(double width, double height)? onChanged;

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
    if (isDragging && dragHeight != null) {
      width = screenSize.height + additionalRadius - dragHeight! * 2;
      height = screenSize.height + additionalRadius - dragHeight! * 2;
    } else {
      width = screenSize.height + additionalRadius;
      height = screenSize.height + additionalRadius;
    }

    Rect rect = Rect.fromCenter(
      center: Offset(screenSize.width / 2, screenSize.height / 2),
      width: width,
      height: height,
    );

    onChanged?.call(width, height);

    return rect;
  }

  @override
  bool shouldReclip(_MyCircleClipper oldClipper) {
    return oldClipper.dragHeight != dragHeight;
  }
}
