import 'package:flutter/material.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import 'package:myapp2/app/util/VariablesFile.dart';

class Meeting extends StatefulWidget {
  const Meeting({Key? key}) : super(key: key);

  @override
  _MeetingState createState() => _MeetingState();
}

class _MeetingState extends State<Meeting> {
  final serverText = TextEditingController();
  final roomText = TextEditingController();
  final subjectText = TextEditingController();
  final tokenText = TextEditingController();
  final userDisplayNameText = TextEditingController();
  final userEmailText = TextEditingController();
  final userAvatarUrlText = TextEditingController();

  bool isAudioMuted = true;
  bool isAudioOnly = false;
  bool isVideoMuted = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Live Class')),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: buildMeetConfig(),
        ),
    );
  }

  Widget buildMeetConfig() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 64.0,
            width: double.maxFinite,
            child: ElevatedButton(
              onPressed: () => _joinMeeting(),
              child: const Text(
                "Join Meeting",
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor:
                MaterialStateColor.resolveWith((states) => Colors.blue),
              ),
            ),
          ),
          const SizedBox(height: 48.0),
        ],
      ),
    );
  }
  _joinMeeting() async {
    String? serverUrl = serverText.text.trim().isEmpty ? null : serverText.text;

    Map<FeatureFlag, Object> featureFlags = {};

    // Define meetings options here
    var options = JitsiMeetingOptions(
      roomNameOrUrl: "${current_user_first_name} ${current_user_last_name} 's Session",
      // serverUrl: serverUrl,
      subject: "${current_user_first_name} ${current_user_last_name} 's Session",
      // token: tokenText.text,
      isAudioMuted: isAudioMuted,
      // isAudioOnly: isAudioOnly,
      isVideoMuted: isVideoMuted,
      userDisplayName: current_user_enrollmentno + current_user_first_name,
      userEmail: current_user_email,
      featureFlags: featureFlags,
    );

    debugPrint("JitsiMeetingOptions: $options");
    await JitsiMeetWrapper.joinMeeting(
      options: options,
      listener: JitsiMeetingListener(
      ),
    );
  }
}