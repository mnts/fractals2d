import 'dart:io';
import 'package:app_fractal/index.dart';
import 'package:fractal_base/fractals/device.dart';
import 'package:fractal_server/fractal_server.dart';
import 'package:fractal_socket/index.dart';
import 'package:fractals2d/lib.dart';
import 'package:currency_fractal/fractals/transaction.dart';

void main(List<String> args) async {
  FileF.path = './';
  await DBF.initiate();
  await SignedFractal.init();
  await AppFractal.init();
  await Fractals2d.init();

  await TransactionFractal.controller.init();

  NetworkFractal.active = NetworkFractal(
    name: 'fractal',
  );

  final dir = Directory.current.path;
  print(dir);

  FServer(
    port: args.isNotEmpty ? int.parse(args[0]) : 2415,
    buildSocket: (device) => ClientFractal(
      from: device,
      to: NetworkFractal.active,
    ),
  );
}
