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

enum _HelpTopic {
  storage, vault, recycle, faces, locations, media, duplicates, bubbles, cleanup, files, privacy, unknown
}

class _AquaAiAssistantPageState extends State<AquaAiAssistantPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool get _si => AppLanguage.isSinhala;

  List<String> get _suggestions => _si
      ? <String>['ගබඩා අවසර ලබා දෙන්නේ කෙසේද?', 'රහස් සුරක්ෂිතාගාරය භාවිත කරන්නේ කෙසේද?', 'මුහුණු ඇල්බම හිස් නම් මොකද කරන්නේ?', 'ස්ථාන ඇල්බම වැඩ නොකරන්නේ ඇයි?', 'වීඩියෝවක් App එකෙන්ම විවෘත කරන්නේ කොහොමද?']
      : <String>['How do I allow storage access?', 'How does the Secret Vault work?', 'Why is Face Albums empty?', 'Why are Location Albums empty?', 'How do I play a video inside the app?'];

  late final List<_AssistantMessage> _messages = <_AssistantMessage>[
    _AssistantMessage(
      _si
          ? 'ආයුබෝවන්! මම Aqua සහායකයා. Bubble File Manager භාවිත කරන ආකාරය පියවරෙන් පියවර පැහැදිලි කරන්නම්. ප්‍රශ්නයක් ලියන්න හෝ පහත මාතෘකාවක් තෝරන්න.\n\nසටහන: මෙය දැනට අන්තර්ජාල AI සේවාවකට සම්බන්ධ නැති උපකාරක සහායකයෙකි.'
          : 'Hello! I’m Aqua Assistant. I can explain Bubble File Manager features step by step. Type a question or choose a topic below.\n\nNote: this is an offline help assistant, not a live generative AI service.',
      fromUser: false,
    ),
  ];

  _HelpTopic _classify(String raw) {
    final v = raw.toLowerCase();
    bool has(List<String> words) => words.any(v.contains);
    if (has(['permission', 'storage access', 'allow access', 'අවසර', 'ගබඩා අවසර'])) return _HelpTopic.storage;
    if (has(['vault', 'pin', 'password', 'රහස්', 'මුරපද', 'සුරක්ෂිතාගාර'])) return _HelpTopic.vault;
    if (has(['recycle', 'restore', 'deleted', 'recover', 'මකා', 'ප්‍රතිචක්‍රීකරණ', 'නැවත ලබා'])) return _HelpTopic.recycle;
    if (has(['face', 'faces', 'මුහුණ', 'මුහුණු'])) return _HelpTopic.faces;
    if (has(['location', 'gps', 'place', 'map', 'ස්ථාන', 'ජීපීඑස්', 'සිතියම'])) return _HelpTopic.locations;
    if (has(['video', 'audio', 'music', 'player', 'play', 'වීඩියෝ', 'ශ්‍රව්‍ය', 'වාදක'])) return _HelpTopic.media;
    if (has(['duplicate', 'identical', 'අනුපිටපත්', 'එකම ගොනු'])) return _HelpTopic.duplicates;
    if (has(['bubble', 'gravity', 'tilt', 'sensor', 'බුබුළු', 'ගුරුත්ව'])) return _HelpTopic.bubbles;
    if (has(['clean', 'space', 'storage full', 'large files', 'පිරිසිදු', 'ඉඩකඩ'])) return _HelpTopic.cleanup;
    if (has(['file', 'folder', 'rename', 'copy', 'move', 'search', 'ගොනු', 'ෆෝල්ඩර්', 'සොයන්න'])) return _HelpTopic.files;
    if (has(['privacy', 'private', 'secure', 'photo upload', 'පෞද්ගලික', 'ආරක්ෂාව'])) return _HelpTopic.privacy;
    return _HelpTopic.unknown;
  }

  String _createReply(String raw) {
    switch (_classify(raw)) {
      case _HelpTopic.storage:
        return _si
            ? 'ගබඩා අවසර ලබාදීම\n\n1. Home තිරයට යන්න.\n2. “ප්‍රවේශය ලබා දෙන්න” තෝරන්න.\n3. Android Settings විවෘත වූ විට “Allow access to manage all files” සක්‍රිය කරන්න.\n4. නැවත Bubble File Manager වෙත පැමිණ “අවසරය පරීක්ෂා කරන්න” තෝරන්න.\n\nතවමත් ගොනු නොපෙනේ නම් App එක වසා නැවත විවෘත කර Refresh කරන්න. Android අනුව Settings නාම ටිකක් වෙනස් විය හැක.'
            : 'Allow storage access\n\n1. Return to the app Home screen.\n2. Tap “Allow access”.\n3. Android Settings opens. Enable “Allow access to manage all files” for Bubble File Manager.\n4. Return to the app and tap “Check permission”.\n\nIf files still do not appear, reopen the app and use Refresh. The exact Android setting label can vary by device.';
      case _HelpTopic.vault:
        return _si
            ? 'Secret Vault භාවිතය\n\n1. Home → Bubble special features → Secret Vault විවෘත කරන්න.\n2. පළමු වතාවේදී අවම වශයෙන් අක්ෂර 6ක මුරපදයක් සාදා තහවුරු කරන්න.\n3. ඔබට පමණක් මතක, අන් අයට අනුමාන කිරීමට අපහසු recovery ප්‍රශ්නයක් සහ පිළිතුරක් සකසන්න.\n4. “Encrypt a file into Vault” තෝරා ගොනුවක් එක් කරන්න.\n\nමතක තබාගන්න: මුරපදය සහ recovery පිළිතුර ආරක්ෂිතව තබාගන්න. Vault එකට ගොනුව එක් වූ බව තහවුරු වන තුරු මුල් ගොනුව මකා නොදමන්න.'
            : 'Using Secret Vault\n\n1. Open Home → Bubble special features → Secret Vault.\n2. On first use, create and confirm a password of at least 6 characters.\n3. Set a recovery question and an answer only you can remember.\n4. Choose “Encrypt a file into Vault” and select a file.\n\nKeep your password and recovery answer private. Do not delete the original until you have confirmed the file is safely present in the Vault.';
      case _HelpTopic.recycle:
        return _si
            ? 'මකා දැමූ ගොනු නැවත ලබාගැනීම\n\n1. Home → Recycle Bin විවෘත කරන්න.\n2. අවශ්‍ය ගොනුව තෝරා “Restore” ඔබන්න.\n3. සාමාන්‍යයෙන් ගොනු දින 30ක් Recycle Bin තුළ පවතී.\n4. එතැනින් “Delete again” තෝරාගත් පසු වෙනම පැය 2ක තාවකාලික ප්‍රතිසාධන කාලයක් ආරම්භ වේ.\n\nඅවසාන කාලය අවසන් වූ පසු ගොනුව නැවත ලබාගත නොහැකි විය හැක. වැදගත් ගොනු මකා දැමීමට පෙර දෙවරක් පරීක්ෂා කරන්න.'
            : 'Restore deleted files\n\n1. Open Home → Recycle Bin.\n2. Find the item and tap “Restore”.\n3. Items normally remain in the Recycle Bin for 30 days.\n4. Choosing “Delete again” starts a separate 2-hour temporary recovery stage.\n\nAfter that final stage expires, recovery may no longer be possible. Double-check important files before deleting them.';
      case _HelpTopic.faces:
        return _si
            ? 'Face Albums හිස් නම් පරීක්ෂා කරන්න\n\n1. Face Albums විවෘත කර “Scan photos” තෝරන්න.\n2. Android ඉල්ලන ඡායාරූප/ගොනු අවසර ලබාදෙන්න.\n3. App එකට ප්‍රවේශ විය හැකි ෆෝල්ඩර්වල සහාය දක්වන ඡායාරූප තිබිය යුතුය.\n4. හොඳ ආලෝකයෙන් ගත්, මුහුණ පැහැදිලිව පෙනෙන ඡායාරූප වඩා හොඳින් ගැළපිය හැක.\n\nමෙය සමාන මුහුණු තාවකාලික කණ්ඩායම්වලට එකතු කරන විශේෂාංගයක් පමණයි; පුද්ගලයාගේ නම හෝ අනන්‍යතාව තහවුරු නොකරයි. වැරදි කණ්ඩායම් තිබිය හැකි නිසා ප්‍රතිඵල පරීක්ෂා කරන්න.'
            : 'If Face Albums is empty\n\n1. Open Face Albums and tap “Scan photos”.\n2. Grant the photo/file access Android requests.\n3. The app can only scan supported images in folders it can access.\n4. Clear, well-lit photos with visible faces are easier to match.\n\nThis feature groups visually similar faces; it does not identify people by name or prove identity. Matches can be wrong, so review the groups.';
      case _HelpTopic.locations:
        return _si
            ? 'Location Albums හිස් නම්\n\n1. කැමරාවේ Location tagging/GPS සක්‍රිය කර ගත් ඡායාරූප භාවිත කරන්න.\n2. Location Albums විවෘත කර “Scan phone photos” තෝරන්න.\n3. අවශ්‍ය media/location metadata අවසර ලබාදෙන්න.\n4. Scan එක අවසන් වන තුරු රැඳී සිටින්න.\n\nවැදගත්: ඡායාරූපයේ EXIF metadata තුළ GPS ඛණ්ඩාංක නැත්නම් App එකට එහි සැබෑ ස්ථානය සොයාගත නොහැක. Screenshot, messaging apps හරහා ලැබුණු හෝ social media වෙතින් download කළ ඡායාරූපවල GPS දත්ත ඉවත් වී තිබිය හැක.'
            : 'If Location Albums is empty\n\n1. Use photos taken with camera location tagging/GPS enabled.\n2. Open Location Albums and tap “Scan phone photos”.\n3. Grant any media or location-metadata permission Android requests.\n4. Wait for the scan to finish.\n\nImportant: without GPS coordinates embedded in a photo’s EXIF metadata, the app cannot know its real capture location. Screenshots and images shared through some messaging or social apps often have GPS metadata removed.';
      case _HelpTopic.media:
        return _si
            ? 'App එක තුළම මාධ්‍ය විවෘත කිරීම\n\n1. Files තිරයට ගොස් Audio හෝ Videos ප්‍රවර්ගය තෝරන්න.\n2. විවෘත කිරීමට අවශ්‍ය ගොනුව තට්ටු කරන්න.\n3. Player එක නොපෙනේ නම් ගොනු වර්ගය/codec එක උපාංගය සහාය නොදක්වන එකක් විය හැක.\n4. වෙනත් සාමාන්‍ය MP4 හෝ MP3 ගොනුවක් පරීක්ෂා කර බලන්න.\n\nසෑම codec එකක්ම සෑම Android දුරකථනයකම සහාය නොදක්වයි.'
            : 'Open media inside the app\n\n1. Go to Files and choose Audio or Videos.\n2. Tap the file you want to open.\n3. If the in-app player does not appear, the file format or codec may not be supported by your device.\n4. Test with another common MP4 or MP3 file.\n\nNot every Android device supports every media codec.';
      case _HelpTopic.duplicates:
        return _si
            ? 'අනුපිටපත් ගොනු පරීක්ෂා කිරීම\n\n1. Advanced Tools හෝ file tools තුළ “Find identical files” තෝරන්න.\n2. Scan ප්‍රතිඵල ලැබෙන තුරු රැඳී සිටින්න.\n3. ගොනු නාමය, ප්‍රමාණය සහ ස්ථානය පරීක්ෂා කරන්න.\n4. ඔබට අවශ්‍ය නැති බව තහවුරු කළ පසු පමණක් මකා දමන්න.\n\nසමාන නමක් තිබීම පමණක් අනුපිටපතක් බවට සාක්ෂියක් නොවේ.'
            : 'Check for duplicate files\n\n1. Open Advanced Tools or the file tools and choose “Find identical files”.\n2. Wait for the scan to finish.\n3. Review each file’s name, size and location.\n4. Delete only after confirming you do not need that copy.\n\nMatching names alone do not prove that files are duplicates.';
      case _HelpTopic.bubbles:
        return _si
            ? 'Bubble සහ Gravity සැකසුම්\n\n1. Settings විවෘත කරන්න.\n2. “Bubbles” සක්‍රිය කර පසුබිම් බුබුළු පෙන්වන්න.\n3. “Gravity bubbles” සක්‍රිය කළ විට දුරකථනයේ tilt sensor දත්ත භාවිත කරයි.\n4. එය අක්‍රිය කළ විට ස්වභාවික පසුබිම් චලනය භාවිත කළ යුතුය.\n\nSensor එකක් නොමැති හෝ Android විසින් sensor දත්ත සීමා කරන උපාංගයක චලනය වෙනස් විය හැක.'
            : 'Bubble and Gravity settings\n\n1. Open Settings.\n2. Enable “Bubbles” to show the animated background.\n3. Enable “Gravity bubbles” to use phone tilt-sensor data.\n4. When gravity is off, the background should use ambient motion instead.\n\nMotion can vary on devices with missing or restricted sensor data.';
      case _HelpTopic.cleanup:
        return _si
            ? 'Smart Cleanup භාවිතය\n\n1. Home → Bubble special features → Smart Cleanup suggestions විවෘත කරන්න.\n2. විශාල හෝ පැරණි ගොනු ලැයිස්තුව පරීක්ෂා කරන්න.\n3. අවශ්‍ය නැති ගොනු පමණක් ඔබම තෝරන්න.\n\nSmart Cleanup යෝජනා පෙන්වීමට පමණි; ඔබගේ අවසරයකින් තොරව ගොනු ස්වයංක්‍රීයව මකා දැමිය යුතු නැත.'
            : 'Use Smart Cleanup\n\n1. Open Home → Bubble special features → Smart Cleanup suggestions.\n2. Review the list of large or older files.\n3. Select only files you are sure you no longer need.\n\nSmart Cleanup is a review tool; it should not automatically delete files without your approval.';
      case _HelpTopic.files:
        return _si
            ? 'ගොනු කළමනාකරණය\n\nFiles තිරයෙන් ෆෝල්ඩර් විවෘත කර ගොනු පිරික්සන්න. Search භාවිතයෙන් නම අනුව සොයන්න. ගොනුවක් දිගට තට්ටු කළ විට Copy, Cut, Move, Rename, Share සහ Properties වැනි ක්‍රියා තිබේ නම් ඒවා තෝරාගත හැක.\n\nගොනුවක් වෙනස් කිරීමට හෝ මකා දැමීමට පෙර නිවැරදි ගොනුව තෝරා ඇති බව පරීක්ෂා කරන්න.'
            : 'Manage files\n\nUse the Files screen to open folders and browse items. Use Search to find a name. Long-press a file to see available actions such as Copy, Cut, Move, Rename, Share and Properties.\n\nBefore changing or deleting anything, verify that you selected the correct file.';
      case _HelpTopic.privacy:
        return _si
            ? 'පෞද්ගලිකත්වය සහ දත්ත\n\nFace Albums සහ GPS metadata scan කිරීම උපාංගය තුළම සිදු කිරීමට සැලසුම් කර ඇත. Location map එකක් විවෘත කළ විට සිතියම් tiles අන්තර්ජාලයෙන් ලබාගත හැක. ස්ථාන නාම සෙවීම සක්‍රිය කළහොත් වටකුරු GPS ඛණ්ඩාංක බාහිර map සේවාවකට යැවිය හැක.\n\nරහස් ගොනු සඳහා Secret Vault භාවිත කරන්න; මුරපද කිසිවෙකු සමඟ බෙදා නොගන්න.'
            : 'Privacy and data\n\nFace grouping and GPS metadata scanning are designed to run on the device. Opening a location map may load map tiles from the internet. If optional place-name lookup is enabled, rounded GPS coordinates may be sent to an external map service.\n\nUse Secret Vault for protected files and never share your password.';
      case _HelpTopic.unknown:
        return _si
            ? 'ඔබගේ ප්‍රශ්නය හරියටම තේරුම් ගැනීමට තව ටිකක් විස්තර අවශ්‍යයි.\n\nමට දැනට පැහැදිලි කළ හැකි මාතෘකා: ගබඩා අවසර, ගොනු/ෆෝල්ඩර්, Secret Vault, Recycle Bin, Face Albums, Location Albums, Audio/Video Player, Duplicate scan, Gravity Bubbles සහ Smart Cleanup.\n\nඋදාහරණයක්: “Location Albums හිස්ව පෙන්වන්නේ ඇයි?” හෝ “වීඩියෝවක් විවෘත කළ විට player එකක් එන්නේ නැත්තේ ඇයි?”\n\nසටහන: මෙය තවම ChatGPT වැනි සජීවී AI එකක් නොවේ; එබැවින් සහාය නොදක්වන ප්‍රශ්නවලට අනුමාන පිළිතුරු නොදෙමි.'
            : 'I need a little more detail to understand that question.\n\nI can currently explain storage permissions, files and folders, Secret Vault, Recycle Bin, Face Albums, Location Albums, audio/video playback, duplicate scans, Gravity Bubbles and Smart Cleanup.\n\nTry: “Why are my Location Albums empty?” or “Why does no player open when I tap a video?”\n\nNote: this is not yet a live ChatGPT-style AI model, so I will not invent answers to unsupported questions.';
    }
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
          duration: const Duration(milliseconds: 260),
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
                Text(_si ? 'පියවරෙන් පියවර උපදෙස්' : 'Step-by-step app help',
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
                  ? 'මෙය යෙදුමේ විශේෂාංග සඳහා විස්තරාත්මක offline උපකාරක සහායකයෙකි. සජීවී ChatGPT AI සම්බන්ධ කර නැත.'
                  : 'Detailed offline help for app features. Live ChatGPT-style AI is not connected.',
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
                  constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * .88),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                  child: SelectableText(message.text, style: const TextStyle(fontSize: 13, height: 1.48)),
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
                    hintText: _si ? 'ඔබගේ ප්‍රශ්නය ලියන්න…' : 'Write your question…',
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
