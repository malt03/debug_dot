import 'dart:math';
import 'dart:ui';

Offset _clampPoint(Offset p, Rect rect) {
  final x = p.dx.clamp(rect.left, rect.right);
  final y = p.dy.clamp(rect.top, rect.bottom);
  return Offset(x, y);
}

Offset _closestPointOnRectEdge({required Offset p, required Rect rect}) {
  final clamped = _clampPoint(p, rect);
  if (p != clamped) return clamped;

  final leftDist = (p.dx - rect.left).abs();
  final rightDist = (rect.right - p.dx).abs();
  final topDist = (p.dy - rect.top).abs();
  final bottomDist = (rect.bottom - p.dy).abs();

  final minDist = min(min(leftDist, rightDist), min(topDist, bottomDist));

  if (minDist == leftDist) return Offset(rect.left, p.dy);
  if (minDist == rightDist) return Offset(rect.right, p.dy);
  if (minDist == topDist) return Offset(p.dx, rect.top);
  return Offset(p.dx, rect.bottom);
}

bool _isNearlyZero(double x) => x.abs() < 1e-10;

Offset projectToRectEdge({required Offset p, required Offset v, required Rect rect}) {
  const double epsilon = 1e-10;
  final dx = v.dx;
  final dy = v.dy;

  final isNearlyZeroDx = _isNearlyZero(dx);
  final isNearlyZeroDy = _isNearlyZero(dy);
  if (isNearlyZeroDx && isNearlyZeroDy) return _closestPointOnRectEdge(p: p, rect: rect);

  double tx1, tx2, ty1, ty2;

  if (isNearlyZeroDx) {
    tx1 = double.negativeInfinity;
    tx2 = double.infinity;
  } else {
    tx1 = (rect.left - p.dx) / dx;
    tx2 = (rect.right - p.dx) / dx;
  }

  if (isNearlyZeroDy) {
    ty1 = double.negativeInfinity;
    ty2 = double.infinity;
  } else {
    ty1 = (rect.top - p.dy) / dy;
    ty2 = (rect.bottom - p.dy) / dy;
  }

  final txMin = min(tx1, tx2);
  final txMax = max(tx1, tx2);
  final tyMin = min(ty1, ty2);
  final tyMax = max(ty1, ty2);

  final tEnter = max(txMin, tyMin);
  final tExit = min(txMax, tyMax);

  if (tExit < max(tEnter, epsilon)) return _closestPointOnRectEdge(p: p, rect: rect);

  final clamped = _clampPoint(p, rect);
  final inside = (p == clamped);

  final tHit = inside ? tExit : max(tEnter, epsilon);

  return Offset(p.dx + dx * tHit, p.dy + dy * tHit);
}

const double _k = 0.05;
double _smoothAxis(double v, double minVal, double maxVal) {
  if (v < minVal) {
    return minVal - log(-_k * (v - minVal) + 1) / _k;
  } else if (v > maxVal) {
    return maxVal + log(_k * (v - maxVal) + 1) / _k;
  } else {
    return v;
  }
}

Offset smoothClampPoint(Offset p, Rect rect) {
  final newX = _smoothAxis(p.dx, rect.left, rect.right);
  final newY = _smoothAxis(p.dy, rect.top, rect.bottom);
  return Offset(newX, newY);
}
