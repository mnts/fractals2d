/*
import 'dart:typed_data';

import 'package:color/color.dart';
import 'package:fractal/fractal.dart';

class _MyComponentFractal extends Fractal {
  Color color;
  Color borderColor;
  double borderWidth;

  String text;
  double textSize;

  Uint8List? image;

  bool isHighlightVisible = false;

  MyComponentFractal({
    super.id,
    this.image,
    this.color = const Color.rgb(255, 255, 255),
    this.borderColor = const Color.rgb(0, 0, 0),
    this.borderWidth = 0.0,
    this.text = '',
    this.textSize = 20,
  });

  MyComponentFractal.copy(MyComponentFractal customData)
      : this(
          color: customData.color,
          borderColor: customData.borderColor,
          borderWidth: customData.borderWidth,
          text: customData.text,
          textSize: customData.textSize,
        );

  switchHighlight() {
    isHighlightVisible = !isHighlightVisible;
  }

  showHighlight() {
    isHighlightVisible = true;
  }

  hideHighlight() {
    isHighlightVisible = false;
  }

  MP toJson() => {};
}
*/