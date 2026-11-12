import 'package:dolores_ar/dominio/motor_ar.dart';
import 'package:flutter_test/flutter_test.dart';

import 'ayudas_geo.dart';

void main() {
  final frente = lugarEn('frente', desplazar(origen, norte: 100));
  final derecha = lugarEn('derecha', desplazar(origen, este: 100));
  final lejos = lugarEn('lejos', desplazar(origen, norte: 5000));

  test('lugar al frente aparece al centro', () {
    final r = calcularVisibles(usuario: origen, rumbo: 0, lugares: [frente]);
    expect(r.single.x, closeTo(0.5, 0.01));
    expect(r.single.distancia, closeTo(100, 1));
  });

  test('lugar a 90° a la derecha NO aparece mirando al norte', () {
    final r = calcularVisibles(usuario: origen, rumbo: 0, lugares: [derecha]);
    expect(r, isEmpty);
  });

  test('si giro al este, sí aparece', () {
    final r = calcularVisibles(usuario: origen, rumbo: 90, lugares: [derecha]);
    expect(r.single.x, closeTo(0.5, 0.01));
  });

  test('giro pequeño desplaza al lado contrario', () {
    final r = calcularVisibles(usuario: origen, rumbo: 10, lugares: [frente]);
    expect(r.single.x, lessThan(0.5));
  });

  test('más allá del radio máximo se descarta', () {
    final r = calcularVisibles(
        usuario: origen, rumbo: 0, lugares: [lejos], radioMax: 2000);
    expect(r, isEmpty);
  });

  test('cruza el 0°/360°', () {
    final casi = lugarEn('casi', desplazar(origen, norte: 100, este: 8.7));
    final r = calcularVisibles(usuario: origen, rumbo: 350, lugares: [casi]);
    expect(r, hasLength(1));
    expect(r.single.x, greaterThan(0.5));
  });

  test('lejanos primero para dibujarse debajo', () {
    final cerca = lugarEn('cerca', desplazar(origen, norte: 50));
    final media = lugarEn('media', desplazar(origen, norte: 500));
    final r =
        calcularVisibles(usuario: origen, rumbo: 0, lugares: [cerca, media]);
    expect(r.map((v) => v.lugar.id), ['media', 'cerca']);
  });

  test('lo cercano se ve más grande', () {
    final cerca = lugarEn('cerca', desplazar(origen, norte: 50));
    final lejos2 = lugarEn('media', desplazar(origen, norte: 1500));
    final r =
        calcularVisibles(usuario: origen, rumbo: 0, lugares: [cerca, lejos2]);
    final vC = r.firstWhere((v) => v.lugar.id == 'cerca');
    final vL = r.firstWhere((v) => v.lugar.id == 'media');
    expect(vC.escala, greaterThan(vL.escala));
    expect(vC.profundidad, lessThan(vL.profundidad));
  });

  test('FOV más ancho muestra más', () {
    final lado = lugarEn('lado', desplazar(origen, norte: 100, este: 80));
    expect(
        calcularVisibles(
            usuario: origen, rumbo: 0, lugares: [lado], campoVision: 60),
        isEmpty);
    expect(
        calcularVisibles(
            usuario: origen, rumbo: 0, lugares: [lado], campoVision: 100),
        hasLength(1));
  });
}
