import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:kuge_app/pages/my/resetPWDPage.dart';
import 'package:kuge_app/provider/account_provider.dart';
import 'package:kuge_app/route/routes.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
    Future.delayed(const Duration(milliseconds: 500), () {
      _controller.forward();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        automaticallyImplyLeading: true,
        title: const Text("欢迎登陆"),
        actions: [
          MaterialButton(
            child: const Text("注册", style: TextStyle(fontSize: 18.5)),
            onPressed: () => Navigator.pushNamed(context, Routes.registerPage)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(80),
            right: ScreenUtil().setWidth(80),
            top: ScreenUtil().setWidth(100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/logo.png',
                width: ScreenUtil().setWidth(120),
                height: ScreenUtil().setWidth(120),
              ),
              _LoginAnimatedWidget(
                animation: _animation,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginWidget extends StatefulWidget {
  @override
  __LoginWidgetState createState() => __LoginWidgetState();
}

class __LoginWidgetState extends State<_LoginWidget> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

  _login() async {
    FocusScope.of(context).requestFocus(FocusNode());
    String phone = _phoneController.text;
    String pwd = _pwdController.text;
    if (phone.isEmpty || pwd.isEmpty) {
      showToast("请正确输入账号和密码", position: StyledToastPosition.center);
      return;
    }

    var resp = await context.read<UserAccount>().userLogin(phone, pwd);
    if (resp.data["code"] != 0) {
      showToast(resp.data["msg"], position: StyledToastPosition.center);
    } else {
      showToast("登录成功", position: StyledToastPosition.center);
      Navigator.pop(context);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(primaryColor: Colors.red),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setWidth(10)),
            child: const Text('酷歌音乐',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 30,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setWidth(3), bottom: ScreenUtil().setWidth(60)),
            child: const Text('让音乐陪伴生活',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
                hintText: '手机号码',
                prefixIcon: Icon(
                  Icons.phone_iphone,
                  color: Colors.grey,
                )),
          ),
          TextField(
            obscureText: true,
            controller: _pwdController,
            decoration: const InputDecoration(
                hintText: '密码',
                prefixIcon: Icon(Icons.lock,color: Colors.grey,
                )),
          ),
          SizedBox(height: ScreenUtil().setHeight(30)),
          MaterialButton(
            minWidth: double.infinity,
            color: Theme.of(context).primaryColor,
            child: const Text('登 陆'),
            onPressed: () => _login()),
            TextButton(
              child: const Text('忘记密码？点这里重置密码'), 
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ReSetPWDQuestionPage();
                }));
            }),
            // FlatButton(onPressed: () => Navigator.pushNamed(context, pageRegister), child: Text('还没账号？注册新账号'))
        ],
      ),
    );
  }
}

class _LoginAnimatedWidget extends AnimatedWidget {
  final Tween<double> _opacityTween = Tween(begin: 0, end: 1);
  final Tween<double> _offsetTween = Tween(begin: 40, end: 0);
  final Animation<double> animation;

  _LoginAnimatedWidget({
    required this.animation,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _opacityTween.evaluate(animation),
      child: Container(
        margin: EdgeInsets.only(top: _offsetTween.evaluate(animation)),
        child: _LoginWidget(),
      ),
    );
  }
}
