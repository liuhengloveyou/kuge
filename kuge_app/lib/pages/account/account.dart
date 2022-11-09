import 'package:flutter/material.dart';
import 'package:kuge_app/material/chart_button.dart';
import 'package:kuge_app/pages/my/is_login_top.dart';
import './row_navigation.dart';
import './column_block.dart';
import './balck_vip.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {},
          child: Icon(
            const IconData(0xe610, fontFamily: 'IconFont'),
            size: 23,
          ),
        ),
        elevation: 1,
        centerTitle: true,
        actions: <Widget>[ChartButton()],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            IsLoginPage(),
            BlackVip(),
            RowNavigationPage(),
            ColumnBlock()
          ],
        ),
      ),
    );
  }
}
