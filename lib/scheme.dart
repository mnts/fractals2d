import 'package:app_fractal/index.dart';
import 'package:currency_fractal/fractals/transaction.dart';
import 'package:fractal_socket/index.dart';

import 'fractals2d.dart';

class F2dScheme {
  Future init() async {
    await DBF.initiate();

    await SignedFractal.init();
    await DeviceFractal.initMy();
    await AppFractal.init();
    await Fractals2d.init();
    await SocketF.init();
    await TransactionFractal.controller.init();
    await FSys.setup();

    return;
  }
}
