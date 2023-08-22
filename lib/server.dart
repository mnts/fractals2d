import 'package:fractal_socket/index.dart';
import 'package:fractals2d/connection.dart';

class Fractal2dServer extends FSocket with F2dConnection {
  Fractal2dServer({required super.name});
}
