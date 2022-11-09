import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kuge_app/http/api.dart';
import 'package:kuge_app/route/routes.dart';

class SwiperPage extends StatefulWidget {
  @override
  _SwiperPageState createState() => _SwiperPageState();
}

class _SwiperPageState extends State<SwiperPage> {
  List<Map> SwiperList = [];
  var formData = {'type': 'iphone'};

  @override
  void initState() {
    super.initState();

    _getBanner();
  }

  @override
  Widget build(BuildContext context) {
    return SwiperList.isEmpty
        ? Container()
        : SizedBox(
            width: ScreenUtil().setWidth(688),
            height: ScreenUtil().setHeight(265),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(ScreenUtil().setHeight(3)),
            // ),
            child: Swiper(
              autoplay: true,
              itemWidth: 100,
              pagination: const SwiperPagination(),
              itemCount: SwiperList.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                    onTap: () => Navigator.pushNamed(context, Routes.songListDetailPage, arguments: SwiperList[index]['id']),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl: '${SwiperList[index]['imageUrl']}',
                          placeholder: (context, url) =>Image.asset('assets/images/placeholder.png'),
                        )));
              },
            ),
          );
  }

  _getBanner() async {
    SwiperList.add({
      "id": 6,
      "imageUrl":"${Api.FILE_HOST}/banner/banner2.jpg"
    });
    SwiperList.add({
      "id": 7,
      "imageUrl":"${Api.FILE_HOST}/banner/banner3.jpg"
    });
    SwiperList.add({
      "id": 8,
      "imageUrl": "${Api.FILE_HOST}/banner/banner4.jpg"
    });

    return SwiperList;
  }
}
