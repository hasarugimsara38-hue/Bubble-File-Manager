import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:bubble_file_manager/vault_gesture.dart';

void main() {
  group('isFreehandVaultGesture', () {
    test('accepts a roughly closed, tilted quadrilateral', () {
      final points = <Offset>[
        const Offset(100, 70),
        const Offset(150, 60),
        const Offset(205, 90),
        const Offset(220, 135),
        const Offset(185, 185),
        const Offset(130, 195),
        const Offset(80, 160),
        const Offset(65, 110),
        const Offset(100, 70),
      ];

      expect(isFreehandVaultGesture(points), isTrue);
    });

    test('accepts a wide hand-drawn rectangle', () {
      final points = <Offset>[
        const Offset(40, 80),
        const Offset(90, 72),
        const Offset(150, 75),
        const Offset(200, 85),
        const Offset(205, 125),
        const Offset(145, 132),
        const Offset(85, 128),
        const Offset(42, 118),
        const Offset(40, 80),
      ];

      expect(isFreehandVaultGesture(points), isTrue);
    });

    test('rejects a tap or a short line', () {
      expect(
        isFreehandVaultGesture(const <Offset>[
          Offset(100, 100),
          Offset(101, 101),
          Offset(102, 100),
        ]),
        isFalse,
      );
      expect(
        isFreehandVaultGesture(const <Offset>[
          Offset(10, 10),
          Offset(30, 11),
          Offset(50, 10),
          Offset(70, 11),
          Offset(90, 10),
          Offset(110, 11),
          Offset(130, 10),
          Offset(150, 11),
        ]),
        isFalse,
      );
    });

    test('rejects an open stroke and a skinny zig-zag', () {
      expect(
        isFreehandVaultGesture(const <Offset>[
          Offset(50, 50),
          Offset(90, 45),
          Offset(130, 50),
          Offset(170, 55),
          Offset(180, 95),
          Offset(175, 135),
          Offset(150, 150),
        ]),
        isFalse,
      );
      expect(
        isFreehandVaultGesture(const <Offset>[
          Offset(20, 20),
          Offset(90, 25),
          Offset(25, 30),
          Offset(90, 35),
          Offset(25, 40),
          Offset(90, 45),
          Offset(25, 50),
          Offset(90, 55),
          Offset(20, 20),
        ]),
        isFalse,
      );
    });
  });
}
