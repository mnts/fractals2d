import 'package:color/color.dart';
import 'package:fractal/models/event.dart';
import '../lib.dart';

class CanvasState extends EventFractal {
  double _scale = 1.0;

  var position = OffsetF(900, 900);

  double mouseScaleSpeed = 0.8;
  @override
  get dontStore => true;

  double maxScale = 8.0;
  double minScale = 0.1;

  Color color = Color.rgb(255, 255, 255);

  //GlobalKey canvasGlobalKey = GlobalKey();

  bool shouldAbsorbPointer = false;

  bool isInitialized = false;

  double get scale => _scale;
  CanvasState();

  updateCanvas() {
    notifyListeners();
  }

  setPosition(OffsetF offset) {
    position = offset;
  }

  setScale(double scale) {
    _scale = scale;
    notifyListeners();
  }

  updatePosition(OffsetF offset) {
    setPosition(position + offset);
  }

  updateScale(double scale) {
    _scale *= scale;
  }

  resetCanvasView() {
    position = OffsetF.zero;
    _scale = 1.0;
    notifyListeners();
  }

  OffsetF fromCanvasCoordinates(OffsetF position) {
    return (position - this.position) / scale;
  }

  OffsetF toCanvasCoordinates(OffsetF position) {
    return position * scale + this.position;
  }
}
