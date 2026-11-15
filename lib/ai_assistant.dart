import 'package:flutter/material.dart';
import 'app_language.dart';

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

  bool get _si => AppLanguage.isSinhala;
  List<String> get _suggestions => _si
      ? <String>[
          'ගබඩා අවසර ලබා දෙන්නේ කෙසේද?',
          'රහස් සුරක්ෂිතාගාරය භාවිත කරන්නේ කෙසේද?',
          'මකා දැමූ ගොනු නැවත ලබාගන්නේ කෙසේද?',
          'මුහුණු සහ ස්ථාන ඇල්බම ක්‍රියා කරන්නේ කෙසේද?',
        ]
      : <String>[
          'How do I allow storage access?',
          'How does the Secret Vault work?',
          'How can I restore deleted files?',
          'How do Face and Location Albums work?',
        ];

  late final List<_AssistantMessage> _messages = <_AssistantMessage>[
    _AssistantMessage(
      _si
          ? 'ආයුබෝවන්! මම Aqua සහායකයා. ගබඩා අවසර, ගොනු, මාධ්‍ය වාදකය, මුහුණු ඇල්බම, ස්ථාන ඇල්බම, රහස් සුරක්ෂිතාගාරය සහ ප්‍රතිචක්‍රීකරණ බඳුන ගැන මඟ පෙන්වන්නම්.'
          : 'Hello! I am Aqua Assistant. I can guide you through storage access, files, media, Face Albums, Location Albums, the Secret Vault and the Recycle Bin.',
      fromUser: false,
    ),
  ];

  String _createReply(String raw) {
    final value = raw.toLowerCase();
    if (value.contains('permission') || value.contains('storage access') ||
        value.contains('අවසර') || value.contains('ගබඩා')) {
      return _si
          ? 'දුරකථනයේ ෆෝල්ඩර පිරික්සීමට Home තිරයේ “ප්‍රවේශය ලබා දෙන්න” තෝරන්න. Android හි “All files access” සැකසුම් විවෘත වූ විට Bubble File Manager සඳහා අවසරය සක්‍රිය කර නැවත යෙදුමට පැමිණ “අවසරය පරීක්ෂා කරන්න” තෝරන්න.'
          : 'To browse your phone folders, open Home and tap Allow access. Android opens the All files access settings page. Enable access for Bubble File Manager, return to the app, then tap Check permission or Allow access again.';
    }
    if (value.contains('vault') || value.contains('pin') ||
        value.contains('password') || value.contains('රහස්') ||
        value.contains('මුරපද')) {
      return _si
          ? 'Home → බබල් විශේෂාංග → රහස් සුරක්ෂිතාගාරය විවෘත කරන්න. පළමු වතාවේදී අලුත් මුරපදයක් සහ ඔබ තෝරාගන්නා ප්‍රතිසාධන ප්‍රශ්නයක්/පිළිතුරක් සකසන්න. සෑම වතාවකම Vault එක විවෘත කිරීමට මුරපදය අවශ්‍යයි. අමතක වුවහොත් “මුරපදය අමතකද?” තෝරා ප්‍රශ්නයට පිළිතුරු දෙන්න.'
          : 'Open Home → Bubble special features → Secret Vault. Create a password and your own recovery question and answer on first use. The password is required every time you open the Vault. If forgotten, choose “Forgot password?” and answer your recovery question.';
    }
    if (value.contains('recycle') || value.contains('restore') ||
        value.contains('deleted') || value.contains('මකා') ||
        value.contains('ප්‍රතිචක්‍රීකරණ')) {
      return _si
          ? 'මකා දැමූ අයිතම මුලින් දින 30ක් ප්‍රතිචක්‍රීකරණ බඳුනේ පවතී. එතැනින් “නැවත මකා දමන්න” තෝරාගත් පසු අවසාන මකාදැමීමට පෙර වෙනම පැය 2ක ප්‍රතිසාධන කාලයක් ලැබේ. එම කාලය අවසන් වීමට පෙර ප්‍රතිස්ථාපනය කරන්න.'
          : 'Deleted items first stay in the Recycle Bin for up to 30 days. After you choose Delete again there, the app provides a separate 2-hour recovery stage before final removal. Restore an item before its stage expires.';
    }
    if (value.contains('face') || value.contains('මුහුණ')) {
      return _si
          ? 'Home → ප්‍රවර්ග → මුහුණු ඇල්බම විවෘත කරන්න. මුහුණු ගැළපීම උපාංගය තුළම සිදු කරයි. ස්වයංක්‍රීය ගැළපීම් වැරදි විය හැකි නිසා සෑම කණ්ඩායමක්ම ඔබම පරීක්ෂා කරන්න.'
          : 'Open Home → Categories → Face Albums. Face grouping is processed on the device. Review suggested matches yourself because incorrect groupings are possible.';
    }
    if (value.contains('location') || value.contains('gps') || value.contains('ස්ථාන')) {
      return _si
          ? 'Home → ප්‍රවර්ග → ස්ථාන ඇල්බම විවෘත කරන්න. GPS metadata ඇතුළත් ඡායාරූප පමණක් ස්ථාන අනුව කාණ්ඩ කළ හැක. Android විසින් මාධ්‍ය ස්ථාන අවසරය ඉල්ලිය හැක.'
          : 'Open Home → Categories → Location Albums. Only photos containing GPS metadata can be grouped. Android may ask for media-location access before coordinates can be read.';
    }
    if (value.contains('video') || value.contains('audio') || value.contains('music') ||
        value.contains('player') || value.contains('play') ||
        value.contains('වීඩියෝ') || value.contains('ශ්‍රව්‍ය') || value.contains('වාදක')) {
      return _si
          ? 'Files තිරයෙන් සහාය දක්වන ශ්‍රව්‍ය හෝ වීඩියෝ ගොනුවක් තෝරන්න. යෙදුමේම මාධ්‍ය වාදකය භාවිත කරයි. සමහර ගොනු වර්ග Android උපාංගයේ decoder සහාය මත රඳා පවතී.'
          : 'Open a supported audio or video file from the Files tab. The built-in player is tried first. Some formats depend on the media decoders available on your Android device.';
    }
    if (value.contains('duplicate') || value.contains('duplicates') || value.contains('අනුපිටපත්')) {
      return _si
          ? 'ගොනු මෙවලම්වලින් අනුපිටපත් සොයාගැනීමේ scan එක ක්‍රියාත්මක කරන්න. මකා දැමීමට පෙර සෑම ප්‍රතිඵලයක්ම පරීක්ෂා කරන්න. ගොනු නාම සමාන වීම පමණක් ඒවා එකම ගොනුව බව තහවුරු නොකරයි.'
          : 'Use the file tools to scan for duplicate files, then review each result before deleting anything. Similar names alone do not prove that two files are identical.';
    }
    if (value.contains('bubble') || value.contains('gravity') || value.contains('tilt') ||
        value.contains('බුබුළු') || value.contains('ගුරුත්ව')) {
      return _si
          ? 'සැකසුම් තුළ Gravity Bubbles විකල්පය සක්‍රිය හෝ අක්‍රිය කරන්න. එය සක්‍රිය විට දුරකථනයේ ඇලවීම අනුව බුබුළු චලනය වේ. අක්‍රිය විට ස්වභාවික අහඹු චලනය භාවිත කරයි.'
          : 'Open Settings to change the bubble motion and Gravity Bubbles option. When gravity is enabled, the motion sensor controls the drift; when disabled, the bubbles use ambient motion.';
    }
    if (value.contains('clean') || value.contains('space') ||
        value.contains('large files') || value.contains('පිරිසිදු')) {
      return _si
          ? 'Home → බබල් විශේෂාංග → Smart Cleanup යෝජනා විවෘත කරන්න. එය විශාල හෝ පැරණි ගොනු පරීක්ෂා කිරීමට පෙන්වයි. ඔබගේ අවසරයකින් තොරව ගොනු ස්වයංක්‍රීයව මකා නොදමයි.'
          : 'Open Home → Bubble special features → Smart Cleanup suggestions. It lists large or older files for your review and does not delete files automatically.';
    }
    return _si
        ? 'දැනට මට ගබඩා අවසර, රහස් සුරක්ෂිතාගාරය, ප්‍රතිචක්‍රීකරණ බඳුන, මුහුණු ඇල්බම, ස්ථාන ඇල්බම, මාධ්‍ය වාදකය, අනුපිටපත් ගොනු, බුබුළු සැකසුම් සහ Smart Cleanup ගැන උපදෙස් ලබාදිය හැක. ඒ මාතෘකා වලින් එකක් ගැන විමසන්න.'
        : 'I can currently give offline help for storage permissions, Secret Vault, Recycle Bin, Face Albums, Location Albums, media playback, duplicate files, bubble settings and Smart Cleanup. Try one of those topics.';
  }

  void _send([String? suggested]) {
    final messageText = (suggested ?? _controller.text).trim();
    if (messageText.isEmpty) return;
    setState(() {
      _messages.add(_AssistantMessage(messageText, fromUser: true));
      _messages.add(_AssistantMessage(_createReply(messageText), fromUser: false));
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
        colorScheme: ColorScheme.fromSeed(seedColor: widget.accent, brightness: Brightness.dark),
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
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_si ? 'Aqua සහායකයා' : 'Aqua Assistant',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                Text(_si ? 'අන්තර්ජාලය නොමැතිව උපදෙස්' : 'Offline guidance',
                  style: const TextStyle(fontSize: 11, color: Colors.white60)),
              ],
            )),
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
            child: Text(
              _si
                  ? 'මෙම සංස්කරණයේ උපාංගය තුළම ක්‍රියාකරන උපදෙස් සහායකයෙක් ඇත. සජීවී Generative AI සම්බන්ධ කර නැත.'
                  : 'This build uses an on-device help assistant. Live generative AI is not connected, so no API key or internet service is required.',
              style: const TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ),
          Expanded(child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              return Align(
                alignment: message.fromUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * .84),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                  decoration: BoxDecoration(
                    color: message.fromUser ? widget.accent.withOpacity(.22) : const Color(0xFF153746),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(17),
                      topRight: const Radius.circular(17),
                      bottomLeft: Radius.circular(message.fromUser ? 17 : 5),
                      bottomRight: Radius.circular(message.fromUser ? 5 : 17),
                    ),
                    border: Border.all(
                      color: message.fromUser ? widget.accent.withOpacity(.30) : Colors.white.withOpacity(.07),
                    ),
                  ),
                  child: Text(message.text, style: const TextStyle(fontSize: 13, height: 1.4)),
                ),
              );
            },
          )),
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
                Expanded(child: TextField(
                  controller: _controller,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _send(),
                  decoration: InputDecoration(
                    hintText: _si ? 'ඔබගේ ගොනු ගැන විමසන්න…' : 'Ask about your files…',
                    filled: true,
                    fillColor: const Color(0xFF153746),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                )),
                const SizedBox(width: 8),
                IconButton.filled(
                  tooltip: _si ? 'පණිවිඩය යවන්න' : 'Send message',
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
