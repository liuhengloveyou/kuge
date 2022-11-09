import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kuge_app/utils/general_util.dart';

class CommitButtonWidget extends StatefulWidget {
  ///按钮显示的子widget
  final Widget child;

  ///必传参数，按钮展示时的颜色
  final Color color;

  ///按钮按压下的颜色
  final Color disabledColor;

  final EdgeInsetsGeometry padding;

  final onPressed;

  final String text;

  const CommitButtonWidget({
    Key? key,
    required this.color,
    required this.disabledColor,
    required this.padding,
    required this.onPressed,
    required this.child,
    required this.text,
  }) : super(key: key);

  @override
  _CommitButtonWidgetState createState() => _CommitButtonWidgetState();
}

class _CommitButtonWidgetState extends State<CommitButtonWidget> {
  @override
  Widget build(BuildContext context) {
    GeneralUtil.screenAdaptation(context);
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: MaterialButton(
        color: widget.color,
        disabledColor: widget.disabledColor,
        padding: widget.padding ?? EdgeInsets.symmetric(vertical: 10.h),
        onPressed: widget.onPressed,
        child: widget.child ?? Text(widget.text,
                style: TextStyle(fontSize: 15.sp, color: Colors.white)),
      ),
    );
  }
}
