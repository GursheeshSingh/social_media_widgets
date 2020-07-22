import 'package:flutter/material.dart';
import 'package:social_media_widgets/instagram_story_swipe.dart';
import 'package:social_media_widgets/snapchat_dismissible.dart';

import 'screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF8134AF), Color(0xFFDD2A7B), Color(0xFFFEDA77)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.3, 0.6, 0.9],
            ),
          ),
          child: CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
              'https://pbs.twimg.com/profile_images/1209034437708533760/_xoOpF_F_400x400.jpg',
            ),
          ),
        ),
      ),
//      body: Container(
//        margin: EdgeInsets.symmetric(horizontal: 30),
//        child: Center(
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              RaisedButton(
//                onPressed: _onSnapchatDismissibleWithBlackButtonPressed,
//                child: Text('Basic Snapchat dismissible'),
//              ),
//              SizedBox(height: 16),
//              RaisedButton(
//                onPressed: _onSnapchatDismissibleWithPreviousScreenPressed,
//                child: Text(
//                  'Snapchat dismissible with previous screen as background',
//                  textAlign: TextAlign.center,
//                ),
//              ),
//              SizedBox(height: 16),
//              RaisedButton(
//                onPressed: _onSnapchatDismissibleWithCustomHeightPressed,
//                child: Text(
//                  'Snapchat dismissible with increased custom height',
//                  textAlign: TextAlign.center,
//                ),
//              ),
//              SizedBox(height: 16),
//              RaisedButton(
//                onPressed: _onInstagramStorySwipeClicked,
//                child: Text(
//                  'Instagram story swipe',
//                  textAlign: TextAlign.center,
//                ),
//              ),
//              SizedBox(height: 16),
//              RaisedButton(
//                onPressed:
//                    _onInstagramStorySwipeWithInitialPageSpecifiedClicked,
//                child: Text(
//                  'Instagram story swipe with initial page as screen 2',
//                  textAlign: TextAlign.center,
//                ),
//              ),
//              SizedBox(height: 16),
//              RaisedButton(
//                onPressed: _onInstagramAndStorySwipeCombined,
//                child: Text(
//                  'Instagram story swipe and snapchat dismiss combined',
//                  textAlign: TextAlign.center,
//                ),
//              ),
//            ],
//          ),
//        ),
//      ),
    );
  }

  _onSnapchatDismissibleWithBlackButtonPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SnapchatDismiss(
          closeAfterDragEnds: true,
          child: Screen('Screen', Colors.redAccent),
        ),
      ),
    );
  }

  _onSnapchatDismissibleWithPreviousScreenPressed() {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => SnapchatDismiss(
          child: Screen('Screen', Colors.redAccent),
        ),
      ),
    );
  }

  _onSnapchatDismissibleWithCustomHeightPressed() {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => SnapchatDismiss(
          dismissHeight: 400,
          child: Screen('Screen', Colors.redAccent),
        ),
      ),
    );
  }

  _onInstagramStorySwipeClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InstagramStorySwipe(
          children: <Widget>[
            Screen('Screen 1', Colors.lightBlueAccent),
            Screen('Screen 2', Colors.redAccent),
            Screen('Screen 3', Colors.greenAccent),
          ],
        ),
      ),
    );
  }

  _onInstagramStorySwipeWithInitialPageSpecifiedClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InstagramStorySwipe(
          initialPage: 1,
          children: <Widget>[
            Screen('Screen 1', Colors.lightBlueAccent),
            Screen('Screen 2', Colors.redAccent),
            Screen('Screen 3', Colors.greenAccent),
          ],
        ),
      ),
    );
  }

  _onInstagramAndStorySwipeCombined() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => SnapchatDismiss(
          child: InstagramStorySwipe(
            initialPage: 1,
            children: <Widget>[
              Screen('Screen 1', Colors.lightBlueAccent),
              Screen('Screen 2', Colors.redAccent),
              Screen('Screen 3', Colors.greenAccent),
            ],
          ),
        ),
      ),
    );
  }
}
