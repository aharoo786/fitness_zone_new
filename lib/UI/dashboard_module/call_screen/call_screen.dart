import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:fitnesss_app/UI/dashboard_module/chat_screen/chat_screen.dart';
import 'package:fitnesss_app/data/controllers/home_controller/home_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ed_screen_recorder/ed_screen_recorder.dart';



import '../../../data/controllers/auth_controller/auth_controller.dart';
import '../../../values/constants.dart';

class CallScreen extends StatefulWidget {
  CallScreen(
      {Key? key,
      required this.channelName,
      required this.token,
      required this.userId})
      : super(key: key);
  final String channelName;
  final String token;
  final String userId;

  @override
  State<CallScreen> createState() => _MyAppState();
}

class _MyAppState extends State<CallScreen> {
  //ScreenRecorderController controller = ScreenRecorderController();

  final AuthController authController = Get.find();
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  EdScreenRecorder? screenRecorder;
  Map<String, dynamic>? _response;

  @override
  void initState() {
    super.initState();
    screenRecorder = EdScreenRecorder();

    initAgora();

    startRecord();


  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: Constants.appID,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.setClientRole(
        role: authController.loginAsA.value == Constants.host
            ? ClientRoleType.clientRoleBroadcaster
            : ClientRoleType.clientRoleAudience);
    await _engine.enableVideo();
    await _engine.startPreview();
    int randomNumber = Random().nextInt(100);
    await _engine.joinChannel(
      token: widget.token,
      channelId: widget.channelName,
      uid: 0,
      options: ChannelMediaOptions(
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
          clientRoleType: authController.loginAsA.value == Constants.host
              ? ClientRoleType.clientRoleBroadcaster
              : ClientRoleType.clientRoleAudience),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _dispose();
  }
  Future<void> startRecord() async {
    Directory? tempDir =  Directory.systemTemp;
    String? tempPath = tempDir.path;

    try {
      var startResponse = await screenRecorder?.startRecordScreen(
        fileName: "ab",
        //Optional. It will save the video there when you give the file path with whatever you want.
        //If you leave it blank, the Android operating system will save it to the gallery.
        dirPathToSave: tempPath,
        audioEnable: true,
      );
      setState(() {
        _response = startResponse;
      });
      print("response $_response");
    } on PlatformException {
      kDebugMode ? debugPrint("Error: An error occurred while starting the recording!") : null;
    }
  }
  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
    // var frames= await controller.exporter.exportFrames();
    // print("frames $frames");
    // controller.stop();
   // Get.find<HomeController>().uploadFramesToFirebase(frames);
    stopRecord();
  }
  Future<void> stopRecord() async {
    try {
      var stopResponse = await screenRecorder?.stopRecord();
      setState(() {
        _response = stopResponse;
      });
      print("response stop $_response");
    } on PlatformException {
      kDebugMode ? debugPrint("Error: An error occurred while stopping recording.") : null;
    }
  }
  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    print("toke   ${widget.token}");
    return GetBuilder<HomeController>(
      builder: (contr) {
        return Scaffold(
          // appBar: AppBar(
          //   title: const Text('Agora Video Call'),
          // ),
          body: authController.loginAsA.value == Constants.host
              ? Center(
                  child: _localUserJoined
                      ? AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: _engine,
                      canvas: VideoCanvas(uid: 0),
                    ),
                  )
                      : const CircularProgressIndicator(),
                )
              : Stack(
                  children: [
                    Center(
                      child: _remoteVideo(),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                        width: 100,
                        height: 150,
                        child: Center(
                          child: _localUserJoined
                              ? contr.muteVideo.value?SizedBox():AgoraVideoView(
                                  controller: VideoViewController(
                                    rtcEngine: _engine,
                                    canvas: VideoCanvas(uid: 0),
                                  ),
                                )
                              : const CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  ],
                ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                onPressed: () {
                  contr.muteAudio.value =
                      !contr.muteAudio.value;
                  _engine.muteLocalAudioStream(
                      contr.muteAudio.value);
                  contr.update();
                },
                backgroundColor: Colors.white,
                child: Obx(() => Icon(
                      contr.muteAudio.value
                          ? Icons.mic_off_rounded
                          : Icons.mic,
                      color: Colors.black,
                    )),
              ),
              FloatingActionButton(
                onPressed: () {
                  contr.muteVideo.value =
                      !contr.muteVideo.value;
                  _engine.muteLocalAudioStream(
                      contr.muteVideo.value);
                  contr.update();
                },
                backgroundColor: Colors.white,
                child: Obx(() => Icon(
                      contr.muteVideo.value
                          ? Icons.videocam_off
                          : Icons.videocam,
                      color: Colors.black,
                    )),
              ),
              FloatingActionButton(
                onPressed: () async {
                  ChatOptions options = ChatOptions(appKey: Constants.chatAppKey, autoLogin: false);
                  await ChatClient.getInstance.init(options);
                  Get.to(()=>ChatScreen(title: "Chat", remoteId: _remoteUid.toString(), channelName: widget.channelName,currentUserId:"0",token: widget.token,));
                },
                backgroundColor: Colors.white,
                child: const Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
              ),
              FloatingActionButton(
                onPressed: () {
                  Get.back();
                },
                child: Icon(
                  Icons.call_end,
                  color: Colors.white,
                ),
                backgroundColor: Colors.red,
              ),
            ],
          ),
        );
      }
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    print("remotid $_remoteUid");
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: widget.channelName),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}
