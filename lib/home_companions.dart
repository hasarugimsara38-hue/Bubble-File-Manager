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
  Timer? _introTimer;
  bool _openingSequence = false;
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
    _introTimer?.cancel();
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
    _introTimer?.cancel();
    _openingSequence = true;
    _playOpeningStep(0, initial: initial);
  }

  void _playOpeningStep(int step, {bool initial = false}) {
    final script = widget.isSinhala
        ? <({String speaker, String message})>[
            (
              speaker: 'Hasaru',
              message: 'හායි! Bubble File Manager වෙත සාදරයෙන් පිළිගනිමු! මම Hasaru. ඔයාගේ ගොනු ආරක්ෂිතව සහ පිළිවෙළට තබාගන්න මම උදව් කරන්නම්.',
            ),
            (
              speaker: 'Yunadie',
              message: 'හායි! මම Yunadie. ඡායාරූප, වීඩියෝ සහ මතකයන් සොයාගෙන ලස්සනට සකස් කරගන්න මම ඔයාට උදව් කරනවා.',
            ),
            (
              speaker: 'Hasaru',
              message: 'Yunadie මගේ හොඳම යාළුවා. අපි දෙන්නා එකම Aqua කණ්ඩායමේ සහකරුවන්. අලුත් දේවල් ගවේෂණය කරන්න අපි හැමදාම සූදානම්!',
            ),
            (
              speaker: 'Yunadie',
              message: 'අද අපේ පළමු Aqua මෙහෙයුම පටන් ගන්නයි යන්නේ! ඔයාගේ ගොනු සොයාගෙන, ඡායාරූප පිළිවෙළට සකස් කරලා, වැදගත් දේවල් ආරක්ෂිතව තබමු. අපි පටන් ගමුද?',
            ),
          ]
        : <({String speaker, String message})>[
            (
              speaker: 'Hasaru',
              message: 'Hello! Welcome to Bubble File Manager! I am Hasaru. I will help you keep your files safe and organised.',
            ),
            (
              speaker: 'Yunadie',
              message: 'Hi! I am Yunadie. I can help you discover and organise your photos, videos and favourite memories.',
            ),
            (
              speaker: 'Hasaru',
              message: 'Yunadie is my best friend. We are teammates in the Aqua crew, always ready to explore and help you.',
            ),
            (
              speaker: 'Yunadie',
              message: 'Our first Aqua mission starts now! Let us find your files, organise your photos and keep important things safe. Shall we begin?',
            ),
          ];

    if (step >= script.length) {
      _openingSequence = false;
      return;
    }

    final line = script[step];
    final isFinalLine = step == script.length - 1;
    _setDialogue(
      speaker: line.speaker,
      message: line.message,
      choices: isFinalLine
          ? <_CompanionChoice>[
              _CompanionChoice(widget.isSinhala ? 'ගොනු පිරික්සන්න' : 'Browse files', 'files_intro'),
              _CompanionChoice(widget.isSinhala ? 'ඡායාරූප සහ වීඩියෝ' : 'Photos & videos', 'media_intro'),
              _CompanionChoice(widget.isSinhala ? 'විශේෂාංග' : 'Special features', 'features_intro'),
              _CompanionChoice(widget.isSinhala ? 'සහායකයාගෙන් අසන්න' : 'Ask Assistant', 'assistant'),
            ]
          : <_CompanionChoice>[],
      initial: initial,
    );

    if (!isFinalLine) {
      // Keep each speaker on screen until the typewriter has finished and
      // the user has had a short moment to read the line.
      final glyphCount = line.message.characters.length;
      _introTimer = Timer(
        Duration(milliseconds: glyphCount * 18 + 1100),
        () {
          if (!mounted || !_openingSequence) return;
          _playOpeningStep(step + 1);
        },
      );
    } else {
      final glyphCount = line.message.characters.length;
      _introTimer = Timer(
        Duration(milliseconds: glyphCount * 18 + 150),
        () {
          if (mounted) setState(() => _openingSequence = false);
        },
      );
    }
  }

  void _skipOpeningSequence() {
    _introTimer?.cancel();
    _openingSequence = false;
    _setDialogue(
      speaker: 'Yunadie',
      message: widget.isSinhala
          ? 'අපේ Aqua ගමනට සාදරයෙන් පිළිගනිමු! අද මොන මෙහෙයුමෙන් පටන් ගමුද?'
          : 'Welcome to our Aqua adventure! Which mission shall we start with?',
      choices: <_CompanionChoice>[
        _CompanionChoice(widget.isSinhala ? 'ගොනු පිරික්සන්න' : 'Browse files', 'files_intro'),
        _CompanionChoice(widget.isSinhala ? 'ඡායාරූප සහ වීඩියෝ' : 'Photos & videos', 'media_intro'),
        _CompanionChoice(widget.isSinhala ? 'විශේෂාංග' : 'Special features', 'features_intro'),
        _CompanionChoice(widget.isSinhala ? 'සහායකයාගෙන් අසන්න' : 'Ask Assistant', 'assistant'),
      ],
    );
  }

  void _greetCharacter(String name) {
    _introTimer?.cancel();
    _openingSequence = false;
    final isHasaru = name == 'Hasaru';
    _setDialogue(
      speaker: name,
      message: widget.isSinhala
          ? (isHasaru
              ? 'මම Hasaru! ගොනු, ෆෝල්ඩර් සහ බාගත කළ දේවල් සොයාගන්න මට කියන්න. අපි එකට පටන් ගමුද?'
              : 'මම Yunadie! ඔයාගේ ඡායාරූප, වීඩියෝ සහ විශේෂ ඇල්බම සකස් කරගන්න මම උදව් කරන්නම්. මොනවා බලමුද?')
          : (isHasaru
              ? 'I am Hasaru! I can help you find files, folders and downloads. What shall we do first?'
              : 'I am Yunadie! I can help you explore photos, videos and smart albums. What would you like to see?'),
      choices: isHasaru
          ? <_CompanionChoice>[
              _CompanionChoice(widget.isSinhala ? 'ගොනු විවෘත කරන්න' : 'Open Files', 'files'),
              _CompanionChoice(widget.isSinhala ? 'විශේෂාංග' : 'Special features', 'features_intro'),
              _CompanionChoice(widget.isSinhala ? 'ආපසු' : 'Back', 'back'),
            ]
          : <_CompanionChoice>[
              _CompanionChoice(widget.isSinhala ? 'ඡායාරූප' : 'Photos', 'images'),
              _CompanionChoice(widget.isSinhala ? 'වීඩියෝ' : 'Videos', 'videos'),
              _CompanionChoice(widget.isSinhala ? 'මුහුණු ඇල්බම' : 'Face Albums', 'faces'),
              _CompanionChoice(widget.isSinhala ? 'ස්ථාන ඇල්බම' : 'Location Albums', 'locations'),
              _CompanionChoice(widget.isSinhala ? 'ආපසු' : 'Back', 'back'),
            ],
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
            height: 190,
            width: double.infinity,
            child: AnimatedBuilder(
              animation: _characterMotion,
              builder: (context, child) {
                final phase = _characterMotion.value * math.pi * 2;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Transform.translate(
                        offset: Offset(0, math.sin(phase) * 2.2),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => _greetCharacter('Hasaru'),
                          child: Semantics(
                          button: true,
                          image: true,
                          label: widget.isSinhala ? 'Hasaru සමඟ කතා කරන්න' : 'Talk to Hasaru',
                          child: Image.asset(
                            'assets/characters/hasaru_1080.png',
                            height: 188,
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                            errorBuilder: (context, error, stackTrace) => const Center(
                              child: Icon(Icons.person_rounded, color: Colors.white54, size: 64),
                            ),
                          ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Transform.translate(
                        offset: Offset(0, math.sin(phase + .85) * 2.2),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => _greetCharacter('Yunadie'),
                          child: Semantics(
                          button: true,
                          image: true,
                          label: widget.isSinhala ? 'Yunadie සමඟ කතා කරන්න' : 'Talk to Yunadie',
                          child: Image.asset(
                            'assets/characters/yunadie_1080.png',
                            height: 188,
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                            errorBuilder: (context, error, stackTrace) => const Center(
                              child: Icon(Icons.person_rounded, color: Colors.white54, size: 64),
                            ),
                          ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
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
                    if (_openingSequence)
                      TextButton(
                        onPressed: _skipOpeningSequence,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          foregroundColor: widget.accent,
                        ),
                        child: Text(
                          widget.isSinhala ? 'මඟහරින්න' : 'Skip intro',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
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
