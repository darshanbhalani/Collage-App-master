import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:myapp2/app/util/VariablesFile.dart';

class ClassChat extends StatefulWidget {
  final String className;
  final String getKey;
  const ClassChat({super.key, required this.className, required this.getKey});

  @override
  ClassChatState createState() => ClassChatState();
}

class ClassChatState extends State<ClassChat> {
  firebase_auth.User? _user;
  late DatabaseReference _firebaseMsgDbRef;

  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false;
  List names = ['Uttam', 'Darshan', 'Bhargav', 'Darshil'];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now().toUtc();
    this._firebaseMsgDbRef =
        FirebaseDatabase.instance.ref().child('messages/${widget.className}');
    this._user = firebase_auth.FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: <Widget>[
            _buildMessagesList(),
            _buildComposeMsgRow()
          ],
        ),
      ),
    );
  }

  // Builds the list of chat messages.
  Widget _buildMessagesList() {
    Key key = Key(DateTime.now().millisecondsSinceEpoch.toString());
    Query query = _firebaseMsgDbRef;
    setState(() {
      key = Key(widget.getKey);
      query = _firebaseMsgDbRef;
    });
    return Flexible(
      child: Scrollbar(
        child: FirebaseAnimatedList(
          key: key,
          defaultChild: const Center(child: CircularProgressIndicator()),
          query: query,
          sort: (a, b) => b.key!.compareTo(a.key!),
          padding: const EdgeInsets.all(8.0),
          reverse: true,
          itemBuilder: (
            BuildContext ctx,
            DataSnapshot snapshot,
            Animation<double> animation,
            int idx,
          ) =>
              _messageFromSnapshot(snapshot, animation),
        ),
      ),
    );
  }

  // Returns the UI of one message from a data snapshot.
  Widget _messageFromSnapshot(
    DataSnapshot snapshot,
    Animation<double> animation,
  ) {
    final val = snapshot.value;
    if (val == null) {
      return Container();
    }
    final json = val as Map;
    final senderName = json['senderName'] as String? ?? '?? <unknown>';
    final msgText = json['text'] as String? ?? '??';
    final userType = json['userType'] as String? ?? '!!';
    final senderPhotoUrl = json['senderPhotoUrl'] as String?;
    final messageUI = Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: senderPhotoUrl != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(senderPhotoUrl),
                  )
                : CircleAvatar(
                    child: Text(senderName[0]),
                  ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(senderName, style: Theme.of(context).textTheme.subtitle1),
                Text(
                  userType,
                  style: Theme.of(context).textTheme.caption,
                ),
                Text(msgText),
              ],
            ),
          ),
        ],
      ),
    );
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: messageUI,
    );
  }

  // Builds the row for composing and sending message.
  Widget _buildComposeMsgRow() {
    return Container(

      margin: const EdgeInsets.symmetric(horizontal: 6.0),

      decoration: BoxDecoration(

        color: Theme.of(context).cardColor,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                maxLength: null,
                decoration: const InputDecoration(
                    hintText: "Send a message", border: InputBorder.none),
                controller: _textController,
                onChanged: (String text) =>
                    setState(() => _isComposing = text.isNotEmpty),
                onSubmitted: _onTextMsgSubmitted,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _isComposing
                ? () => _onTextMsgSubmitted(_textController.text)
                : null,
          ),
        ],
      ),
    );
  }

  // Triggered when text is submitted (send button pressed).
  Future<void> _onTextMsgSubmitted(String text) async {
    // Clear input text field.
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    // Send message to firebase realtime database.
    String? newRefKey = await _firebaseMsgDbRef.push().key;
    _firebaseMsgDbRef.push().set({
      'senderId': this._user!.uid,
      'senderName': current_user_first_name + ' ' + current_user_last_name,
      'senderPhotoUrl': current_user_photo,
      'text': text,
      'userType': current_user_type,
      'list': names
    });
  }
}
