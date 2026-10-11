import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DriverBaghdadApp());
}

class DriverBaghdadApp extends StatelessWidget {
  const DriverBaghdadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DRIVER BAGHDAD',
      theme: ThemeData.dark(),
      home: const DriverGame(),
    );
  }
}

class DriverGame extends StatefulWidget {
  const DriverGame({super.key});

  @override
  State<DriverGame> createState() => _DriverGameState();
}

class _DriverGameState extends State<DriverGame> {
  Timer? timer;

  double speed = 0;
  double distance = 0;
  double lane = 0;
  double roadMove = 0;
  double steering = 0;

  bool playing = false;

  final Map<String, bool> keys = {
    'left': false,
    'right': false,
    'gas': false,
    'brake': false,
  };

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
      const Duration(milliseconds: 33),
      (_) => updateGame(),
    );
  }

  void updateGame() {
    if (!mounted || !playing) return;

    const dt = 0.033;

    if (keys['gas'] == true) {
      speed = math.min(180, speed + 45 * dt);
    } else {
      speed = math.max(0, speed - 7 * dt);
    }

    if (keys['brake'] == true) {
      speed = math.max(0, speed - 80 * dt);
    }

    if (keys['left'] == true) {
      steering = math.max(-1, steering - 3 * dt);
    } else if (keys['right'] == true) {
      steering = math.min(1, steering + 3 * dt);
    } else {
      steering *= 0.88;
    }

    lane = (lane + steering * dt * (0.7 + speed / 100))
        .clamp(-0.8, 0.8)
        .toDouble();

    roadMove += speed * dt * 8;
    distance += speed * dt / 3.6;

    setState(() {});
  }

  void startGame() {
    setState(() {
      playing = true;
    });
  }

  void stopControls() {
    for (final key in keys.keys.toList()) {
      keys[key] = false;
    }
  }

  void horn() {
    HapticFeedback.mediumImpact();
    SystemSound.play(SystemSoundType.alert);
  }

  Widget controlButton(
    String label,
    String keyName, {
    double size = 64,
    Color color = const Color(0xDD17232C),
  }) {
    return GestureDetector(
      onTapDown: (_) {
        keys[keyName] = true;
        if (!playing && keyName == 'gas') {
          startGame();
        }
      },
      onTapUp: (_) => keys[keyName] = false,
      onTapCancel: () => keys[keyName] = false,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white54,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget pedalButton(
    String label,
    String keyName,
  ) {
    return GestureDetector(
      onTapDown: (_) {
        keys[keyName] = true;
        if (!playing && keyName == 'gas') {
          startGame();
        }
      },
      onTapUp: (_) => keys[keyName] = false,
      onTapCancel: () => keys[keyName] = false,
      child: Container(
        width: 67,
        height: 78,
        decoration: BoxDecoration(
          color: const Color(0xEE20343F),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white54),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              keyName == 'gas' ? 'GAS' : 'فرامل',
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: BaghdadPainter(
                speed: speed,
                lane: lane,
                roadMove: roadMove,
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DRIVER BAGHDAD',
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFFFB21A),
                              ),
                            ),
                            Text(
                              'درايفر بغداد 🇮🇶',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xDD101820),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text('السرعة ${speed.round()} كم/س'),
                            Text('المسافة ${distance.floor()} م'),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: const Color(0xDD101820),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'السائق: علاوي ال حمادي\n'
                        'الرقم: 07880254887',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.7,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  if (!playing)
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xEE101820),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'DRIVER BAGHDAD',
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                fontSize: 25,
                                color: Color(0xFFFFB21A),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text('عالم السيارات وشوارع بغداد'),
                            const SizedBox(height: 15),
                            ElevatedButton(
                              onPressed: startGame,
                              child: const Text('ابدأ القيادة 🚘'),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const Spacer(),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          controlButton('◀', 'left'),
                          const SizedBox(width: 8),
                          controlButton('▶', 'right'),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: horn,
                            child: Container(
                              width: 54,
                              height: 54,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xDD17232C),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white54,
                                ),
                              ),
                              child: const Text(
                                '📣',
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          pedalButton('▰', 'brake'),
                          const SizedBox(width: 8),
                          pedalButton('▲', 'gas'),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BaghdadPainter extends CustomPainter {
  final double speed;
  final double lane;
  final double roadMove;

  BaghdadPainter({
    required this.speed,
    required this.lane,
    required this.roadMove,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final sky = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF3985B5),
          Color(0xFFF2C58A),
          Color(0xFFF5DFB6),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(
        Rect.fromLTWH(0, 0, w, h * 0.55),
      );

    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      sky,
    );

    // شمس بغداد
    canvas.drawCircle(
      Offset(w * 0.8, h * 0.17),
      27,
      Paint()..color = const Color(0xFFFFE3A4),
    );

    // مباني المدينة
    final buildingPaint = Paint();

    for (int i = 0; i < 24; i++) {
      final x = i * w / 22;
      final bw = 18.0 + (i * 13 % 28);
      final bh = 35.0 + (i * 29 % 65);

      buildingPaint.color = [
        const Color(0xFFB7A38A),
        const Color(0xFF8B938E),
        const Color(0xFFD0B99A),
      ][i % 3];

      canvas.drawRect(
        Rect.fromLTWH(
          x,
          h * 0.34 - bh,
          bw,
          bh,
        ),
        buildingPaint,
      );
    }

    // نهر دجلة
    final river = Path()
      ..moveTo(0, h * 0.43)
      ..lineTo(w, h * 0.45)
      ..lineTo(w, h * 0.70)
      ..lineTo(0, h * 0.73)
      ..close();

    canvas.drawPath(
      river,
      Paint()..color = const Color(0xFF3B9BA8),
    );

    final waterLine = Paint()
      ..color = Colors.white.withOpacity(0.20)
      ..strokeWidth = 1;

    for (int i = 0; i < 10; i++) {
      final y = h * 0.47 + i * 12.0;
      canvas.drawLine(
        Offset(w * 0.08, y),
        Offset(w * 0.92, y),
        waterLine,
      );
    }

    // الطريق
    final top = h * 0.32;
    final bottom = h * 1.05;

    double centerAt(double y) {
      final t = ((y - top) / (bottom - top)).clamp(0.0, 1.0);
      return w * 0.5 + math.sin(roadMove * 0.002) * w * 0.02 * t;
    }

    double halfAt(double y) {
      final t = ((y - top) / (bottom - top)).clamp(0.0, 1.0);
      return w * (0.12 + 0.39 * t);
    }

    final road = Path()
      ..moveTo(centerAt(top) - halfAt(top), top)
      ..lineTo(centerAt(top) + halfAt(top), top)
      ..lineTo(centerAt(bottom) + halfAt(bottom), bottom)
      ..lineTo(centerAt(bottom) - halfAt(bottom), bottom)
      ..close();

    canvas.drawPath(
      road,
      Paint()..color = const Color(0xFF343A3E),
    );

    final edge = Paint()
      ..color = const Color(0xFFF1D8A0)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(centerAt(top) - halfAt(top), top),
      Offset(centerAt(bottom) - halfAt(bottom), bottom),
      edge,
    );

    canvas.drawLine(
      Offset(centerAt(top) + halfAt(top), top),
      Offset(centerAt(bottom) + halfAt(bottom), bottom),
      edge,
    );

    // خطوط الطريق المتحركة
    final linePaint = Paint()
      ..color = const Color(0xFFECE8D5);

    for (int i = 0; i < 14; i++) {
      final z = ((i / 14 + roadMove * 0.0008) % 1);
      final y = top + z * (h - top);
      final half = halfAt(y);
      final center = centerAt(y);
      final dashH = 5 + z * 25;
      final dashW = 2 + z * 3;

      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(center - half / 3, y),
          width: dashW,
          height: dashH,
        ),
        linePaint,
      );

      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(center + half / 3, y),
          width: dashW,
          height: dashH,
        ),
        linePaint,
      );
    }

    // نخيل على جانبي الطريق
    for (int i = 0; i < 12; i++) {
      final z = ((i / 12 + roadMove * 0.00012) % 1);
      final y = h * 0.34 + z * h * 0.53;
      final t = (y - h * 0.32) / (h * 0.68);
      final scale = 0.3 + t;

      for (final side in [-1.0, 1.0]) {
        final x = w * 0.5 + side * (w * 0.17 + t * w * 0.37);

        canvas.drawLine(
          Offset(x, y),
          Offset(x - 2 * scale, y - 22 * scale),
          Paint()
            ..color = const Color(0xFF62492F)
            ..strokeWidth = 4 * scale,
        );

        for (int k = 0; k < 6; k++) {
          canvas.drawOval(
            Rect.fromCenter(
              center: Offset(
                x + math.cos(k * 1.1) * 10 * scale,
                y - 23 * scale + math.sin(k * 1.1) * 5 * scale,
              ),
              width: 20 * scale,
              height: 6 * scale,
            ),
            Paint()..color = const Color(0xFF267446),
          );
        }
      }
    }

    // السيارة الرئيسية
    final carX = centerAt(h * 0.83) + lane * halfAt(h * 0.83) * 0.65;
    final carY = h * 0.82;
    final carW = math.min(w * 0.23, 100.0);
    final carH = carW * 1.45;

    // ظل السيارة
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(carX, carY + carH * 0.35),
        width: carW * 1.3,
        height: carH * 0.25,
      ),
      Paint()..color = Colors.black.withOpacity(0.35),
    );

    // جسم السيارة
    final carPath = Path()
      ..moveTo(carX - carW * 0.42, carY + carH * 0.4)
      ..lineTo(carX - carW * 0.5, carY - carH * 0.15)
      ..quadraticBezierTo(
        carX - carW * 0.5,
        carY - carH * 0.42,
        carX - carW * 0.25,
        carY - carH * 0.46,
      )
      ..lineTo(carX + carW * 0.25, carY - carH * 0.46)
      ..quadraticBezierTo(
        carX + carW * 0.5,
        carY - carH * 0.42,
        carX + carW * 0.5,
        carY - carH * 0.15,
      )
      ..lineTo(carX + carW * 0.42, carY + carH * 0.4)
      ..close();

    canvas.drawPath(
      carPath,
      Paint()..color = const Color(0xFF101820),
    );

    // زجاج السيارة
    final glass = Path()
      ..moveTo(carX - carW * 0.3, carY - carH * 0.17)
      ..lineTo(carX - carW * 0.22, carY - carH * 0.37)
      ..lineTo(carX + carW * 0.22, carY - carH * 0.37)
      ..lineTo(carX + carW * 0.3, carY - carH * 0.17)
      ..close();

    canvas.drawPath(
      glass,
      Paint()..color = const Color(0xFF8CBAC7),
    );

    // الأنوار الخلفية
    final lights = Paint()..color = Colors.redAccent;

    canvas.drawRect(
      Rect.fromLTWH(
        carX - carW * 0.4,
        carY + carH * 0.26,
        carW * 0.18,
        carH * 0.09,
      ),
      lights,
    );

    canvas.drawRect(
      Rect.fromLTWH(
        carX + carW * 0.22,
        carY + carH * 0.26,
        carW * 0.18,
        carH * 0.09,
      ),
      lights,
    );

    // لوحة السيارة
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'IRAQ',
        style: TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(carX - textPainter.width / 2, carY + carH * 0.16),
    );
  }

  @override
  bool shouldRepaint(covariant BaghdadPainter oldDelegate) {
    return oldDelegate.speed != speed ||
        oldDelegate.lane != lane ||
        oldDelegate.roadMove != roadMove;
  }
}