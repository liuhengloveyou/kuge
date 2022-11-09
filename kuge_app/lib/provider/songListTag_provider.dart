import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';

const songlistFilterCacheKey = "songlistFilterCacheKey";

class SongListTagProvider with ChangeNotifier {
  List<String> tags = ['推荐', '流行', "摇滚", "吉他", "蓝调", "地铁", "电子", '推荐', '流行', "摇滚", "吉他", "蓝调", "地铁", "电子"]; // 默认

  List<String> load() {
    final cachedTags = SpUtil.getStringList(songlistFilterCacheKey);
    if (cachedTags!.length > 10) {
      tags = cachedTags;
    }
    if (tags.isNotEmpty && tags[0] != "推荐") {
      tags.insert(0, "推荐");
    }
    if (tags.length > 1 && tags[1] == "推荐") {
      tags.removeAt(1);
    }
   
    return tags;
  }

  add(item) async {
    if (tags.length > 30) {
      return;
    }

    for (int i = 0; i < tags.length; i ++) {
      if (item == tags[i]) {
        return;
      }
    }

    tags.add(item);
    await SpUtil.putStringList(songlistFilterCacheKey, tags);

    notifyListeners();
  }

  del(item) async {
    if (item == "推荐") {
      return;
    }
    if (tags.length <= 10) {
      return;
    }
    
    tags.remove(item);
    await SpUtil.putStringList(songlistFilterCacheKey, tags);

    notifyListeners();
  }
}
