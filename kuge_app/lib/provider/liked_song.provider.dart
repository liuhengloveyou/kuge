import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kuge_app/model/music.model.dart';
import 'package:kuge_app/service/user.service.dart';
import 'package:sp_util/sp_util.dart';

String likeSongListKey = "LIKE_SONG_LIST";
List<MusicModel> likeSongs = [];

class LikeSong with ChangeNotifier {
  List<MusicModel> get songs => likeSongs;

  static loadCache() {
    likeSongs = [];
    
    try {
      var cacheSong = SpUtil.getObjectList(likeSongListKey);
      if (cacheSong == null) {
        return;
      }

      for (int i = 0; i < cacheSong.length; i++) {
        likeSongs.add(MusicModel.fromJson(cacheSong[i] as Map<String, dynamic>));
      }
    }catch (e) {

    }
  }

  setCache(List<MusicModel> musics) {
    likeSongs = musics;
    SpUtil.putObjectList(likeSongListKey, likeSongs);

    notifyListeners();
  }

  bool isLiked(MusicModel music) {
    for (int i = 0; i < likeSongs.length; i++) {
      if (music.id == likeSongs[i].id) {
        return true;
      }
    }

    return false;
  }

  clickLikeMusic(MusicModel music) {
    music.words = "";

    for (int i = 0; i < likeSongs.length; i++) {
      if (music.id == likeSongs[i].id) {
        likeSongs.removeAt(i);
        SpUtil.putString(likeSongListKey, json.encode(likeSongs));

        return false;
      }
    }

    likeSongs.add(music);    
    SpUtil.putObjectList(likeSongListKey, likeSongs);
    UsersService.updateSongCollect(likeSongs.map((e) => e.id!).toList());

    notifyListeners();
    return true;
  }
}