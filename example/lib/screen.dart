import 'package:flutter/material.dart';

class Screen extends StatelessWidget {
  final String name;
  final Color color;

  const Screen(this.name, this.color);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appbar: AppBar(
        backgroundColor: color,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
        leading: Container(),
      ),
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
