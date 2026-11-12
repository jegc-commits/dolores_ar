import 'dart:async';

import '../dominio/fuentes.dart';
import '../dominio/geo.dart';

/// Modo demo: para practicar en el salón de clases sin estar en Dolores Hidalgo.
class PosicionSimulada implements FuentePosicion {
  final Coordenada punto;
  PosicionSimulada(this.punto);

  @override
  Stream<Coordenada> get posiciones => Stream<Coordenada>.value(punto);
}

class BrujulaSimulada implements FuenteBrujula {
  final controlador = StreamController<double>.broadcast();
  double ultimo = 0;

  @override
  Stream<double> get rumbos async* {
    yield ultimo;
    yield* controlador.stream;
  }

  /// Llamado por el deslizador de la pantalla demo.
  void girar(double grados) {
    ultimo = grados;
    controlador.add(grados);
  }

  void cerrar() => controlador.close();
}
