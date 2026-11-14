import 'dart:async';

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
          const SizedBox(height: 2),
          SizedBox(
            height: 126,
            width: double.infinity,
            child: Image.asset(
              'assets/hasaru_yunadie.webp',
              fit: BoxFit.contain,
              alignment: Alignment.center,
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(Icons.people_alt_rounded, color: Colors.white70, size: 54),
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
