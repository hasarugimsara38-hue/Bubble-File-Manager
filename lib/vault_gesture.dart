import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Recognises a rough, hand-drawn four-sided loop for the hidden Vault.
///
/// The gesture deliberately allows tilted and uneven quadrilaterals. It
/// checks the overall bounds, closure, perimeter, coverage around the centre,
/// and enclosed area so a tap, short stroke, or narrow zig-zag is rejected.
bool isFreehandVaultGesture(List<Offset> points) {
  if (points.length < 8) return false;

  var minX = double.infinity;
  var minY = double.infinity;
  var maxX = -double.infinity;
  var maxY = -double.infinity;
  var pathLength = 0.0;

  for (var i = 0; i < points.length; i++) {
    final point = points[i];
    minX = math.min(minX, point.dx);
    minY = math.min(minY, point.dy);
    maxX = math.max(maxX, point.dx);
    maxY = math.max(maxY, point.dy);
    if (i > 0) pathLength += (point - points[i - 1]).distance;
  }

  final width = maxX - minX;
  final height = maxY - minY;
  final side = math.max(width, height);
  if (math.min(width, height) < 42 || side == 0) return false;

  final ratio = width / height;
  if (ratio < .38 || ratio > 2.6) return false;

  final closingGap = (points.first - points.last).distance;
  if (closingGap > math.max(48.0, side * .42)) return false;
  if (pathLength < (width + height) * 1.05) return false;

  final center = Offset((minX + maxX) / 2, (minY + maxY) / 2);
  const twoPi = math.pi * 2;
  final sectors = <bool>[false, false, false, false];
  var twiceArea = 0.0;

  for (var i = 0; i < points.length; i++) {
    final point = points[i];
    final delta = point - center;
    if (delta.distance >= side * .18) {
      var angle = math.atan2(delta.dy, delta.dx);
      if (angle < 0) angle += twoPi;
      if (angle <= math.pi / 2 || angle >= twoPi - math.pi / 4) {
        sectors[0] = true;
      }
      if (angle >= math.pi / 4 && angle <= math.pi * 3 / 4) {
        sectors[1] = true;
      }
      if (angle >= math.pi * 3 / 4 && angle <= math.pi * 5 / 4) {
        sectors[2] = true;
      }
      if (angle >= math.pi * 5 / 4 && angle <= math.pi * 7 / 4) {
        sectors[3] = true;
      }
    }

    final next = points[(i + 1) % points.length];
    twiceArea += point.dx * next.dy - next.dx * point.dy;
  }

  if (!sectors.every((visited) => visited)) return false;
  final boxArea = width * height;
  return boxArea > 0 && twiceArea.abs() / 2 >= boxArea * .12;
}
