import 'package:color/color.dart';
import 'package:position_fractal/fractals/offset.dart';
import 'package:position_fractal/props/position.dart';
import 'package:signed_fractal/models/event.dart';

class CanvasState extends EventFractal {
  double _scale = 1.0;

  late final OffsetProp position = OffsetProp(this);

  double mouseScaleSpeed = 0.8;
  @override
  get dontStore => true;

  double maxScale = 8.0;
  double minScale = 1;

  Color color = Color.rgb(255, 255, 255);

  //GlobalKey canvasGlobalKey = GlobalKey();

  bool shouldAbsorbPointer = false;

  bool isInitialized = false;

  double get scale => _scale;
  CanvasState() {}

  updateCanvas() {
    notifyListeners();
  }

  setPosition(OffsetF offset) {
    print(offset);
    position.move(offset);
  }

  setScale(double scale) {
    _scale = scale;
  }

  updatePosition(OffsetF offset) {
    setPosition(position.value + offset);
  }

  updateScale(double scale) {
    _scale *= scale;
  }

  resetCanvasView() {
    position.value = OffsetF.zero;
    _scale = 1.0;
    notifyListeners();
  }

  OffsetF fromCanvasCoordinates(OffsetF position) {
    return (position - this.position.value) / scale;
  }

  OffsetF toCanvasCoordinates(OffsetF position) {
    return position * scale + this.position.value;
  }
}
