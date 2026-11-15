import 'package:exif/exif.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bubble_file_manager/location_albums.dart';

void main() {
  test('GPS rational values are converted to decimal degrees', () {
    final latitude = IfdTag(
      tag: 2,
      tagType: 'RATIONAL',
      printable: '6/1, 55/1, 30/1',
      values: IfdRatios(<Ratio>[
        Ratio(6, 1),
        Ratio(55, 1),
        Ratio(30, 1),
      ]),
    );
    final longitude = IfdTag(
      tag: 4,
      tagType: 'RATIONAL',
      printable: '79/1, 51/1, 15/1',
      values: IfdRatios(<Ratio>[
        Ratio(79, 1),
        Ratio(51, 1),
        Ratio(15, 1),
      ]),
    );

    expect(parseGpsCoordinate(latitude, 'N'), closeTo(6.925, 0.000001));
    expect(parseGpsCoordinate(latitude, 'S'), closeTo(-6.925, 0.000001));
    expect(
      parseGpsCoordinate(longitude, 'W'),
      closeTo(-(79 + 51 / 60 + 15 / 3600), 0.000001),
    );
  });

  test('GPS parser rejects incomplete or invalid DMS values', () {
    final incomplete = IfdTag(
      tag: 2,
      tagType: 'RATIONAL',
      printable: '6/1, 55/1',
      values: IfdRatios(<Ratio>[Ratio(6, 1), Ratio(55, 1)]),
    );
    final invalidMinutes = IfdTag(
      tag: 2,
      tagType: 'RATIONAL',
      printable: '6/1, 70/1, 0/1',
      values: IfdRatios(<Ratio>[
        Ratio(6, 1),
        Ratio(70, 1),
        Ratio(0, 1),
      ]),
    );

    expect(parseGpsCoordinate(null, 'N'), isNull);
    expect(parseGpsCoordinate(incomplete, 'N'), isNull);
    expect(parseGpsCoordinate(invalidMinutes, 'N'), isNull);
  });
}
