import 'dart:async';
import 'dart:math' as math;

import 'package:characters/characters.dart';
import 'package:flutter/material.dart';

class HomeCompanionsPanel extends StatefulWidget {
  const HomeCompanionsPanel({
    super.key,
    required this.accent,
    required this.onAction,
  });

  final Color accent;
  final ValueChanged<String> onAction;

  @override
  State<HomeCompanionsPanel> createState() => _HomeCompanionsPanelState();
}

class _CompanionChoice {
  const _CompanionChoice(this.label, this.action);

  final String label;
  final String action;
}

class _HomeCompanionsPanelState extends State<HomeCompanionsPanel> {
  Timer? _typingTimer;
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
    _showWelcome(initial: true);
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
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
      message: 'හායි! මම Hasaru. මම ඔයාට files පිළිවෙළට තබාගන්න උදව් කරන්නම්. අද අපි මොනවා බලමුද?',
      choices: const <_CompanionChoice>[
        _CompanionChoice('Browse files', 'files_intro'),
        _CompanionChoice('Photos & videos', 'media_intro'),
        _CompanionChoice('Special features', 'features_intro'),
        _CompanionChoice('Ask Assistant', 'assistant'),
      ],
      initial: initial,
    );
  }

  void _choose(_CompanionChoice choice) {
    switch (choice.action) {
      case 'files_intro':
        _setDialogue(
          speaker: 'Hasaru',
          message: 'නියමයි! ඔයාගේ folders, documents සහ downloads එකම තැනකින් බලන්න පුළුවන්. දැන් Files විවෘත කරමුද?',
          choices: const <_CompanionChoice>[
            _CompanionChoice('Open Files', 'files'),
            _CompanionChoice('Back', 'back'),
          ],
        );
        break;
      case 'media_intro':
        _setDialogue(
          speaker: 'Yunadie',
          message: 'හායි! මම Yunadie. ඔයාගේ photos, videos සහ audio files වර්ග අනුව පහසුවෙන් බලන්න පුළුවන්. මොනවාද බලන්න ඕනේ?',
          choices: const <_CompanionChoice>[
            _CompanionChoice('Images', 'images'),
            _CompanionChoice('Videos', 'videos'),
            _CompanionChoice('Audio', 'audio'),
            _CompanionChoice('Back', 'back'),
          ],
        );
        break;
      case 'features_intro':
        _setDialogue(
          speaker: 'Yunadie',
          message: 'අපේ විශේෂ දේවල් බලමු! Secret Vault එකෙන් files ආරක්ෂා කරන්නත්, Face සහ Location Albums වලින් photos පිළිවෙළට සකස් කරන්නත් පුළුවන්.',
          choices: const <_CompanionChoice>[
            _CompanionChoice('Secret Vault', 'vault'),
            _CompanionChoice('Face Albums', 'faces'),
            _CompanionChoice('Location Albums', 'locations'),
            _CompanionChoice('More tools', 'tools'),
            _CompanionChoice('Back', 'back'),
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
          title: const Text(
            'Talk with Hasaru & Yunadie',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
          ),
          subtitle: const Text('Your Aqua companions are here', style: TextStyle(color: Colors.white60, fontSize: 11)),
          trailing: IconButton(
            tooltip: 'Show companions',
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
              const Expanded(
                child: Text(
                  'HASARU & YUNADIE',
                  style: TextStyle(color: Colors.white, fontSize: 12, letterSpacing: 1.1, fontWeight: FontWeight.w800),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.white.withOpacity(.08), borderRadius: BorderRadius.circular(20)),
                child: const Text('Aqua companions', style: TextStyle(color: Colors.white70, fontSize: 10)),
              ),
              IconButton(
                tooltip: 'Minimize companions',
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
              painter: _AnimeDuoPainter(speaker: _speaker, accent: widget.accent),
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
                        child: const Text('Show all', style: TextStyle(fontSize: 10)),
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
  _AnimeDuoPainter({required this.speaker, required this.accent});

  final String speaker;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final scale = math.min(size.width / 300, size.height / 135);
    canvas.save();
    canvas.translate((size.width - 300 * scale) / 2, (size.height - 135 * scale) / 2);
    canvas.scale(scale);
    _drawCharacter(canvas, const Offset(82, 41), girl: false, talking: speaker == 'Hasaru');
    _drawCharacter(canvas, const Offset(220, 41), girl: true, talking: speaker == 'Yunadie');
    canvas.restore();
  }

  void _drawCharacter(Canvas canvas, Offset c, {required bool girl, required bool talking}) {
    final skin = const Color(0xFFFFDCCB);
    final hair = girl ? const Color(0xFF241338) : const Color(0xFF111827);
    final eye = girl ? const Color(0xFF9A5BFF) : const Color(0xFF238CFF);
    final outfit = girl ? const Color(0xFFEAF5FF) : const Color(0xFF082B59);
    final trim = girl ? const Color(0xFF5D8FEA) : const Color(0xFF19BDEB);

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
      canvas.drawPath(longHair, Paint()..color = hair);
    } else {
      final backHair = Path()
        ..moveTo(c.dx - 30, 42)
        ..quadraticBezierTo(c.dx - 42, 8, c.dx - 10, 8)
        ..quadraticBezierTo(c.dx + 24, -5, c.dx + 32, 22)
        ..quadraticBezierTo(c.dx + 48, 35, c.dx + 33, 67)
        ..lineTo(c.dx - 28, 68)
        ..close();
      canvas.drawPath(backHair, Paint()..color = hair);
    }

    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(c.dx, 74), width: 18, height: 27), const Radius.circular(7)),
      Paint()..color = skin,
    );
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - 25, 46), width: 13, height: 17), Paint()..color = skin);
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + 25, 46), width: 13, height: 17), Paint()..color = skin);
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx, 45), width: 47, height: 59), Paint()..color = skin);

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
        Paint()..color = eye,
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
    if (talking) {
      canvas.drawOval(Rect.fromCenter(center: Offset(c.dx, 67), width: 8, height: 9), mouth);
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
    canvas.drawPath(fringe, Paint()..color = hair);
    canvas.drawPath(fringe, Paint()
      ..color = trim.withOpacity(.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0);

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
    }
  }

  @override
  bool shouldRepaint(covariant _AnimeDuoPainter oldDelegate) =>
      oldDelegate.speaker != speaker || oldDelegate.accent != accent;
}
