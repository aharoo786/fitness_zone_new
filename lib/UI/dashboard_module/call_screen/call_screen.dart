import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnesss_app/data/controllers/home_controller/home_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../../../data/controllers/auth_controller/auth_controller.dart';
import '../../../values/constants.dart';
import '../chat/chat_room.dart';

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
  //EdScreenRecorder screenRecorder = EdScreenRecorder();
  final AuthController authController = Get.find();
  int? _remoteUid;
  bool _localUserJoined = false;
  bool recordingStart = false;
  List participantList = [];
  late RtcEngine _engine;

  Map<String, dynamic>? _response;

  @override
  void initState() {
    super.initState();
    // Get.find<HomeController>().recordSession(widget.channelName);();
    // startRecord();
    initAgora();
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
            participantList.add(remoteUid);
          });
          Get.log("list12345  $participantList");
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
      options: const ChannelMediaOptions(
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
          clientRoleType: ClientRoleType.clientRoleBroadcaster),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _dispose();
  }

  // Future<void> startRecord() async {
  //   Directory? tempDir = await getApplicationDocumentsDirectory();
  //   String? tempPath = tempDir.path;
  //
  //   try {
  //     var startResponse = await screenRecorder.startRecordScreen(
  //       fileName: "ab",
  //       //Optional. It will save the video there when you give the file path with whatever you want.
  //       //If you leave it blank, the Android operating system will save it to the gallery.
  //       dirPathToSave: tempPath,
  //       audioEnable: true,
  //     );
  //     // setState(() {
  //     //   _response = startResponse;
  //     // });
  //     //bool started =await  FlutterScreenRecording.startRecordScreen("ab.mp4");
  //
  //     // print("response started $started");
  //   } on PlatformException {
  //     kDebugMode
  //         ? debugPrint("Error: An error occurred while starting the recording!")
  //         : null;
  //   }
  // }
  // Future<void> stopRecord() async {
  //   try {
  //     print("Stoping recording");
  //     screenRecorder.stopRecord().then((value) {
  //       _response=value;
  //
  //       print("value $value");
  //
  //     });
  //  if(_response !=null){
  //    Get.find<HomeController>().videoFile=XFile(_response!["file"].path);
  //  }
  //
  //     //  Get.find<HomeController>().update();
  //
  //     // setState(() {
  //     //   _response = stopResponse;
  //     // });
  //     //Share.shareXFiles([XFile(_response!["file"])]);
  //     //print("response stop $_response");
  //   } on PlatformException {
  //     kDebugMode
  //         ? debugPrint("Error: An error occurred while stopping recording.")
  //         : null;
  //   }
  // }
  Future<void> deleteCollection() async {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection(widget.channelName.hashCode.toString());

    QuerySnapshot querySnapshot = await collectionReference.get();

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      await documentSnapshot.reference.delete();
    }
  }

  Future<void> _dispose() async {
    //await stopRecord();
    //await stopRecord();
    await _engine.leaveChannel();
    await _engine.release();
    if (Get.find<AuthController>().loginAsA.value == Constants.host) {
      await deleteCollection();
    }

    // var frames= await controller.exporter.exportFrames();
    // print("frames $frames");
    // controller.stop();
    // Get.find<HomeController>().uploadFramesToFirebase(frames);
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    print("toke   ${widget.token}");
    return GetBuilder<HomeController>(builder: (contr) {
      return WillPopScope(
        onWillPop: () {
          Get.defaultDialog(
              title: "End Session",
              content: const Text("Are you sure you want to end session?"),
              onCancel: () async {},
              onConfirm: () async {
                await _dispose();
                Get.back();
                Get.back();
              });
          return Future.value(true);
        },
        child: Scaffold(
          // appBar: AppBar(
          //   title: const Text('Agora Video Call'),
          // ),
          body: authController.loginAsA.value == Constants.host
              ? Stack(
                  children: [

                    Center(
                      child: _localUserJoined
                          ? contr.muteVideo.value
                              ? Container(
                                  padding: EdgeInsets.all(20),
                                  color: Colors.black,
                                  child: const Icon(
                                    Icons.videocam_off,
                                    color: Colors.white,
                                  ),
                                )
                              : AgoraVideoView(
                                  controller: VideoViewController(
                                    rtcEngine: _engine,
                                    canvas: VideoCanvas(uid: 0),
                                  ),
                                )
                          : const CircularProgressIndicator(),
                    ),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 30,left: 20,right: 20),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              width: 100,
                              height: 150,
                             //padding: EdgeInsets.all(50),
                              child: _remoteVideoUser(participantList[index]));
                        },
                        itemCount: participantList.length,
                      ),
                    ),
                  ],
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
                              ? contr.muteVideo.value
                                  ? SizedBox()
                                  : AgoraVideoView(
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
                  contr.muteAudio.value = !contr.muteAudio.value;
                  _engine.muteLocalAudioStream(contr.muteAudio.value);
                  contr.update();
                },
                backgroundColor: Colors.white,
                child: Obx(() => Icon(
                      contr.muteAudio.value ? Icons.mic_off_rounded : Icons.mic,
                      color: Colors.black,
                    )),
              ),
              FloatingActionButton(
                onPressed: () async {
                  contr.muteVideo.value = !contr.muteVideo.value;
                  await _engine.muteLocalAudioStream(contr.muteVideo.value);
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
                  Get.to(() => ChatRoom(
                        chatRoomId: widget.channelName.hashCode.toString(),
                      ));
                },
                backgroundColor: Colors.white,
                child: const Icon(
                  Icons.message,
                  color: Colors.black,
                ),
              ),
              FloatingActionButton(
                onPressed: () async {
                  Get.defaultDialog(
                      title: "End Session",
                      content: Text("Are you sure you want to end session?"),
                      onCancel: () async {},
                      onConfirm: () async {
                        await _dispose();
                        Get.back();
                        Get.back();
                      });
                },
                child: Icon(
                  Icons.call_end,
                  color: Colors.white,
                ),
                backgroundColor: Colors.red,
              ),
            ],
          ),
        ),
      );
    });
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

  Widget _remoteVideoUser(int id) {
    print("remotid $_remoteUid");
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: id),
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
