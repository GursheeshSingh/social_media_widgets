import 'package:flutter/material.dart';
import 'package:social_media_widgets/insta_swipe_controller.dart';

class Screen extends StatelessWidget {
  final String name;
  final Color color;

  const Screen(this.name, this.color);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: color,
        child: Center(
          child: Text(
            name,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class ScreenWithDirectionButtons extends StatelessWidget {
  final String name;
  final Color color;
  final InstagramSwipeController controller;

  const ScreenWithDirectionButtons(this.name, this.color, this.controller);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: color,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  name,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      child: Text('Previous'),
                      onPressed: (){
                        controller.previousPage();
                      }
                  ),
                  ElevatedButton(
                      child: Text('Next'),
                      onPressed: (){
                        controller.nextPage();
                      }
                  )
                ],
              )
            ],
          )
        ),
      ),
    );
  }
}