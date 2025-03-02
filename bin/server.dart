import 'dart:io';
import 'package:app_fractal/index.dart';
import 'package:fractal_server/fractal_server.dart';
import 'package:fractal_socket/index.dart';
import 'package:fractals2d/lib.dart';

void main(List<String> args) async {
  FileF.path = './';

  print(Directory.current.path);

  final scheme = F2dScheme();
  await scheme.init();

  FServer(
    port: args.isNotEmpty ? int.parse(args[0]) : 2415,
  );
}
