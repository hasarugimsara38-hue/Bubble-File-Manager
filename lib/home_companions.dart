import 'dart:async';
import 'dart:math' as math;

import 'package:characters/characters.dart';
import 'package:flutter/material.dart';

class HomeCompanionsPanel extends StatefulWidget {
  const HomeCompanionsPanel({
    super.key,
    required this.accent,
    required this.isSinhala,
    required this.onAction,
  });

  final Color accent;
  final bool isSinhala;
  final ValueChanged<String> onAction;

  @override
  State<HomeCompanionsPanel> createState() => _HomeCompanionsPanelState();
}

class _CompanionChoice {
  const _CompanionChoice(this.label, this.action);

  final String label;
  final String action;
}

class _HomeCompanionsPanelState extends State<HomeCompanionsPanel>
    with SingleTickerProviderStateMixin {
  Timer? _typingTimer;
  late final AnimationController _characterMotion;
  String _speaker = 'Hasaru';
  String _fullText = '';
  String _visibleText = '';
  List<String> _glyphs = <String>[];
  List<_CompanionChoice> _choices = <_CompanionChoice>[];
  int _typedCount = 0;
  bool _typing = false;
  bool _collapsed = false;

  @override
  void initState() {
    super.initState();
    _characterMotion = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    )..repeat();
    _showWelcome(initial: true);
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _characterMotion.dispose();
    super.dispose();
  }

  void _setDialogue({
    required String speaker,
    required String message,
    required List<_CompanionChoice> choices,
    bool initial = false,
  }) {
    _typingTimer?.cancel();
    final glyphs = message.characters.toList(growable: false);

    void update() {
      _speaker = speaker;
      _fullText = message;
      _visibleText = '';
      _glyphs = glyphs;
      _choices = choices;
      _typedCount = 0;
      _typing = glyphs.isNotEmpty;
    }

    if (initial) {
      update();
    } else {
      setState(update);
    }

    if (glyphs.isEmpty) return;
    _typingTimer = Timer.periodic(const Duration(milliseconds: 18), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_typedCount >= _glyphs.length) {
        timer.cancel();
        if (_typing) setState(() => _typing = false);
        return;
      }
      setState(() {
        _visibleText += _glyphs[_typedCount];
        _typedCount++;
        if (_typedCount >= _glyphs.length) {
          _typing = false;
          timer.cancel();
        }
      });
    });
  }

  void _showWelcome({bool initial = false}) {
    _setDialogue(
      speaker: 'Hasaru',
      message: widget.isSinhala
          ? 'හායි! මම Hasaru. ඔයාගේ ගොනු පිළිවෙළට තබාගන්න මම උදව් කරන්නම්. අද අපි මොනවා බලමුද?'
          : 'Hi! I am Hasaru. I can help you keep your files organised. What would you like to explore today?',
      choices: <_CompanionChoice>[
        _CompanionChoice(widget.isSinhala ? 'ගොනු පිරික්සන්න' : 'Browse files', 'files_intro'),
        _CompanionChoice(widget.isSinhala ? 'ඡායාරූප සහ වීඩියෝ' : 'Photos & videos', 'media_intro'),
        _CompanionChoice(widget.isSinhala ? 'විශේෂාංග' : 'Special features', 'features_intro'),
        _CompanionChoice(widget.isSinhala ? 'සහායකයාගෙන් අසන්න' : 'Ask Assistant', 'assistant'),
      ],
      initial: initial,
    );
  }

  void _choose(_CompanionChoice choice) {
    switch (choice.action) {
      case 'files_intro':
        _setDialogue(
          speaker: 'Hasaru',
          message: widget.isSinhala
              ? 'නියමයි! ෆෝල්ඩර්, ලේඛන සහ බාගත කළ ගොනු එකම තැනකින් බලන්න පුළුවන්. දැන් ගොනු විවෘත කරමුද?'
              : 'Great! You can browse folders, documents and downloads in one place. Shall we open Files?',
          choices: <_CompanionChoice>[
            _CompanionChoice(widget.isSinhala ? 'ගොනු විවෘත කරන්න' : 'Open Files', 'files'),
            _CompanionChoice(widget.isSinhala ? 'ආපසු' : 'Back', 'back'),
          ],
        );
        break;
      case 'media_intro':
        _setDialogue(
          speaker: 'Yunadie',
          message: widget.isSinhala
              ? 'හායි! මම Yunadie. ඡායාරූප, වීඩියෝ සහ ශ්‍රව්‍ය ගොනු වර්ග අනුව පහසුවෙන් බලන්න පුළුවන්. මොනවාද බලන්න කැමති?'
              : 'Hi! I am Yunadie. You can browse photos, videos and audio files by category. What would you like to see?',
          choices: <_CompanionChoice>[
            _CompanionChoice(widget.isSinhala ? 'රූප' : 'Images', 'images'),
            _CompanionChoice(widget.isSinhala ? 'වීඩියෝ' : 'Videos', 'videos'),
            _CompanionChoice(widget.isSinhala ? 'ශ්‍රව්‍ය' : 'Audio', 'audio'),
            _CompanionChoice(widget.isSinhala ? 'ආපසු' : 'Back', 'back'),
          ],
        );
        break;
      case 'features_intro':
        _setDialogue(
          speaker: 'Yunadie',
          message: widget.isSinhala
              ? 'අපේ විශේෂාංග බලමු! රහස් සුරක්ෂිතාගාරයෙන් ගොනු ආරක්ෂා කරන්නත්, මුහුණු සහ ස්ථාන ඇල්බමවලින් ඡායාරූප පිළිවෙළට සකස් කරන්නත් පුළුවන්.'
              : 'Let us explore the special features! The Secret Vault protects files, while Face and Location Albums help organise your photos.',
          choices: <_CompanionChoice>[
            _CompanionChoice(widget.isSinhala ? 'රහස් සුරක්ෂිතාගාරය' : 'Secret Vault', 'vault'),
            _CompanionChoice(widget.isSinhala ? 'මුහුණු ඇල්බම' : 'Face Albums', 'faces'),
            _CompanionChoice(widget.isSinhala ? 'ස්ථාන ඇල්බම' : 'Location Albums', 'locations'),
            _CompanionChoice(widget.isSinhala ? 'තවත් මෙවලම්' : 'More tools', 'tools'),
            _CompanionChoice(widget.isSinhala ? 'ආපසු' : 'Back', 'back'),
          ],
        );
        break;
      case 'back':
        _showWelcome();
        break;
      case 'files':
      case 'images':
      case 'videos':
      case 'audio':
      case 'vault':
      case 'faces':
      case 'locations':
      case 'assistant':
      case 'tools':
        widget.onAction(choice.action);
        break;
    }
  }

  void _showAllText() {
    _typingTimer?.cancel();
    setState(() {
      _visibleText = _fullText;
      _typedCount = _glyphs.length;
      _typing = false;
    });
  }

  Widget _nameTag(String name, bool active) => AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
        decoration: BoxDecoration(
          color: active ? widget.accent.withOpacity(.22) : Colors.white.withOpacity(.07),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: active ? widget.accent.withOpacity(.85) : Colors.white.withOpacity(.16),
          ),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: active ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (_collapsed) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xE6103048),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: widget.accent.withOpacity(.38)),
        ),
        child: ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 2),
          leading: Icon(Icons.chat_bubble_rounded, color: widget.accent),
          title: Text(
            widget.isSinhala ? 'Hasaru සහ Yunadie සමඟ කතා කරන්න' : 'Talk with Hasaru & Yunadie',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
          ),
          subtitle: Text(widget.isSinhala ? 'ඔබේ Aqua මිතුරන් මෙහි සිටී' : 'Your Aqua companions are here', style: const TextStyle(color: Colors.white60, fontSize: 11)),
          trailing: IconButton(
            tooltip: widget.isSinhala ? 'චරිත පෙන්වන්න' : 'Show companions',
            onPressed: () => setState(() => _collapsed = false),
            icon: const Icon(Icons.expand_more_rounded, color: Colors.white),
          ),
          onTap: () => setState(() => _collapsed = false),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Color(0xE8144565), Color(0xE60B273F), Color(0xE61A2852)],
        ),
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: widget.accent.withOpacity(.48), width: 1.15),
        boxShadow: <BoxShadow>[
          BoxShadow(color: widget.accent.withOpacity(.10), blurRadius: 20, spreadRadius: 1),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.auto_awesome_rounded, color: widget.accent, size: 18),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  widget.isSinhala ? 'HASARU සහ YUNADIE' : 'HASARU & YUNADIE',
                  style: TextStyle(color: Colors.white, fontSize: 12, letterSpacing: 1.1, fontWeight: FontWeight.w800),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.white.withOpacity(.08), borderRadius: BorderRadius.circular(20)),
                child: Text(widget.isSinhala ? 'Aqua මිතුරන්' : 'Aqua companions', style: const TextStyle(color: Colors.white70, fontSize: 10)),
              ),
              IconButton(
                tooltip: widget.isSinhala ? 'චරිත හකුළන්න' : 'Minimize companions',
                visualDensity: VisualDensity.compact,
                onPressed: () => setState(() => _collapsed = true),
                icon: const Icon(Icons.keyboard_arrow_up_rounded, color: Colors.white70),
              ),
            ],
          ),
          SizedBox(
            height: 126,
            width: double.infinity,
            child: CustomPaint(
              painter: _AnimeDuoPainter(
              speaker: _speaker,
              accent: widget.accent,
              motion: _characterMotion,
            ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _nameTag('Hasaru', _speaker == 'Hasaru'),
              _nameTag('Yunadie', _speaker == 'Yunadie'),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(12, 11, 10, 11),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.095),
              borderRadius: BorderRadius.circular(17),
              border: Border.all(color: Colors.white.withOpacity(.12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.forum_rounded, color: widget.accent, size: 15),
                    const SizedBox(width: 6),
                    Text(_speaker, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800)),
                    const Spacer(),
                    if (_typing)
                      TextButton(
                        onPressed: _showAllText,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          foregroundColor: widget.accent,
                        ),
                        child: Text(widget.isSinhala ? 'සියල්ල පෙන්වන්න' : 'Show all', style: const TextStyle(fontSize: 10)),
                      ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  _typing ? '$_visibleText▍' : _visibleText,
                  style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.42),
                ),
              ],
            ),
          ),
          if (!_typing && _choices.isNotEmpty) ...<Widget>[
            const SizedBox(height: 10),
            Wrap(
              spacing: 7,
              runSpacing: 7,
              children: _choices.map((choice) => ActionChip(
                onPressed: () => _choose(choice),
                visualDensity: VisualDensity.compact,
                backgroundColor: widget.accent.withOpacity(.16),
                side: BorderSide(color: widget.accent.withOpacity(.52)),
                label: Text(
                  choice.label,
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                ),
                avatar: Icon(Icons.arrow_forward_rounded, color: widget.accent, size: 14),
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _AnimeDuoPainter extends CustomPainter {
  _AnimeDuoPainter({
    required this.speaker,
    required this.accent,
    required Animation<double> motion,
  }) : _motion = motion, super(repaint: motion);

  final String speaker;
  final Color accent;
  final Animation<double> _motion;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final scale = math.min(size.width / 300, size.height / 135);
    final phase = _motion.value * math.pi * 2;
    canvas.save();
    canvas.translate((size.width - 300 * scale) / 2, (size.height - 135 * scale) / 2);
    canvas.scale(scale);

    // Soft animated sparkles make the companion panel feel alive without
    // adding another heavy particle widget tree.
    for (var i = 0; i < 8; i++) {
      final angle = phase * .34 + i * math.pi / 4;
      final radius = 53.0 + (i % 3) * 7.0;
      final center = Offset(
        150 + math.cos(angle) * radius,
        69 + math.sin(angle * 1.2) * 35,
      );
      final pulse = .45 + .55 * math.sin(phase * 1.8 + i).abs();
      canvas.drawCircle(
        center,
        1.0 + pulse * 1.15,
        Paint()..color = accent.withOpacity(.18 + pulse * .42),
      );
    }

    _drawCharacter(
      canvas,
      const Offset(82, 41),
      girl: false,
      talking: speaker == 'Hasaru',
      phase: phase,
    );
    _drawCharacter(
      canvas,
      const Offset(220, 41),
      girl: true,
      talking: speaker == 'Yunadie',
      phase: phase + .9,
    );
    canvas.restore();
  }

  void _drawCharacter(
    Canvas canvas,
    Offset c, {
    required bool girl,
    required bool talking,
    required double phase,
  }) {
    final motionOffset = girl ? .8 : 0.0;
    final bob = math.sin(phase + motionOffset) * 2.1;
    final sway = math.sin(phase * .55 + motionOffset) * .022;
    canvas.save();
    canvas.translate(c.dx, c.dy + bob);
    canvas.rotate(sway);
    canvas.translate(-c.dx, -c.dy);
    final skin = const Color(0xFFFFDCCB);
    final hair = girl ? const Color(0xFF241338) : const Color(0xFF111827);
    final eye = girl ? const Color(0xFF9A5BFF) : const Color(0xFF238CFF);
    final outfit = girl ? const Color(0xFFEAF5FF) : const Color(0xFF082B59);
    final trim = girl ? const Color(0xFF5D8FEA) : const Color(0xFF19BDEB);
    final hairPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Color.lerp(hair, Colors.white, .20)!,
          hair,
          Color.lerp(hair, Colors.black, .28)!,
        ],
      ).createShader(Rect.fromLTWH(c.dx - 48, 6, 96, 128));
    final skinPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[Color(0xFFFFF0E6), Color(0xFFFFDCCB), Color(0xFFF2BDAE)],
      ).createShader(Rect.fromCenter(center: Offset(c.dx, 45), width: 48, height: 60));

    final halo = Paint()
      ..shader = RadialGradient(
        colors: <Color>[accent.withOpacity(talking ? .30 : .13), Colors.transparent],
      ).createShader(Rect.fromCircle(center: c, radius: 48));
    canvas.drawCircle(c, 48, halo);

    final outfitPath = Path()
      ..moveTo(c.dx - 49, 135)
      ..lineTo(c.dx - 44, 108)
      ..quadraticBezierTo(c.dx - 35, 79, c.dx - 12, 76)
      ..lineTo(c.dx + 12, 76)
      ..quadraticBezierTo(c.dx + 37, 80, c.dx + 46, 108)
      ..lineTo(c.dx + 51, 135)
      ..close();
    canvas.drawPath(outfitPath, Paint()..shader = LinearGradient(
      colors: <Color>[outfit, girl ? const Color(0xFF9ABCF7) : const Color(0xFF0878C9)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ).createShader(Rect.fromLTWH(c.dx - 50, 76, 100, 60)));
    canvas.drawPath(outfitPath, Paint()
      ..color = trim.withOpacity(.82)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6);

    if (girl) {
      final longHair = Path()
        ..moveTo(c.dx - 28, 32)
        ..quadraticBezierTo(c.dx - 50, 39, c.dx - 42, 91)
        ..quadraticBezierTo(c.dx - 45, 118, c.dx - 29, 132)
        ..lineTo(c.dx + 35, 132)
        ..quadraticBezierTo(c.dx + 51, 105, c.dx + 39, 51)
        ..quadraticBezierTo(c.dx + 28, 13, c.dx - 28, 32)
        ..close();
      canvas.drawPath(longHair, hairPaint);
    } else {
      final backHair = Path()
        ..moveTo(c.dx - 30, 42)
        ..quadraticBezierTo(c.dx - 42, 8, c.dx - 10, 8)
        ..quadraticBezierTo(c.dx + 24, -5, c.dx + 32, 22)
        ..quadraticBezierTo(c.dx + 48, 35, c.dx + 33, 67)
        ..lineTo(c.dx - 28, 68)
        ..close();
      canvas.drawPath(backHair, hairPaint);
    }

    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(c.dx, 74), width: 18, height: 27), const Radius.circular(7)),
      Paint()..color = skin,
    );
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - 25, 46), width: 13, height: 17), Paint()..color = skin);
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + 25, 46), width: 13, height: 17), Paint()..color = skin);
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx, 45), width: 47, height: 59), skinPaint);

    final faceShade = Paint()
      ..shader = const LinearGradient(
        colors: <Color>[Color(0x00FFFFFF), Color(0x22E88F91)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromCenter(center: Offset(c.dx, 47), width: 48, height: 60));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx, 45), width: 47, height: 59), faceShade);

    for (final side in <double>[-1, 1]) {
      canvas.drawOval(
        Rect.fromCenter(center: Offset(c.dx + side * 12, 47), width: 11, height: 15),
        Paint()..color = Colors.white,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(c.dx + side * 12, 48), width: 7, height: 11),
        Paint()
          ..shader = RadialGradient(
            colors: <Color>[Color.lerp(eye, Colors.white, .25)!, eye, const Color(0xFF171B36)],
          ).createShader(Rect.fromCenter(center: Offset(c.dx + side * 12, 48), width: 8, height: 12)),
      );
      canvas.drawCircle(Offset(c.dx + side * 12, 49), 3.2, Paint()..color = const Color(0xFF171B36));
      canvas.drawCircle(Offset(c.dx + side * 12 - 1.8, 45.5), 2, Paint()..color = Colors.white);
      canvas.drawLine(
        Offset(c.dx + side * 18, 38),
        Offset(c.dx + side * 7, 37),
        Paint()..color = hair..strokeWidth = 2.6..strokeCap = StrokeCap.round,
      );
      canvas.drawCircle(Offset(c.dx + side * 17, 61), 3.4, Paint()..color = const Color(0x44EF8294));
    }

    final mouth = Paint()..color = const Color(0xFF9E4655);
    final blinkPhase = (_motion.value + (girl ? .18 : .02)) % 1.0;
    if (blinkPhase < .035) {
      // Brief eyelid overlay; staggered so the two characters do not blink together.
      canvas.drawOval(
        Rect.fromCenter(center: Offset(c.dx - 12, 47), width: 13, height: 16),
        skinPaint,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(c.dx + 12, 47), width: 13, height: 16),
        skinPaint,
      );
      final lid = Paint()
        ..color = hair
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(c.dx - 18, 47), Offset(c.dx - 6, 47), lid);
      canvas.drawLine(Offset(c.dx + 6, 47), Offset(c.dx + 18, 47), lid);
    }

    if (talking) {
      final mouthHeight = 3.0 + math.sin(phase * 7).abs() * 6.0;
      canvas.drawOval(
        Rect.fromCenter(center: Offset(c.dx, 67), width: 8, height: mouthHeight),
        mouth,
      );
      canvas.drawOval(Rect.fromCenter(center: Offset(c.dx, 65), width: 5, height: 2), Paint()..color = Colors.white);
    } else {
      final smile = Path()
        ..moveTo(c.dx - 5, 65)
        ..quadraticBezierTo(c.dx, 72, c.dx + 5, 65);
      canvas.drawPath(smile, Paint()
        ..color = const Color(0xFF9E4655)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round);
    }

    final fringe = Path()
      ..moveTo(c.dx - 31, 43)
      ..quadraticBezierTo(c.dx - 36, 12, c.dx - 7, 13)
      ..quadraticBezierTo(c.dx + 5, 1, c.dx + 21, 17)
      ..quadraticBezierTo(c.dx + 39, 20, c.dx + 30, 45)
      ..lineTo(c.dx + 17, 34)
      ..lineTo(c.dx + 9, 44)
      ..lineTo(c.dx + 2, 32)
      ..lineTo(c.dx - 9, 45)
      ..lineTo(c.dx - 18, 34)
      ..close();
    canvas.drawPath(fringe, hairPaint);
    canvas.drawPath(fringe, Paint()
      ..color = trim.withOpacity(.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0);
    // Fine hair glints and a clean outfit accent lift the hand-drawn finish.
    canvas.drawPath(
      Path()
        ..moveTo(c.dx - 23, 24)
        ..quadraticBezierTo(c.dx - 12, 11, c.dx + 1, 16),
      Paint()
        ..color = Colors.white.withOpacity(.42)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      Offset(c.dx - 20, 112),
      Offset(c.dx + 20, 112),
      Paint()..color = Colors.white.withOpacity(.34)..strokeWidth = 1.0,
    );

    if (girl) {
      canvas.drawCircle(Offset(c.dx + 32, 19), 7, Paint()..color = const Color(0xFF56B9FF));
      for (var i = 0; i < 5; i++) {
        final angle = i * math.pi * 2 / 5;
        canvas.drawCircle(
          Offset(c.dx + 32 + math.cos(angle) * 5, 19 + math.sin(angle) * 5),
          3.4,
          Paint()..color = const Color(0xFFB9E7FF),
        );
      }
      canvas.drawCircle(Offset(c.dx + 32, 19), 2.2, Paint()..color = const Color(0xFF2866B7));
      canvas.drawLine(Offset(c.dx + 28, 83), Offset(c.dx + 32, 96),
        Paint()..color = trim..strokeWidth = 2.0..strokeCap = StrokeCap.round);
      canvas.drawCircle(Offset(c.dx + 32, 99), 3.2, Paint()..color = const Color(0xFF9A5BFF));
      final bow = Path()
        ..moveTo(c.dx - 4, 91)
        ..quadraticBezierTo(c.dx - 19, 80, c.dx - 21, 96)
        ..quadraticBezierTo(c.dx - 12, 106, c.dx - 4, 96)
        ..moveTo(c.dx + 4, 91)
        ..quadraticBezierTo(c.dx + 19, 80, c.dx + 21, 96)
        ..quadraticBezierTo(c.dx + 12, 106, c.dx + 4, 96)
        ..close();
      canvas.drawPath(bow, Paint()..color = const Color(0xFF398BE8));
      canvas.drawCircle(Offset(c.dx, 94), 4, Paint()..color = const Color(0xFFB7E8FF));
      canvas.drawCircle(Offset(c.dx, 116), 2.5, Paint()..color = const Color(0xFFFFD98B));
    } else {
      final hood = Path()
        ..moveTo(c.dx - 23, 86)
        ..quadraticBezierTo(c.dx, 103, c.dx + 23, 86)
        ..lineTo(c.dx + 37, 135)
        ..lineTo(c.dx - 37, 135)
        ..close();
      canvas.drawPath(hood, Paint()..color = const Color(0xFF061D3C).withOpacity(.9));
      canvas.drawPath(hood, Paint()
        ..color = trim.withOpacity(.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8);
      canvas.drawCircle(Offset(c.dx - 31, 88), 2.3, Paint()..color = trim);
      canvas.drawCircle(Offset(c.dx + 31, 88), 2.3, Paint()..color = trim);
      canvas.drawPath(
        Path()
          ..moveTo(c.dx - 13, 119)
          ..quadraticBezierTo(c.dx, 126, c.dx + 13, 119),
        Paint()
          ..color = trim.withOpacity(.75)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round,
      );
    }

    // A small wave gesture is animated for the character who is speaking.
    if (talking) {
      final side = girl ? 1.0 : -1.0;
      final lift = math.sin(phase * 2.2) * 5.0;
      final hand = Offset(c.dx + side * 47, 74 + lift);
      final armPaint = Paint()
        ..color = trim
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      canvas.drawPath(
        Path()
          ..moveTo(c.dx + side * 29, 103)
          ..quadraticBezierTo(c.dx + side * 42, 95 + lift, hand.dx, hand.dy),
        armPaint,
      );
      canvas.drawCircle(hand, 5.2, Paint()..color = skin);
      canvas.drawCircle(
        Offset(hand.dx + side * 1.5, hand.dy - 1.6),
        1.2,
        Paint()..color = Colors.white.withOpacity(.68),
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _AnimeDuoPainter oldDelegate) =>
      oldDelegate.speaker != speaker || oldDelegate.accent != accent;
}
