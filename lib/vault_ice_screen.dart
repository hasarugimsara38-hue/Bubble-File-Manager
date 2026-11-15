import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import 'app_language.dart';

/// A separate glacial visual environment for the encrypted Secret Vault.
class VaultIceScreen extends StatefulWidget {
  const VaultIceScreen({
    super.key,
    required this.files,
    required this.onImport,
    required this.onExport,
    required this.onChangePassword,
    required this.onChangeRecovery,
    this.busy = false,
  });

  final List<File> files;
  final Future<void> Function() onImport;
  final Future<void> Function(File file) onExport;
  final Future<void> Function() onChangePassword;
  final Future<void> Function() onChangeRecovery;
  final bool busy;

  @override
  State<VaultIceScreen> createState() => _VaultIceScreenState();
}

class _VaultIceScreenState extends State<VaultIceScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _iceMotion;

  @override
  void initState() {
    super.initState();
    _iceMotion = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
  }

  @override
  void dispose() {
    _iceMotion.dispose();
    super.dispose();
  }

  String _addedDate(File file) {
    final token = file.uri.pathSegments.last.split('.').first;
    final micros = int.tryParse(token);
    if (micros == null) return AppLanguage.text('Encrypted item');
    final date = DateTime.fromMicrosecondsSinceEpoch(micros);
    return '${AppLanguage.text('Added')} · ${date.year.toString().padLeft(4, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _importFile() async {
    Navigator.of(context).pop();
    await widget.onImport();
  }

  Future<void> _exportFile(File file) async {
    Navigator.of(context).pop();
    await widget.onExport(file);
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.files.length;
    return Scaffold(
      backgroundColor: const Color(0xFF061927),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _iceMotion,
              builder: (context, child) => CustomPaint(
                painter: _GlacierBackgroundPainter(_iceMotion.value),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: <Widget>[
                _topBar(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
                    children: <Widget>[
                      _heroPanel(count),
                      const SizedBox(height: 18),
                      _primaryAction(),
                      const SizedBox(height: 12),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: _secondaryAction(
                              icon: Icons.key_rounded,
                              label: 'Change password',
                              onTap: widget.onChangePassword,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _secondaryAction(
                              icon: Icons.shield_outlined,
                              label: 'Recovery settings',
                              onTap: widget.onChangeRecovery,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 26),
                      _fileHeading(count),
                      const SizedBox(height: 11),
                      if (widget.busy)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 14),
                          child: LinearProgressIndicator(
                            minHeight: 2,
                            backgroundColor: Color(0x3325C9E8),
                            color: Color(0xFFB8F4FF),
                          ),
                        ),
                      if (widget.files.isEmpty)
                        _emptyState()
                      else
                        ...List<Widget>.generate(
                          widget.files.length,
                          (index) => _fileTile(widget.files[index], index),
                        ),
                      const SizedBox(height: 20),
                      _securityNote(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 7, 16, 4),
      child: Row(
        children: <Widget>[
          IconButton(
            tooltip: AppLanguage.text('Back'),
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0x3328D8F2),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: const Color(0x668DEEFF)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(Icons.ac_unit_rounded,
                    size: 14, color: Color(0xFFBDF7FF)),
                const SizedBox(width: 7),
                Text(
                  AppLanguage.text('ICE-CORE SECURITY'),
                  style: const TextStyle(
                    color: Color(0xFFE4FBFF),
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroPanel(int count) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 11, sigmaY: 11),
        child: Container(
          padding: const EdgeInsets.fromLTRB(19, 20, 19, 18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Color(0xB83F9DBB),
                Color(0xA612536F),
                Color(0xB8072B47),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0x99D8FAFF), width: 1.15),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x4031D6F4),
                blurRadius: 28,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Icon(Icons.lock_outline_rounded,
                      color: Color(0xFFDDFBFF), size: 16),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      AppLanguage.text('PRIVATE • ENCRYPTED • LOCAL'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFD4F7FF),
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.05,
                      ),
                    ),
                  ),
                  const Icon(Icons.verified_user_rounded,
                      color: Color(0xFFB8F7F0), size: 17),
                ],
              ),
              const SizedBox(height: 11),
              AnimatedBuilder(
                animation: _iceMotion,
                builder: (context, child) {
                  final angle = math.sin(_iceMotion.value * math.pi * 2) * .035;
                  return Transform.rotate(
                    angle: angle,
                    child: const CustomPaint(
                      size: Size(96, 96),
                      painter: _IceCrystalPainter(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              const Text(
                'SECRET VAULT',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3.2,
                  shadows: <Shadow>[
                    Shadow(color: Color(0xAA5AEAFF), blurRadius: 18),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Text(
                AppLanguage.text('Glacier-protected private storage'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFD2F4FF),
                  fontSize: 12,
                  letterSpacing: .45,
                ),
              ),
              const SizedBox(height: 17),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _statusChip(
                      Icons.ac_unit_rounded,
                      '$count ${AppLanguage.text('encrypted files')}',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _statusChip(
                      Icons.verified_rounded,
                      'AES-256-GCM',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0x3324D2F3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0x558CEEFF)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, color: const Color(0xFFC4F7FF), size: 14),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _primaryAction() {
    return SizedBox(
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: <Color>[
              Color(0xFFE7FCFF),
              Color(0xFF9CEBFA),
              Color(0xFF60CFEA),
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x5536CBEA),
              blurRadius: 18,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: FilledButton.icon(
          onPressed: widget.busy ? null : _importFile,
          icon: const Icon(Icons.add_circle_outline_rounded,
              color: Color(0xFF06314A)),
          label: Text(
            AppLanguage.text('Add a file'),
            style: const TextStyle(
              color: Color(0xFF06314A),
              fontWeight: FontWeight.w900,
              letterSpacing: .35,
            ),
          ),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: const Color(0xFF6A9EAD),
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
    );
  }

  Widget _secondaryAction({
    required IconData icon,
    required String label,
    required Future<void> Function() onTap,
  }) {
    return Material(
      color: const Color(0x4424A8C8),
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        borderRadius: BorderRadius.circular(17),
        onTap: widget.busy ? null : onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 72),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: const Color(0x668FE9FA)),
          ),
          child: Column(
            children: <Widget>[
              Icon(icon, color: const Color(0xFFD6FAFF), size: 22),
              const SizedBox(height: 7),
              Text(
                AppLanguage.text(label),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fileHeading(int count) {
    return Row(
      children: <Widget>[
        const Icon(Icons.ac_unit_rounded,
            color: Color(0xFFB8F2FF), size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            AppLanguage.text('FROZEN FILES'),
            style: const TextStyle(
              color: Color(0xFFE7FBFF),
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.7,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0x3328D8F2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0x668DEEFF)),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }

  Widget _emptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 25),
      decoration: BoxDecoration(
        color: const Color(0x2229B6D7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x557FE7FA)),
      ),
      child: Column(
        children: <Widget>[
          const CustomPaint(
            size: Size(76, 76),
            painter: _IceCrystalPainter(),
          ),
          const SizedBox(height: 12),
          Text(
            AppLanguage.text('Your vault is frozen and empty'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            AppLanguage.text('Files you encrypt will be kept safely here.'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFB9DDE8),
              fontSize: 11,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _fileTile(File file, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: const Color(0x3327A9C8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x5579DDF0)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 3),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: <Color>[Color(0xFFB8F5FF), Color(0xFF318EBB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(Icons.ac_unit_rounded,
              color: Color(0xFF07334B), size: 23),
        ),
        title: Text(
          '${AppLanguage.text('Encrypted item')} ${index + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
        subtitle: Text(
          _addedDate(file),
          style: const TextStyle(color: Color(0xFFB9DDE8), fontSize: 10),
        ),
        trailing: IconButton(
          tooltip: AppLanguage.text('Export file'),
          onPressed: widget.busy ? null : () => _exportFile(file),
          icon: const Icon(Icons.file_download_outlined,
              color: Color(0xFFD7FAFF)),
        ),
      ),
    );
  }

  Widget _securityNote() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0x2225A6C5),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0x4477D8EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(Icons.lock_clock_outlined,
              color: Color(0xFFBDEFFF), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              AppLanguage.text('Vault data stays encrypted on this device.'),
              style: const TextStyle(
                color: Color(0xFFC7E8F1),
                fontSize: 10,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlacierBackgroundPainter extends CustomPainter {
  const _GlacierBackgroundPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFF102F46),
            Color(0xFF071D31),
            Color(0xFF041421),
          ],
        ).createShader(bounds),
    );

    final glow = Paint()
      ..shader = RadialGradient(
        colors: <Color>[
          const Color(0xFF42D8F2).withValues(alpha: .23),
          const Color(0xFF1D7EA8).withValues(alpha: .08),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * .82, size.height * .29),
          radius: size.width * .85,
        ),
      );
    canvas.drawRect(bounds, glow);

    _drawFacet(canvas, <Offset>[
      Offset(0, size.height * .08),
      Offset(size.width * .31, 0),
      Offset(size.width * .12, size.height * .48),
      Offset(0, size.height * .61),
    ], const Color(0x1677E8F7));
    _drawFacet(canvas, <Offset>[
      Offset(size.width, size.height * .12),
      Offset(size.width * .68, size.height * .30),
      Offset(size.width, size.height * .58),
    ], const Color(0x1A9AEFFF));
    _drawFacet(canvas, <Offset>[
      Offset(size.width * .08, size.height),
      Offset(size.width * .43, size.height * .72),
      Offset(size.width * .68, size.height),
    ], const Color(0x1428B3D7));
    _drawFacet(canvas, <Offset>[
      Offset(size.width * .55, size.height * .47),
      Offset(size.width, size.height * .57),
      Offset(size.width, size.height),
      Offset(size.width * .76, size.height * .82),
    ], const Color(0x1269DDF0));

    final beamX = -size.height * .45 +
        (size.width + size.height * 1.2) * progress;
    final beam = Path()
      ..moveTo(beamX, 0)
      ..lineTo(beamX + size.height * .16, 0)
      ..lineTo(beamX - size.height * .34, size.height)
      ..lineTo(beamX - size.height * .50, size.height)
      ..close();
    canvas.drawPath(
      beam,
      Paint()
        ..shader = LinearGradient(
          colors: <Color>[
            Colors.transparent,
            const Color(0x20D8FAFF),
            Colors.transparent,
          ],
        ).createShader(bounds),
    );

    for (var i = 0; i < 15; i++) {
      final x = ((i * 67.0) % (size.width + 20)) - 10;
      final baseY = (i * 113.0) % (size.height + 20);
      final drift = math.sin(progress * math.pi * 2 + i) * 13;
      final y = (baseY + progress * (size.height + 30)) %
          (size.height + 20);
      final alpha = .18 + .22 * math.sin(progress * math.pi * 2 + i).abs();
      final paint = Paint()
        ..color = const Color(0xFFDDFBFF).withValues(alpha: alpha);
      canvas.drawCircle(Offset(x + drift, y), i % 4 == 0 ? 2.1 : 1.1, paint);
    }
  }

  void _drawFacet(Canvas canvas, List<Offset> points, Color color) {
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color);
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0x227FEAFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant _GlacierBackgroundPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _IceCrystalPainter extends CustomPainter {
  const _IceCrystalPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * .43;
    final outer = <Offset>[
      Offset(center.dx, center.dy - radius),
      Offset(center.dx + radius * .78, center.dy - radius * .36),
      Offset(center.dx + radius * .78, center.dy + radius * .36),
      Offset(center.dx, center.dy + radius),
      Offset(center.dx - radius * .78, center.dy + radius * .36),
      Offset(center.dx - radius * .78, center.dy - radius * .36),
    ];
    final shape = Path()..moveTo(outer.first.dx, outer.first.dy);
    for (final point in outer.skip(1)) {
      shape.lineTo(point.dx, point.dy);
    }
    shape.close();

    canvas.drawPath(
      shape,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFFF0FFFF),
            Color(0xFF8DEAFF),
            Color(0xFF2389C1),
          ],
        ).createShader(Offset.zero & size),
    );
    canvas.drawPath(
      shape,
      Paint()
        ..color = const Color(0xFFDDFBFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    final facets = Paint();
    for (var i = 0; i < outer.length; i++) {
      final next = outer[(i + 1) % outer.length];
      final facet = Path()
        ..moveTo(center.dx, center.dy)
        ..lineTo(outer[i].dx, outer[i].dy)
        ..lineTo(next.dx, next.dy)
        ..close();
      facets.color = i.isEven
          ? const Color(0x6650A9D2)
          : const Color(0x44FFFFFF);
      canvas.drawPath(facet, facets);
    }
    final line = Paint()
      ..color = const Color(0xDDF4FFFF)
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;
    for (final point in outer) {
      canvas.drawLine(center, point, line);
    }
    canvas.drawCircle(
      center,
      radius * .12,
      Paint()..color = const Color(0xFFFFFFFF),
    );
  }

  @override
  bool shouldRepaint(covariant _IceCrystalPainter oldDelegate) => false;
}
