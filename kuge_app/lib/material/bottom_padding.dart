import 'package:flutter/material.dart';

Widget bottomPadding(BuildContext context) {
  return Container(
    child: Text("已经到底了~", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 11)),
    padding: EdgeInsets.only(bottom: 100, top: 16),
  );
}
