import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';


class Meeting extends StatefulWidget {
  const Meeting({Key? key}) : super(key: key);

  @override
  _MeetingState createState() => _MeetingState();
}

class _MeetingState extends State<Meeting> {
  final serverText = TextEditingController();
  final roomText = TextEditingController(text: "jitsi-meet-wrapper-test-room");
  final subjectText = TextEditingController(text: "My Plugin Test Meeting");
  final tokenText = TextEditingController();
  final userDisplayNameText = TextEditingController(text: "Plugin Test User");
  final userEmailText = TextEditingController(text: "fake@email.com");
  final userAvatarUrlText = TextEditingController();

  bool isAudioMuted = true;
  bool isAudioOnly = false;
  bool isVideoMuted = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Jitsi Meet Wrapper Test')),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: buildMeetConfig(),
        ),
      ),
    );
  }

  Widget buildMeetConfig() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 16.0),
          _buildTextField(
            labelText: "Server URL",
            controller: serverText,
            hintText: "Hint: Leave empty for meet.jitsi.si",
          ),
          const SizedBox(height: 16.0),
          _buildTextField(labelText: "Room", controller: roomText),
          const SizedBox(height: 16.0),
          _buildTextField(labelText: "Subject", controller: subjectText),
          const SizedBox(height: 16.0),
          _buildTextField(labelText: "Token", controller: tokenText),
          const SizedBox(height: 16.0),
          _buildTextField(
            labelText: "User Display Name",
            controller: userDisplayNameText,
          ),
          const SizedBox(height: 16.0),
          _buildTextField(
            labelText: "User Email",
            controller: userEmailText,
          ),
          const SizedBox(height: 16.0),
          _buildTextField(
            labelText: "User Avatar URL",
            controller: userAvatarUrlText,
          ),
          const SizedBox(height: 16.0),
          CheckboxListTile(
            title: const Text("Audio Muted"),
            value: isAudioMuted,
            onChanged: _onAudioMutedChanged,
          ),
          const SizedBox(height: 16.0),
          CheckboxListTile(
            title: const Text("Audio Only"),
            value: isAudioOnly,
            onChanged: _onAudioOnlyChanged,
          ),
          const SizedBox(height: 16.0),
          CheckboxListTile(
            title: const Text("Video Muted"),
            value: isVideoMuted,
            onChanged: _onVideoMutedChanged,
          ),
          const Divider(height: 48.0, thickness: 2.0),
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

  _onAudioOnlyChanged(bool? value) {
    setState(() {
      isAudioOnly = value!;
    });
  }

  _onAudioMutedChanged(bool? value) {
    setState(() {
      isAudioMuted = value!;
    });
  }

  _onVideoMutedChanged(bool? value) {
    setState(() {
      isVideoMuted = value!;
    });
  }

  _joinMeeting() async {
    String? serverUrl = serverText.text.trim().isEmpty ? null : serverText.text;

    Map<FeatureFlag, Object> featureFlags = {};

    // Define meetings options here
    var options = JitsiMeetingOptions(
      roomNameOrUrl: roomText.text,
      serverUrl: serverUrl,
      subject: subjectText.text,
      token: tokenText.text,
      isAudioMuted: isAudioMuted,
      isAudioOnly: isAudioOnly,
      isVideoMuted: isVideoMuted,
      userDisplayName: userDisplayNameText.text,
      userEmail: userEmailText.text,
      featureFlags: featureFlags,
    );

    debugPrint("JitsiMeetingOptions: $options");
    await JitsiMeetWrapper.joinMeeting(
      options: options,
      listener: JitsiMeetingListener(
        onOpened: () => debugPrint("onOpened"),
        onConferenceWillJoin: (url) {
          debugPrint("onConferenceWillJoin: url: $url");
        },
        onConferenceJoined: (url) {
          debugPrint("onConferenceJoined: url: $url");
        },
        onConferenceTerminated: (url, error) {
          debugPrint("onConferenceTerminated: url: $url, error: $error");
        },
        onAudioMutedChanged: (isMuted) {
          debugPrint("onAudioMutedChanged: isMuted: $isMuted");
        },
        onVideoMutedChanged: (isMuted) {
          debugPrint("onVideoMutedChanged: isMuted: $isMuted");
        },
        onScreenShareToggled: (participantId, isSharing) {
          debugPrint(
            "onScreenShareToggled: participantId: $participantId, "
                "isSharing: $isSharing",
          );
        },
        onParticipantJoined: (email, name, role, participantId) {
          debugPrint(
            "onParticipantJoined: email: $email, name: $name, role: $role, "
                "participantId: $participantId",
          );
        },
        onParticipantLeft: (participantId) {
          debugPrint("onParticipantLeft: participantId: $participantId");
        },
        onParticipantsInfoRetrieved: (participantsInfo, requestId) {
          debugPrint(
            "onParticipantsInfoRetrieved: participantsInfo: $participantsInfo, "
                "requestId: $requestId",
          );
        },
        onChatMessageReceived: (senderId, message, isPrivate) {
          debugPrint(
            "onChatMessageReceived: senderId: $senderId, message: $message, "
                "isPrivate: $isPrivate",
          );
        },
        onChatToggled: (isOpen) => debugPrint("onChatToggled: isOpen: $isOpen"),
        onClosed: () => debugPrint("onClosed"),
      ),
    );
  }

  Widget _buildTextField({
    required String labelText,
    required TextEditingController controller,
    String? hintText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText,
          hintText: hintText),
    );
  }
}





class JitsiMeetWrapper {
  /// Joins a meeting based on the JitsiMeetingOptions passed in.
  /// A JitsiMeetingListener can be attached to this meeting that will automatically
  /// be removed when the meeting has ended
  static Future<JitsiMeetingResponse> joinMeeting({
    required JitsiMeetingOptions options,
    JitsiMeetingListener? listener,
  }) async {
    assert(options.roomNameOrUrl.trim().isNotEmpty, "room is empty");

    if (options.serverUrl?.isNotEmpty ?? false) {
      assert(Uri.parse(options.serverUrl!).isAbsolute,
      "URL must be of the format <scheme>://<host>[/path], like https://someHost.com");
    }

    return await JitsiMeetWrapperPlatformInterface.instance
        .joinMeeting(options: options, listener: listener);
  }

  static Future<JitsiMeetingResponse> setAudioMuted(bool isMuted) async {
    return await JitsiMeetWrapperPlatformInterface.instance
        .setAudioMuted(isMuted);
  }

  static Future<JitsiMeetingResponse> hangUp() async {
    return await JitsiMeetWrapperPlatformInterface.instance.hangUp();
  }
}

/// Enumeration of all available feature flags
///
/// Reflects the official list of Jitsi Meet SDK feature flags.
/// https://github.com/jitsi/jitsi-meet/blob/a618697e34d947f0cc0d9ee4a0fc79c76fbae5e6/react/features/base/flags/constants.js
enum FeatureFlag {
  /// Flag indicating if add-people functionality should be enabled.
  /// Default: enabled (true).
  isAddPeopleEnabled,

  /// Flag indicating if the SDK should not require the audio focus.
  /// Used by apps that do not use Jitsi audio.
  /// Default: disabled (false).
  isAudioFocusDisabled,

  /// Flag indicating if the audio mute button should be displayed.
  /// Default: enabled (true).
  isAudioMuteButtonEnabled,

  /// Flag indicating that the Audio only button in the overflow menu is enabled.
  /// Default: enabled (true).
  isAudioOnlyButtonEnabled,

  /// Flag indicating if calendar integration should be enabled.
  /// Default: enabled (true) on Android, auto-detected on iOS.
  isCalendarEnabled,

  /// Flag indicating if call integration (CallKit on iOS, ConnectionService on Android)
  /// should be enabled.
  /// Default: enabled (true).
  isCallIntegrationEnabled,

  /// Flag indicating if close captions should be enabled.
  /// Default: enabled (true).
  isCloseCaptionsEnabled,

  /// Flag indicating if conference timer should be enabled.
  /// Default: enabled (true).
  isConferenceTimerEnabled,

  /// Flag indicating if chat should be enabled.
  /// Default: enabled (true).
  isChatEnabled,

  /// Flag indicating if the filmstrip should be enabled.
  /// Default: enabled (true).
  isFilmstripEnabled,

  // TODO(saibotma): Test whether this works with the theme set on the android activity.
  /// Flag indicating if fullscreen (immersive) mode should be enabled.
  /// Default: enabled (true).
  isFullscreenEnabled,

  /// Flag indicating if the Help button should be enabled.
  /// Default: enabled (true).
  isHelpButtonEnabled,

  /// Flag indicating if invite functionality should be enabled.
  /// Default: enabled (true).
  isInviteEnabled,

  /// Flag indicating if recording should be enabled in iOS.
  /// Default: disabled (false).
  isIosRecordingEnabled,

  /// Flag indicating if screen sharing should be enabled in iOS.
  /// Default: disabled (false).
  isIosScreensharingEnabled,

  /// Flag indicating if screen sharing should be enabled in android.
  /// Default: enabled (true).
  isAndroidScreensharingEnabled,

  /// Flag indicating if kickout is enabled.
  /// Default: enabled (true).
  isKickoutEnabled,

  /// Flag indicating if live-streaming should be enabled.
  /// Default: auto-detected.
  isLiveStreamingEnabled,

  /// Flag indicating if lobby mode button should be enabled.
  /// Default: enabled.
  isLobbyModeEnabled,

  /// Flag indicating if displaying the meeting name should be enabled.
  /// Default: enabled (true).
  isMeetingNameEnabled,

  /// Flag indicating if the meeting password button should be enabled.
  /// Note that this flag just decides on the button, if a meeting has a password
  /// set, the password dialog will still show up.
  /// Default: enabled (true).
  isMeetingPasswordEnabled,

  /// Flag indicating if the notifications should be enabled.
  /// Default: enabled (true).
  isNotificationsEnabled,

  /// Flag indicating if the audio overflow menu button should be displayed.
  /// Default: enabled (true).
  isOverflowMenuEnabled,

  /// Flag indicating if Picture-in-Picture should be enabled.
  /// Default: auto-detected.
  isPipEnabled,

  /// Flag indicating if raise hand feature should be enabled.
  /// Default: enabled.
  isRaiseHandEnabled,

  /// Flag indicating if the reactions feature should be enabled.
  /// Default: enabled (true).
  isReactionsEnabled,

  /// Flag indicating if recording should be enabled.
  /// Default: auto-detected.
  isRecordingEnabled,

  /// Flag indicating if the user should join the conference with the replaceParticipant functionality.
  /// Default: (false).
  isReplaceParticipantEnabled,

  /// Flag indicating the local and (maximum) remote video resolution. Overrides
  /// the server configuration.
  /// Default: (unset).
  resolution,

  /// Flag indicating if the security options button should be enabled.
  /// Default: enabled (true).
  areSecurityOptionsEnabled,

  /// Flag indicating if server URL change is enabled.
  /// Default: enabled (true).
  isServerUrlChangeEnabled,

  /// Flag indicating if tile view feature should be enabled.
  /// Default: enabled.
  isTileViewEnabled,

  /// Flag indicating if the toolbox should be always be visible
  /// Default: disabled (false).
  isToolboxAlwaysVisible,

  /// Flag indicating if the toolbox should be enabled
  /// Default: enabled.
  isToolboxEnabled,

  /// Flag indicating if the video mute button should be displayed.
  /// Default: enabled (true).
  isVideoMuteButtonEnabled,

  /// Flag indicating if the video share button should be enabled
  /// Default: enabled (true).
  isVideoShareButtonEnabled,

  /// Flag indicating if the welcome page should be enabled.
  /// Default: disabled (false).
  isWelcomePageEnabled,
}






abstract class JitsiMeetWrapperPlatformInterface extends PlatformInterface {
  JitsiMeetWrapperPlatformInterface() : super(token: _token);

  static final Object _token = Object();

  static JitsiMeetWrapperPlatformInterface _instance = MethodChannelJitsiMeetWrapper();

  /// The default instance of [JitsiMeetWrapperPlatformInterface] to use.
  ///
  /// Defaults to [MethodChannelJitsiMeetWrapper].
  static JitsiMeetWrapperPlatformInterface get instance => _instance;

  static set instance(JitsiMeetWrapperPlatformInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Joins a meeting based on the [JitsiMeetingOptions] passed in.
  Future<JitsiMeetingResponse> joinMeeting({
    required JitsiMeetingOptions options,
    JitsiMeetingListener? listener,
  }) async {
    throw UnimplementedError('joinMeeting has not been implemented.');
  }

  Future<JitsiMeetingResponse> setAudioMuted(bool isMuted) async {
    throw UnimplementedError('setAudioMuted has not been implemented.');
  }

  Future<JitsiMeetingResponse> hangUp() async {
    throw UnimplementedError('hangUp has not been implemented.');
  }
}


class JitsiMeetingOptions {
  final String roomNameOrUrl;
  final String? serverUrl;
  final String? subject;
  final String? token;
  final bool? isAudioMuted;
  final bool? isAudioOnly;
  final bool? isVideoMuted;
  final String? userDisplayName;
  final String? userEmail;
  final String? userAvatarUrl;
  final Map<FeatureFlag, Object?>? featureFlags;
  final Map<String, Object?>? configOverrides;

  JitsiMeetingOptions({
    required this.roomNameOrUrl,
    this.serverUrl,
    this.subject,
    this.token,
    this.isAudioMuted,
    this.isAudioOnly,
    this.isVideoMuted,
    this.userDisplayName,
    this.userEmail,
    this.userAvatarUrl,
    this.featureFlags,
    this.configOverrides,
  });


  @override
  String toString() {
    return 'JitsiMeetingOptions{roomNameOrUrl: $roomNameOrUrl, serverUrl: $serverUrl, subject: $subject, token: $token, isAudioMuted: $isAudioMuted, isAudioOnly: $isAudioOnly, isVideoMuted: $isVideoMuted, userDisplayName: $userDisplayName, userEmail: $userEmail, userAvatarUrl: $userAvatarUrl, featureFlags: $featureFlags, configOverrides: $configOverrides}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is JitsiMeetingOptions &&
              runtimeType == other.runtimeType &&
              roomNameOrUrl == other.roomNameOrUrl &&
              serverUrl == other.serverUrl &&
              subject == other.subject &&
              token == other.token &&
              isAudioMuted == other.isAudioMuted &&
              isAudioOnly == other.isAudioOnly &&
              isVideoMuted == other.isVideoMuted &&
              userDisplayName == other.userDisplayName &&
              userEmail == other.userEmail &&
              userAvatarUrl == other.userAvatarUrl ;
              // const MapEquality().equals(featureFlags, other.featureFlags) &&
              // const MapEquality().equals(configOverrides, other.configOverrides);

  @override
  int get hashCode =>
      roomNameOrUrl.hashCode ^
      serverUrl.hashCode ^
      subject.hashCode ^
      token.hashCode ^
      isAudioMuted.hashCode ^
      isAudioOnly.hashCode ^
      isVideoMuted.hashCode ^
      userDisplayName.hashCode ^
      userEmail.hashCode ^
      userAvatarUrl.hashCode ;
      // const MapEquality().hash(featureFlags) ^
      // const MapEquality().hash(configOverrides);
}

class JitsiMeetingResponse {
  final bool isSuccess;
  final String? message;
  final dynamic error;

  JitsiMeetingResponse({
    required this.isSuccess,
    this.message,
    this.error,
  });

  @override
  String toString() {
    return 'JitsiMeetingResponse{isSuccess: $isSuccess, '
        'message: $message, error: $error}';
  }
}



const MethodChannel _methodChannel = MethodChannel('jitsi_meet_wrapper');
const EventChannel _eventChannel = EventChannel('jitsi_meet_wrapper_events');

/// An implementation of [JitsiMeetPlatform] that uses method channels.
class MethodChannelJitsiMeetWrapper extends JitsiMeetWrapperPlatformInterface {
  bool _eventChannelIsInitialized = false;
  JitsiMeetingListener? _listener;

  @override
  Future<JitsiMeetingResponse> joinMeeting({
    required JitsiMeetingOptions options,
    JitsiMeetingListener? listener,
  }) async {
    _listener = listener;
    if (!_eventChannelIsInitialized) {
      _initialize();
    }

    Map<String, dynamic> _options = {
      'roomName': options.roomNameOrUrl.trim(),
      'serverUrl': options.serverUrl?.trim(),
      'subject': options.subject?.trim(),
      'token': options.token,
      'isAudioMuted': options.isAudioMuted,
      'isAudioOnly': options.isAudioOnly,
      'isVideoMuted': options.isVideoMuted,
      'userDisplayName': options.userDisplayName,
      'userEmail': options.userEmail,
      'userAvatarUrl': options.userAvatarUrl,
      'featureFlags': _toFeatureFlagStrings(options.featureFlags),
      'configOverrides': options.configOverrides,
    };

    return await _methodChannel
        .invokeMethod<String>('joinMeeting', _options)
        .then((message) {
      return JitsiMeetingResponse(isSuccess: true, message: message);
    }).catchError((error) {
      return JitsiMeetingResponse(
        isSuccess: false,
        message: error.toString(),
        error: error,
      );
    });
  }

  @override
  Future<JitsiMeetingResponse> setAudioMuted(bool isMuted) async {
    Map<String, dynamic> _options = {
      'isMuted': isMuted,
    };
    return await _methodChannel
        .invokeMethod<String>('setAudioMuted', _options)
        .then((message) {
      return JitsiMeetingResponse(isSuccess: true, message: message);
    }).catchError((error) {
      return JitsiMeetingResponse(
        isSuccess: false,
        message: error.toString(),
        error: error,
      );
    });
  }

  @override
  Future<JitsiMeetingResponse> hangUp() async {
    return await _methodChannel.invokeMethod<String>('hangUp').then((message) {
      return JitsiMeetingResponse(isSuccess: true, message: message);
    }).catchError((error) {
      return JitsiMeetingResponse(
        isSuccess: false,
        message: error.toString(),
        error: error,
      );
    });
  }

  void _initialize() {
    _eventChannel.receiveBroadcastStream().listen((message) {
      final data = message['data'];
      switch (message['event']) {
        case "opened":
          _listener?.onOpened?.call();
          break;
        case "conferenceWillJoin":
          _listener?.onConferenceWillJoin?.call(data["url"]);
          break;
        case "conferenceJoined":
          _listener?.onConferenceJoined?.call(data["url"]);
          break;
        case "conferenceTerminated":
          _listener?.onConferenceTerminated?.call(data["url"], data["error"]);
          break;
        case "audioMutedChanged":
          _listener?.onAudioMutedChanged?.call(parseBool(data["muted"]));
          break;
        case "videoMutedChanged":
          _listener?.onVideoMutedChanged?.call(parseBool(data["muted"]));
          break;
        case "screenShareToggled":
          _listener?.onScreenShareToggled
              ?.call(data["participantId"], parseBool(data["sharing"]));
          break;
        case "participantJoined":
          _listener?.onParticipantJoined?.call(
            data["email"],
            data["name"],
            data["role"],
            data["participantId"],
          );
          break;
        case "participantLeft":
          _listener?.onParticipantLeft?.call(data["participantId"]);
          break;
        case "participantsInfoRetrieved":
          _listener?.onParticipantsInfoRetrieved?.call(
            data["participantsInfo"],
            data["requestId"],
          );
          break;
        case "chatMessageReceived":
          _listener?.onChatMessageReceived?.call(
            data["senderId"],
            data["message"],
            parseBool(data["isPrivate"]),
          );
          break;
        case "chatToggled":
          _listener?.onChatToggled?.call(parseBool(data["isOpen"]));
          break;
        case "closed":
          _listener?.onClosed?.call();
          _listener = null;
          break;
      }
    }).onError((error) {
      debugPrint("Error receiving data from the event channel: $error");
    });
    _eventChannelIsInitialized = true;
  }

  Map<String, Object>? _toFeatureFlagStrings(
      Map<FeatureFlag, Object?>? featureFlags,
      ) {
    if (featureFlags == null) return null;
    Map<String, Object> featureFlagsWithStrings = {};
    featureFlags.forEach((key, value) {
      if (value != null) {
        featureFlagsWithStrings[_toFeatureFlagString(key)] = value;
      }
    });
    return featureFlagsWithStrings;
  }

  String _toFeatureFlagString(FeatureFlag featureFlag) {
    // Constants from: https://github.com/jitsi/jitsi-meet/blob/master/react/features/base/flags/constants.js
    switch (featureFlag) {
      case FeatureFlag.isAddPeopleEnabled:
        return 'add-people.enabled';
      case FeatureFlag.isCalendarEnabled:
        return 'calendar.enabled';
      case FeatureFlag.isCallIntegrationEnabled:
        return 'call-integration.enabled';
      case FeatureFlag.isCloseCaptionsEnabled:
        return 'close-captions.enabled';
      case FeatureFlag.isChatEnabled:
        return 'chat.enabled';
      case FeatureFlag.isInviteEnabled:
        return 'invite.enabled';
      case FeatureFlag.isIosRecordingEnabled:
        return 'ios.recording.enabled';
      case FeatureFlag.isIosScreensharingEnabled:
        return 'ios.screensharing.enabled';
      case FeatureFlag.isLiveStreamingEnabled:
        return 'live-streaming.enabled';
      case FeatureFlag.isMeetingNameEnabled:
        return 'meeting-name.enabled';
      case FeatureFlag.isMeetingPasswordEnabled:
        return 'meeting-password.enabled';
      case FeatureFlag.isPipEnabled:
        return 'pip.enabled';
      case FeatureFlag.isRaiseHandEnabled:
        return 'raise-hand.enabled';
      case FeatureFlag.isRecordingEnabled:
        return 'recording.enabled';
      case FeatureFlag.isTileViewEnabled:
        return 'tile-view.enabled';
      case FeatureFlag.isToolboxAlwaysVisible:
        return 'toolbox.alwaysVisible';
      case FeatureFlag.isWelcomePageEnabled:
        return 'welcomepage.enabled';
      case FeatureFlag.isAudioFocusDisabled:
        return 'audio-focus.disabled';
      case FeatureFlag.isAudioMuteButtonEnabled:
        return 'audio-mute.enabled';
      case FeatureFlag.isAudioOnlyButtonEnabled:
        return 'audio-only.enabled';
      case FeatureFlag.isConferenceTimerEnabled:
        return 'conference-timer.enabled';
      case FeatureFlag.isFilmstripEnabled:
        return 'filmstrip.enabled';
      case FeatureFlag.isFullscreenEnabled:
        return 'fullscreen.enabled';
      case FeatureFlag.isHelpButtonEnabled:
        return 'help.enabled';
      case FeatureFlag.isAndroidScreensharingEnabled:
        return 'android.screensharing.enabled';
      case FeatureFlag.isKickoutEnabled:
        return 'kick-out.enabled';
      case FeatureFlag.isLobbyModeEnabled:
        return 'lobby-mode.enabled';
      case FeatureFlag.isNotificationsEnabled:
        return 'notifications.enabled';
      case FeatureFlag.isOverflowMenuEnabled:
        return 'overflow-menu.enabled';
      case FeatureFlag.isReactionsEnabled:
        return 'reactions.enabled';
      case FeatureFlag.isReplaceParticipantEnabled:
        return 'replace.participant';
      case FeatureFlag.resolution:
        return 'resolution';
      case FeatureFlag.areSecurityOptionsEnabled:
        return 'security-options.enabled';
      case FeatureFlag.isServerUrlChangeEnabled:
        return 'server-url-change.enabled';
      case FeatureFlag.isToolboxEnabled:
        return 'toolbox.enabled';
      case FeatureFlag.isVideoMuteButtonEnabled:
        return 'video-mute.enabled';
      case FeatureFlag.isVideoShareButtonEnabled:
        return 'video-share.enabled';
    }
  }
}

// Required because Android SDK returns boolean values as Strings
// and iOS SDK returns boolean values as Booleans.
// (Making this an extension does not work, because of dynamic.)
bool parseBool(dynamic value) {
  if (value is bool) return value;
  if (value is String) return value == 'true';
  // Check whether value is not 0, because true values can be any value
  // above 0 when coming from Jitsi.
  if (value is num) return value != 0;
  throw ArgumentError('Unsupported type: $value');
}

/// JitsiMeetingListener
///
/// Class holding the callback functions for conference events.
class JitsiMeetingListener {
  /// The native view got created.
  final Function()? onOpened;

  // iOS: https://jitsi.github.io/handbook/docs/dev-guide/dev-guide-ios-sdk/#conferencewilljoin
  // Android: https://jitsi.github.io/handbook/docs/dev-guide/dev-guide-android-sdk#conference_will_join
  final Function(String url)? onConferenceWillJoin;

  // iOS: https://jitsi.github.io/handbook/docs/dev-guide/dev-guide-ios-sdk/#conferencejoined
  // Android: https://jitsi.github.io/handbook/docs/dev-guide/dev-guide-android-sdk#conference_joined
  final Function(String url)? onConferenceJoined;

  // iOS: https://jitsi.github.io/handbook/docs/dev-guide/dev-guide-ios-sdk/#conferenceterminated
  // Android: https://jitsi.github.io/handbook/docs/dev-guide/dev-guide-android-sdk#conference_terminated
  final Function(String url, Object? error)? onConferenceTerminated;

  // iOS: https://jitsi.github.io/handbook/docs/dev-guide/dev-guide-ios-sdk/#audiomutedchanged
  // Android: https://jitsi.github.io/handbook/docs/dev-guide/dev-guide-android-sdk#audio_muted_changed
  final Function(bool isMuted)? onAudioMutedChanged;

  // iOS: https://jitsi.github.io/handbook/docs/dev-guide/dev-guide-ios-sdk/#videomutedchanged
  // Android: https://jitsi.github.io/handbook/docs/dev-guide/dev-guide-android-sdk#video_muted_changed
  final Function(bool isMuted)? onVideoMutedChanged;

  // iOS: https://jitsi.github.io/handbook/docs/dev-guide/dev-guide-ios-sdk#screensharetoggled
  // TODO(saibotma): Add Android docs when https://github.com/jitsi/handbook/pull/300 is merged.
  final Function(String participantId, bool isSharing)? onScreenShareToggled;

  // iOS: https://jitsi.github.io/handbook/docs/dev-guide/dev-guide-ios-sdk/#participantjoined
  // Android: https://jitsi.github.io/handbook/docs/dev-guide/dev-guide-android-sdk#participant_joined
  final Function(
      String? email,
      String? name,
      String? role,
      String? participantId,
      )? onParticipantJoined;

  // iOS: https://jitsi.github.io/handbook/docs/dev-guide/dev-guide-ios-sdk/#participantleft
  // Android: https://jitsi.github.io/handbook/docs/dev-guide/dev-guide-android-sdk#participant_left
  final Function(String? participantId)? onParticipantLeft;

  // Only for Android
  // https://jitsi.github.io/handbook/docs/dev-guide/dev-guide-android-sdk#participants_info_retrieved
  final Function(
      Map<String, dynamic> participantsInfo,
      String requestId,
      )? onParticipantsInfoRetrieved;

  // iOS: https://jitsi.github.io/handbook/docs/dev-guide/dev-guide-ios-sdk/#chatmessagereceived
  // Android: https://jitsi.github.io/handbook/docs/dev-guide/dev-guide-android-sdk#chat_message_received
  final Function(
      String senderId,
      String message,
      bool isPrivate,
      )? onChatMessageReceived;

  // iOS: https://jitsi.github.io/handbook/docs/dev-guide/dev-guide-ios-sdk/#chattoggled
  // Android: https://jitsi.github.io/handbook/docs/dev-guide/dev-guide-android-sdk#chat_toggled
  final Function(bool isOpen)? onChatToggled;

  /// The native view got closed.
  final Function()? onClosed;

  JitsiMeetingListener({
    this.onOpened,
    this.onConferenceWillJoin,
    this.onConferenceJoined,
    this.onConferenceTerminated,
    this.onAudioMutedChanged,
    this.onVideoMutedChanged,
    this.onScreenShareToggled,
    this.onParticipantJoined,
    this.onParticipantLeft,
    this.onParticipantsInfoRetrieved,
    this.onChatMessageReceived,
    this.onChatToggled,
    this.onClosed,
  });
}
