import 'package:flutter/material.dart';
//渐变效果
class CustomRouteFade extends PageRouteBuilder{
  final Widget widget;
  CustomRouteFade(this.widget)
      :super(
      transitionDuration:const Duration(seconds:1),
      pageBuilder:(
          BuildContext context,
          Animation<double> animation1,
          Animation<double> animation2){
        return widget;
      },
      transitionsBuilder:(
          BuildContext context,
          Animation<double> animation1,
          Animation<double> animation2,
          Widget child){
        return FadeTransition(
          opacity: Tween(begin:0.0,end :2.0).animate(CurvedAnimation(
              parent:animation1,
              curve:Curves.fastOutSlowIn
          )),
          child: child,
        );
      }
  );
}


//缩放效果
class CustomRouteScale extends PageRouteBuilder{
  final Widget widget;
  CustomRouteScale(this.widget)
      :super(
      transitionDuration:const Duration(seconds:1),
      pageBuilder:(
          BuildContext context,
          Animation<double> animation1,
          Animation<double> animation2){
        return widget;
      },
      transitionsBuilder:(
          BuildContext context,
          Animation<double> animation1,
          Animation<double> animation2,
          Widget child){

        return ScaleTransition(
            scale:Tween(begin:0.0,end:1.0).animate(CurvedAnimation(
                parent:animation1,
                curve: Curves.fastOutSlowIn
            )),
            child:child
        );

      }
  );
}



//旋转+缩放效果
class CustomRouteRotateScale extends PageRouteBuilder{
  final Widget widget;
  CustomRouteRotateScale(this.widget)
      :super(
      transitionDuration:const Duration(seconds:1),
      pageBuilder:(
          BuildContext context,
          Animation<double> animation1,
          Animation<double> animation2){
        return widget;
      },
      transitionsBuilder:(
          BuildContext context,
          Animation<double> animation1,
          Animation<double> animation2,
          Widget child){

        return RotationTransition(
            turns:Tween(begin:0.0,end:1.0)
                .animate(CurvedAnimation(
                parent: animation1,
                curve: Curves.fastOutSlowIn
            )),

            child:ScaleTransition(
              scale:Tween(begin: 0.0,end:1.0)
                  .animate(CurvedAnimation(
                  parent: animation1,
                  curve:Curves.fastOutSlowIn
              )),
              child: child,
            )
        );

      }
  );
}




//滑动效果
class CustomRouteSlide extends PageRouteBuilder{
  final Widget widget;
  CustomRouteSlide(this.widget)
      :super(
      transitionDuration:const Duration(seconds:1),
      pageBuilder:(
          BuildContext context,
          Animation<double> animation1,
          Animation<double> animation2){
        return widget;
      },
      transitionsBuilder:(
          BuildContext context,
          Animation<double> animation1,
          Animation<double> animation2,
          Widget child){

        return SlideTransition(
          position: Tween<Offset>(
              begin: Offset(-1.0, 0.0),
              end:Offset(0.0, 0.0)
          )
              .animate(CurvedAnimation(
              parent: animation1,
              curve: Curves.fastOutSlowIn
          )),
          child: child,

        );

      }
  );
}


