import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:kuge_app/route/routes.dart';

class ChartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
            onTap: () => Navigator.pushNamed(context, Routes.feedbackPage),
            child: Container(
              width: 54,
              child: Icon(
                FontAwesome.commenting_o,
                size: 25,
                color: Theme.of(context).appBarTheme.color,
              ),
            ),
          )
    );
  }
}
