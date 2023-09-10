import 'dart:io';

import 'package:fractal/types/file.dart';
import 'package:fractal_base/index.dart';
import 'package:fractal_server/fractal_server.dart';
import 'package:fractal_socket/socket.dart';
import 'package:fractals2d/lib.dart';
import 'package:fractal/utils/random.dart';

void main(List<String> args) async {
  FileF.path = './';
  await DBF.initiate();
  Fractals2d.init();

  final dir = Directory.current.path;
  print(dir);

  FServer(
    port: args.isNotEmpty ? int.parse(args[0]) : 8800,
    buildSocket: (name) => FSocket(
      name: name,
    ),
  );
}
