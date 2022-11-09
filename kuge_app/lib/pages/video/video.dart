import 'package:flutter/material.dart';
import 'package:kuge_app/material/chart_button.dart';
import '../find/searcharea.dart';

class VideoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {},
          child: Icon(const IconData(0xe647, fontFamily: 'IconFont'), size: 25),
        ),
        title: SearchArea(),
        elevation: 1,
        titleSpacing: 0,
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
