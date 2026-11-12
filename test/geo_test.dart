import 'package:dolores_ar/dominio/geo.dart';
import 'package:flutter_test/flutter_test.dart';

import 'ayudas_geo.dart';

void main() {
  group('distanciaMetros (Haversine)', () {
    test('un grado de latitud mide unos 111.2 km', () {
      expect(distanciaMetros(const Coordenada(0, 0), const Coordenada(1, 0)),
          closeTo(111195, 5));
    });
    test('el mismo punto está a 0 metros', () {
      expect(distanciaMetros(origen, origen), 0);
    });
    test('es simétrica: A→B = B→A', () {
      final b = desplazar(origen, norte: 300, este: 400);
      expect(distanciaMetros(origen, b),
          closeTo(distanciaMetros(b, origen), 0.001));
    });
    test('300 m norte + 400 m este = 500 m (3-4-5)', () {
      final b = desplazar(origen, norte: 300, este: 400);
      expect(distanciaMetros(origen, b), closeTo(500, 1));
    });
  });

  group('rumboGrados', () {
    test(
        'norte = 0º',
        () => expect(rumboGrados(origen, desplazar(origen, norte: 100)),
            closeTo(0, 0.01)));
    test(
        'este = 90º',
        () => expect(rumboGrados(origen, desplazar(origen, este: 100)),
            closeTo(90, 0.01)));
    test(
        'sur = 180º',
        () => expect(rumboGrados(origen, desplazar(origen, norte: -100)),
            closeTo(180, 0.01)));
    test(
        'oeste = 270º',
        () => expect(rumboGrados(origen, desplazar(origen, este: -100)),
            closeTo(270, 0.01)));
    test(
        'noreste = 45º',
        () => expect(
            rumboGrados(origen, desplazar(origen, norte: 100, este: 100)),
            closeTo(45, 0.05)));
  });

  group('ángulos', () {
    test('normalizar360', () {
      expect(normalizar360(-90), 270);
      expect(normalizar360(360), 0);
      expect(normalizar360(725), 5);
    });
    test('diferenciaAngular toma el camino corto', () {
      expect(diferenciaAngular(10, 350), 20);
      expect(diferenciaAngular(350, 10), -20);
      expect(diferenciaAngular(90, 90), 0);
      expect(diferenciaAngular(181, 0), -179);
    });
    test('suavizarAngulo avanza una fracción', () {
      expect(suavizarAngulo(100, 110, alfa: 0.5), closeTo(105, 1e-9));
    });
    test('suavizarAngulo cruza el 0° por el lado corto', () {
      expect(suavizarAngulo(350, 10, alfa: 0.5), closeTo(0, 1e-9));
    });
    test('nombreCardinal', () {
      expect(nombreCardinal(0), 'N');
      expect(nombreCardinal(44), 'NE');
      expect(nombreCardinal(90), 'E');
      expect(nombreCardinal(200), 'S');
      expect(nombreCardinal(270), 'O');
      expect(nombreCardinal(350), 'N');
    });
  });

  group('posicionHorizontal (FOV 60°)', () {
    test('frente = centro', () => expect(posicionHorizontal(0), 0.5));
    test('borde derecho',
        () => expect(posicionHorizontal(30), closeTo(1.0, 1e-9)));
    test('borde izquierdo',
        () => expect(posicionHorizontal(-30), closeTo(0.0, 1e-9)));
    test('medio camino',
        () => expect(posicionHorizontal(15), closeTo(0.75, 1e-9)));
    test('fuera del FOV no se dibuja', () {
      expect(posicionHorizontal(31), isNull);
      expect(posicionHorizontal(-90), isNull);
    });
  });

  group('formatearDistancia', () {
    test('metros y kilómetros', () {
      expect(formatearDistancia(85.4), '85 m');
      expect(formatearDistancia(999.4), '999 m');
      expect(formatearDistancia(1260), '1.3 km');
    });
  });
}
