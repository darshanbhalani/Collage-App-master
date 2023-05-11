import 'package:date_time_format/date_time_format.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import 'package:myapp2/app/util/VariablesFile.dart';

class ClassStream extends StatefulWidget {
  final String className;
  final String getKey;
  const ClassStream({super.key, required this.className, required this.getKey});

  @override
  State<ClassStream> createState() => _ClassStreamState();
}

class _ClassStreamState extends State<ClassStream> {
  final postTime = DateTime.now();
  firebase_auth.User? user;
  late DatabaseReference firebaseMsgDbRef;

  final TextEditingController textController = TextEditingController();
  bool isComposing = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    this.firebaseMsgDbRef =
        FirebaseDatabase.instance.ref().child('Stream/Classes');

    this.user = firebase_auth.FirebaseAuth.instance.currentUser;
    print(widget.className);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          buildStreamList(),
          const Divider(height: 2.0),
          buildStreamMsgRow(),
        ],
      ),
    );
  }

  Widget buildStreamList() {
    Key key = Key(DateTime.now().millisecondsSinceEpoch.toString());
    Query query = firebaseMsgDbRef.child(widget.className);
    setState(() {
      key = Key(widget.getKey);
      query = firebaseMsgDbRef.child(widget.className);
    });
    return Flexible(
      child: Scrollbar(
        child: FirebaseAnimatedList(
          key: key,
          defaultChild: const Center(child: CircularProgressIndicator()),
          query: query,
          sort: (a, b) => b.key!.compareTo(a.key!),
          padding: const EdgeInsets.all(8.0),
          reverse: false,
          itemBuilder: (
            BuildContext ctx,
            DataSnapshot snapshot,
            Animation<double> animation,
            int idx,
          ) =>
              streamMsgFromSnapshot(snapshot, animation),
        ),
      ),
    );
  }

  Widget streamMsgFromSnapshot(
    DataSnapshot snapshot,
    Animation<double> animation,
  ) {
    final val = snapshot.value;
    print(snapshot.value);
    if (val == null) {
      return Container();
    }
    final json = val as Map;
    final senderName = json['senderName'] as String? ?? '?? <unknown>';
    final msgText = json['text'] as String? ?? '??';
    final time = json['time'] as String? ?? '!!';
    final senderPhotoUrl = json['senderPhotoUrl'] as String? ?? '';
    final messageUI = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(senderPhotoUrl),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      senderName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      time,
                      style: Theme.of(context).textTheme.caption,
                    )
                  ],
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(msgText),
            )
          ],
        ),
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

  Widget buildStreamMsgRow() {
    return Visibility(
      visible: current_user_type == 'Teacher',
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6.0),
        decoration: BoxDecoration(color: Theme.of(context).cardColor,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
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
                      hintText: "Write stream message", border: InputBorder.none),
                  controller: textController,
                  onChanged: (String text) =>
                      setState(() => isComposing = text.isNotEmpty),
                  onSubmitted: onStreamMsgSubmitted,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: isComposing
                  ? () => onStreamMsgSubmitted(textController.text)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onStreamMsgSubmitted(String text) async {
    // Clear input text field.
    textController.clear();
    setState(() {
      isComposing = false;
    });
    // Send message to firebase realtime database.
    firebaseMsgDbRef.child(widget.className).push().set({
      'senderId': this.user!.uid,
      'senderName': current_user_first_name + ' ' + current_user_last_name,
      'senderPhotoUrl': current_user_photo,
      'text': text,
      'time': postTime.format('D, M j, H:i'),
    });
  }
}
