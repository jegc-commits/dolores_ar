import 'package:dolores_ar/dominio/pasaporte.dart';
import 'package:flutter_test/flutter_test.dart';

import 'ayudas_geo.dart';

void main() {
  final plaza = lugarEn('plaza', origen);

  test('lejos no hay sello', () {
    final p = Pasaporte();
    expect(p.registrarSiCerca(plaza, 120), false);
    expect(p.visitado('plaza'), false);
  });
  test('a menos de 40 m sí', () {
    final p = Pasaporte();
    expect(p.registrarSiCerca(plaza, 25), true);
    expect(p.visitado('plaza'), true);
    expect(p.total, 1);
  });
  test('exactamente 40 m cuenta', () {
    expect(Pasaporte().registrarSiCerca(plaza, 40), true);
  });
  test('una sola vez', () {
    final p = Pasaporte();
    expect(p.registrarSiCerca(plaza, 10), true);
    expect(p.registrarSiCerca(plaza, 10), false);
    expect(p.total, 1);
  });
  test('progreso', () {
    final p = Pasaporte()..registrarSiCerca(plaza, 5);
    expect(p.progreso(4), 0.25);
    expect(p.progreso(0), 0);
  });
}
