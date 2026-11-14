import 'package:flutter/material.dart';

class AquaAiAssistantPage extends StatefulWidget {
  const AquaAiAssistantPage({super.key, required this.accent});

  final Color accent;

  @override
  State<AquaAiAssistantPage> createState() => _AquaAiAssistantPageState();
}

class _AssistantMessage {
  const _AssistantMessage(this.text, {required this.fromUser});

  final String text;
  final bool fromUser;
}

class _AquaAiAssistantPageState extends State<AquaAiAssistantPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_AssistantMessage> _messages = <_AssistantMessage>[
    const _AssistantMessage(
      'Hello! I am Aqua Assistant. I can guide you through storage access, files, media, Face Albums, Location Albums, the Secret Vault and the Recycle Bin.',
      fromUser: false,
    ),
  ];

  static const List<String> _suggestions = <String>[
    'How do I allow storage access?',
    'How does the Secret Vault work?',
    'How can I restore deleted files?',
    'How do Face and Location Albums work?',
  ];

  String _createReply(String raw) {
    final value = raw.toLowerCase();
    if (value.contains('permission') || value.contains('storage access') ||
        value.contains('අවසර') || value.contains('ගබඩා')) {
      return 'To browse your phone folders, open Home and tap Allow access. Android opens the All files access settings page. Enable access for Bubble File Manager, return to the app, then tap Check permission or Allow access again.';
    }
    if (value.contains('vault') || value.contains('pin') || value.contains('රහස්')) {
      return 'Open Home → Bubble special features → Secret Vault. Create a PIN and a recovery question the first time. Keep the PIN and recovery answer private. You can also use the Secret Vault gesture on the Home screen.';
    }
    if (value.contains('recycle') || value.contains('restore') ||
        value.contains('deleted') || value.contains('මකා') || value.contains('restore')) {
      return 'Deleted items first stay in the Recycle Bin for up to 30 days. After you choose permanent deletion there, the app provides a separate 2-hour recovery stage before final removal. Restore an item before its stage expires.';
    }
    if (value.contains('face') || value.contains('මුහුණ')) {
      return 'Open Home → Bubble special features → Face Albums. Face grouping is processed on the device. Review suggested matches yourself; it may not identify every face correctly.';
    }
    if (value.contains('location') || value.contains('gps') || value.contains('ස්ථාන')) {
      return 'Open Home → Bubble special features → Location Albums. Only photos containing GPS metadata can be grouped. Android may ask for media-location access before coordinates can be read.';
    }
    if (value.contains('video') || value.contains('audio') ||
        value.contains('music') || value.contains('player') || value.contains('play')) {
      return 'Open a supported audio or video file from the Files tab. The built-in player is tried first. Some formats depend on the media decoders available on your Android device.';
    }
    if (value.contains('duplicate') || value.contains('duplicates')) {
      return 'Use the file tools to scan for duplicate files, then review each result before deleting anything. Similar names alone do not prove that two files are identical.';
    }
    if (value.contains('bubble') || value.contains('gravity') || value.contains('tilt')) {
      return 'Open Settings to change the bubble motion and Gravity Bubble options. When gravity is enabled, the motion sensor controls the drift; when disabled, the bubbles use their ambient motion.';
    }
    if (value.contains('clean') || value.contains('space') || value.contains('large files')) {
      return 'Open Home → Bubble special features → Smart Cleanup suggestions. It lists large or older files for your review and does not delete files automatically.';
    }
    return 'I can currently give offline help for storage permissions, Secret Vault, Recycle Bin, Face Albums, Location Albums, media playback, duplicate files, bubble settings and Smart Cleanup. Try one of those topics.';
  }

  void _send([String? suggested]) {
    final text = (suggested ?? _controller.text).trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_AssistantMessage(text, fromUser: true));
      _messages.add(_AssistantMessage(_createReply(text), fromUser: false));
    });
    _controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF071E2A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: widget.accent,
          brightness: Brightness.dark,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 4,
          title: Row(children: <Widget>[
            CircleAvatar(
              backgroundColor: widget.accent.withOpacity(.18),
              child: Icon(Icons.auto_awesome_rounded, color: widget.accent),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Aqua Assistant', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                  Text('Offline guidance', style: TextStyle(fontSize: 11, color: Colors.white60)),
                ],
              ),
            ),
          ]),
          backgroundColor: const Color(0xFF0B2937),
        ),
        body: Column(children: <Widget>[
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(14, 12, 14, 6),
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: widget.accent.withOpacity(.09),
              border: Border.all(color: widget.accent.withOpacity(.24)),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text(
              'This build uses an on-device help assistant. Live generative AI is not connected, so no API key or internet service is required.',
              style: TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: message.fromUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.sizeOf(context).width * .84,
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                    decoration: BoxDecoration(
                      color: message.fromUser
                          ? widget.accent.withOpacity(.22)
                          : const Color(0xFF153746),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(17),
                        topRight: const Radius.circular(17),
                        bottomLeft: Radius.circular(message.fromUser ? 17 : 5),
                        bottomRight: Radius.circular(message.fromUser ? 5 : 17),
                      ),
                      border: Border.all(
                        color: message.fromUser
                            ? widget.accent.withOpacity(.30)
                            : Colors.white.withOpacity(.07),
                      ),
                    ),
                    child: Text(message.text, style: const TextStyle(fontSize: 13, height: 1.4)),
                  ),
                );
              },
            ),
          ),
          if (_messages.length == 1)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Wrap(
                spacing: 7,
                runSpacing: 7,
                children: _suggestions.map((suggestion) => ActionChip(
                  label: Text(suggestion, style: const TextStyle(fontSize: 11)),
                  onPressed: () => _send(suggestion),
                  backgroundColor: const Color(0xFF12313F),
                  side: BorderSide(color: widget.accent.withOpacity(.25)),
                )).toList(),
              ),
            ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 7, 12, 12),
              child: Row(children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 4,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _send(),
                    decoration: InputDecoration(
                      hintText: 'Ask about your files…',
                      filled: true,
                      fillColor: const Color(0xFF153746),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  tooltip: 'Send message',
                  onPressed: _send,
                  icon: const Icon(Icons.send_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: widget.accent,
                    foregroundColor: const Color(0xFF06212B),
                  ),
                ),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}
