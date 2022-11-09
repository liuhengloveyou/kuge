import 'package:flutter/material.dart';
import 'package:kuge_app/material/chart_button.dart';
import './tab.dart';

class FriendPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {},
          child: Icon(
            const IconData(0xe60d, fontFamily: 'IconFont'),
            size: 32,
          ),
        ),
        title: TabPage(),
        elevation: 1,
        centerTitle: true,
        actions: <Widget>[ChartButton()],
      ),
      body: Container(
        child: Center(
          child: Text('还在努力研发中!'),
        ),
      ),
    );
  }
}
