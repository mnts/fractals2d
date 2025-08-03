import 'fractals2d.dart';

class F2dScheme {
  Future init() async {
    await SignedFractal.init();
    await DeviceFractal.initMy();
    await Fractals2d.init();
    //await TransactionFractal.controller.init();
    await FSys.setup();

    await ServicesF.init();
    print('network: ${NetworkFractal.active?.toMap() ?? 'none'} bb');
    return;
  }
}
