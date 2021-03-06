import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mongol/mongol.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditorPage extends StatefulWidget {
  @override
  _EditorPageState createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final _textController = TextEditingController();
  StreamSubscription? _autoSaveSubscription;
  var _previousText = '';
  static const _autoSaveKey = 'text';
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _getSavedText();
    _autoSaveSubscription =
        Stream.periodic(Duration(minutes: 1)).listen((event) {
      _autoSave();
    });
    _focusNode = FocusNode(onKey: _handleKeyEvent);
  }

  void _getSavedText() async {
    final prefs = await SharedPreferences.getInstance();
    final text = prefs.getString(_autoSaveKey);
    if (text == null) return;
    _textController.text = text;
    _previousText = text;
  }

  void _autoSave() async {
    final text = _textController.text;
    if (text == _previousText) return;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_autoSaveKey, text);
    _previousText = text;
  }

  dynamic _handleKeyEvent(FocusNode node, RawKeyEvent event) {
    final String? mappedKey;
    if (event.isShiftPressed) {
      mappedKey = shiftKeyMap[event.logicalKey.keyId];
    } else {
      mappedKey = keyMap[event.logicalKey.keyId];
    }
    //print(event.logicalKey.keyId);
    if (mappedKey == null || event.isMetaPressed || event.isControlPressed) {
      return false;
    }

    if (event is RawKeyDownEvent) {
      _insertText(mappedKey);
    }
    return true;
  }

  void _insertText(String inserted) {
    final text = _textController.text;
    final selection = _textController.selection;
    final newText = text.replaceRange(selection.start, selection.end, inserted);
    _textController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
          offset: selection.baseOffset + inserted.length),
    );
  }

  @override
  void dispose() {
    _autoSaveSubscription?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //SizedBox(width: 20),
          MongolText(
            '???????????? ?????????????????? ???????????????',
            style: TextStyle(
              fontSize: 30,
              fontFamily: 'MenksoftQagan',
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: MongolTextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 1000,
                    style: TextStyle(
                      fontFamily: 'MenksoftQagan',
                      fontSize: 20,
                    ),
                    autofocus: true,
                    focusNode: _focusNode,
                  ),
                ),
                SizedBox(height: 20),
                Wrap(
                  children: [
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: _textController.text),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const keyMap = {
  113: '???', // Q
  119: '???', // W
  101: '???', // E
  114: '???', // R
  116: '???', // T
  121: '???', // Y
  117: '???', // U
  105: '???', // I
  111: '???', // O
  112: '???', // P
  91: '???', // [
  93: '???', // ]
  97: '???', // A
  115: '???', // S
  100: '???', // D
  102: '???', // F
  103: '???', // G
  104: '???', // H
  106: '???', // J
  107: '???', // K
  108: '???', // L
  122: '???', // Z
  120: '???', // X
  99: '???', // C
  118: '???', // V
  98: '???', // B
  110: '???', // N
  109: '???', // M
  44: '???', // comma
  46: '???', // period
};

const shiftKeyMap = {
  113: '???', // SHIFT+Q
  119: '???', // SHIFT+W
  101: '', // SHIFT+E
  114: '???', // SHIFT+R
  116: '', // SHIFT+T
  121: '', // SHIFT+Y
  117: '', // SHIFT+U
  105: '???', // SHIFT+I
  111: '???', // SHIFT+O
  112: '???', // SHIFT+P
  91: '???', // {
  93: '???', // }
  97: '\u180E', // SHIFT+A // MVS
  115: '\u202F', // SHIFT+S // NNBS
  100: '\u200D', // SHIFT+D // ZWJ
  102: '\u180B', // SHIFT+F // FVS1
  103: '???', // SHIFT+G
  104: '???', // SHIFT+H
  106: '???', // SHIFT+J
  107: '???', // SHIFT+K
  108: '???', // SHIFT+L
  59: '???', // colon // 1804
  39: '???', // double quote // 1803
  122: '???', // SHIFT+Z
  120: '', // X
  99: '', // C
  118: '', // V
  98: '???', // SHIFT+B
  110: '???', // SHIFT+N
  109: '???', // SHIFT+M
  44: '???', // <
  46: '???', // >
  47: '???', // ?
};

// For some reason the shift keys give different values on macOS
// const keyMap = {
//   113: '???', // Q
//   119: '???', // W
//   101: '???', // E
//   114: '???', // R
//   116: '???', // T
//   121: '???', // Y
//   117: '???', // U
//   105: '???', // I
//   111: '???', // O
//   112: '???', // P
//   91: '???', // [
//   93: '???', // ]
//   97: '???', // A
//   115: '???', // S
//   100: '???', // D
//   102: '???', // F
//   103: '???', // G
//   104: '???', // H
//   106: '???', // J
//   107: '???', // K
//   108: '???', // L
//   122: '???', // Z
//   120: '???', // X
//   99: '???', // C
//   118: '???', // V
//   98: '???', // B
//   110: '???', // N
//   109: '???', // M
//   44: '???', // comma
//   46: '???', // period
//   81: '???', // SHIFT+Q
//   87: '???', // SHIFT+W
//   82: '???', // SHIFT+R
//   73: '???', // SHIFT+I
//   79: '???', // SHIFT+O
//   80: '???', // SHIFT+P
//   123: '???', // {
//   125: '???', // }
//   65: '\u180E', // SHIFT+A // MVS
//   83: '\u202F', // SHIFT+S // NNBS
//   68: '\u200D', // SHIFT+D // ZWJ
//   70: '\u180B', // SHIFT+F // FVS1
//   71: '???', // SHIFT+G
//   72: '???', // SHIFT+H
//   74: '???', // SHIFT+J
//   75: '???', // SHIFT+K
//   76: '???', // SHIFT+L
//   58: '???', // colon // 1804
//   34: '???', // double quote // 1803
//   90: '???', // SHIFT+Z
//   66: '???', // SHIFT+B
//   78: '???', // SHIFT+N
//   77: '???', // SHIFT+M
//   60: '???', // <
//   62: '???', // >
//   63: '???', // ?
// };
