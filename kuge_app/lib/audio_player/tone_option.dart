import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ToneOption {
  final int index;

  const ToneOption._internal(this.index);

  static const standard = ToneOption._internal(1);
  static const high = ToneOption._internal(2);
  static const lossless = ToneOption._internal(3);

  factory ToneOption.undefined(int index) {
    assert(!const [3, 1, 2].contains(index), "index can not be 3,1,2");
    return ToneOption(index);
  }

  factory ToneOption(int index) {
    if (index == 1) {
      return standard;
    } else if (index == 2) {
      return high;
    } else if (index == 3) {
      return lossless;
    } else {
      return ToneOption._internal(index);
    }
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is ToneOption && index == other.index;

  @override
  int get hashCode => index.hashCode;

  @override
  String toString() {
    switch (index) {
      case 3:
        return "ToneOption.lossless";
      case 2:
        return "ToneOption.high";
      case 1:
        return "ToneOption.standard";
      default:
        return "ToneOption.undefined($index)";
    }
  }

  String get name {
    if (this == ToneOption.high) {
      return "高品音质";
    } else if (this == ToneOption.lossless) {
      return "无损音质";
    } else {
      return "标准音质";
    }
  }
}