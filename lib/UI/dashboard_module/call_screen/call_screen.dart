import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnesss_app/data/controllers/home_controller/home_controller.dart';
import 'package:fitnesss_app/values/my_colors.dart';
import 'package:fitnesss_app/widgets/toasts.dart';
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
      required this.userId,
      required this.camera})
      : super(key: key);
  final String channelName;
  final String token;
  final String userId;
  final CameraDescription camera;

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
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  Map<String, dynamic>? _response;

  @override
  void initState() {
    super.initState();
    // Get.find<HomeController>().recordSession(widget.channelName);();
    // startRecord()
    // ;
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _controller.initialize();

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
            participantList.remove(remoteUid);
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.setClientRole(
        role:

            // authController.loginAsA.value == Constants.host
            //     ?
            ClientRoleType.clientRoleBroadcaster
        // : ClientRoleType.clientRoleAudience

        );
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

    if (Get.find<AuthController>().loginAsA.value == Constants.host) {
      await deleteCollection();
      await stopRecording();
    }
    await _engine.leaveChannel();
    await _engine.release();
    _controller.dispose();
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
          body: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.9,
            ),
            itemCount: participantList.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildLocalUserWidget();
              } else {
                return _remoteVideoUser(participantList[index - 1]);
              }
            },
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FloatingActionButton(
                mini: true,
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
                mini: true,
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
                mini: true,
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
              Get.find<AuthController>().loginAsA.value == Constants.host
                  ? FloatingActionButton(
                mini: true,
                      onPressed: () async {
                        try {
                          await startRecording();
                        } catch (e) {
                          print('Error: $e');
                        }
                      },
                      backgroundColor: Colors.white,
                      child: const Icon(
                        Icons.emergency_recording_rounded,
                        color: Colors.black,
                      ),
                    )
                  : SizedBox(),
              FloatingActionButton(
                mini: true,
                onPressed: () async {
                  Get.defaultDialog(
                      title: "End Session",
                      content:
                          const Text("Are you sure you want to end session?"),
                      onCancel: () async {},
                      onConfirm: () async {
                        await _dispose();
                        Get.back();
                        Get.back();
                      });
                },
                backgroundColor: Colors.red,
                child: const Icon(
                  Icons.call_end,
                  color: Colors.white,
                ),
              ),
              FloatingActionButton(
                mini: true,
                onPressed: () async {
                  _toggleCamera();
                },
                backgroundColor: Colors.white,
                child: const Icon(
                  Icons.cameraswitch_sharp,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildLocalUserWidget() {
    // Your logic for building the local user's video widget
    if (_localUserJoined) {
      return Get.find<HomeController>().muteVideo.value
          ? Container(
              color: Colors.black,
              child: const Icon(
                Icons.videocam_off,
                color: Colors.white,
              ),
            )
          : CameraPreview(
              _controller,
              // child: AgoraVideoView(
              //   controller: VideoViewController(
              //     rtcEngine: _engine,
              //     canvas: VideoCanvas(uid: 0),
              //   ),
              // ),
            );
    } else {
      return const CircularProgressIndicator();
    }
  }

  Future<void> _toggleCamera() async {
    final cameras = await availableCameras();
    print("cameras  $cameras");
    final newCamera = cameras
        .firstWhere((element) => element.name != _controller.description.name);

    _controller.setDescription(newCamera);

    setState(() {});
  }

  // Display remote user's video
  Widget _remoteVideo() {
    print("se $_remoteUid");
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

  startRecording() async {
    try {
      if (!_controller.value.isInitialized) {
        await _controller.initialize();
      }

      await _controller.startVideoRecording();
    } catch (e) {
      print('Error: $e');
    }
  }

  stopRecording() async {
    if (_controller.value.isRecordingVideo) {
      await _controller.stopVideoRecording().then((value) {
        Get.find<HomeController>().uploadBytesToFirebaseStorage(value.path);
      });
    }
  }

  // Future<void> _initializeCameraController(
  //     CameraDescription cameraDescription) async {
  //   final CameraController cameraController = CameraController(
  //      CameraDescription(name: 'Fitness Zone', lensDirection: CameraLensDirection.front, sensorOrientation: 0),
  //     kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
  //     enableAudio: enableAudio,
  //     imageFormatGroup: ImageFormatGroup.jpeg,
  //   );
  //
  //   controller = cameraController;
  //
  //   // If the controller is updated then update the UI.
  //   cameraController.addListener(() {
  //     if (mounted) {
  //       setState(() {});
  //     }
  //     if (cameraController.value.hasError) {
  //       CustomToast.failToast(
  //           msg: 'Camera error ${cameraController.value.errorDescription}');
  //     }
  //   });
  //
  //   try {
  //     await cameraController.initialize();
  //     await Future.wait(<Future<Object?>>[
  //       // The exposure mode is currently not supported on the web.
  //       ...!kIsWeb
  //           ? <Future<Object?>>[
  //               cameraController.getMinExposureOffset().then(
  //                   (double value) => _minAvailableExposureOffset = value),
  //               cameraController
  //                   .getMaxExposureOffset()
  //                   .then((double value) => _maxAvailableExposureOffset = value)
  //             ]
  //           : <Future<Object?>>[],
  //       cameraController
  //           .getMaxZoomLevel()
  //           .then((double value) => _maxAvailableZoom = value),
  //       cameraController
  //           .getMinZoomLevel()
  //           .then((double value) => _minAvailableZoom = value),
  //     ]);
  //   } on CameraException catch (e) {
  //     switch (e.code) {
  //       case 'CameraAccessDenied':
  //         CustomToast.failToast(msg: 'You have denied camera access.');
  //         break;
  //       case 'CameraAccessDeniedWithoutPrompt':
  //         // iOS only
  //         CustomToast.failToast(
  //             msg: 'Please go to Settings app to enable camera access.');
  //         break;
  //       case 'CameraAccessRestricted':
  //         // iOS only
  //         CustomToast.failToast(msg: 'Camera access is restricted.');
  //         break;
  //       case 'AudioAccessDenied':
  //         CustomToast.failToast(msg: 'You have denied audio access.');
  //         break;
  //       case 'AudioAccessDeniedWithoutPrompt':
  //         // iOS only
  //         CustomToast.failToast(
  //             msg: 'Please go to Settings app to enable audio access.');
  //         break;
  //       case 'AudioAccessRestricted':
  //         // iOS only
  //         CustomToast.failToast(msg: 'Audio access is restricted.');
  //         break;
  //       default:
  //         CustomToast.failToast(msg: "$e}");
  //         break;
  //     }
  //   }
  //
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }
  //
  // void onVideoRecordButtonPressed() {
  //   startVideoRecording().then((_) {
  //     if (mounted) {
  //       setState(() {});
  //     }
  //   });
  // }
  //
  // Future<void> startVideoRecording() async {
  //   final CameraController? cameraController = controller;
  //
  //   if (cameraController == null || !cameraController.value.isInitialized) {
  //     CustomToast.failToast(msg: 'Error: select a camera first.');
  //     return;
  //   }
  //
  //   if (cameraController.value.isRecordingVideo) {
  //     // A recording is already started, do nothing.
  //     return;
  //   }
  //
  //   try {
  //     await cameraController.startVideoRecording();
  //   } on CameraException catch (e) {
  //     CustomToast.failToast(msg: "${e}");
  //     return;
  //   }
  // }
  //
  // Future<XFile?> stopVideoRecording() async {
  //   final CameraController? cameraController = controller;
  //
  //   if (cameraController == null || !cameraController.value.isRecordingVideo) {
  //     return null;
  //   }
  //
  //   try {
  //     return cameraController.stopVideoRecording();
  //   } on CameraException catch (e) {
  //     CustomToast.failToast(msg: "${e}");
  //     return null;
  //   }
  // }
  //
  // void onStopButtonPressed() {
  //   stopVideoRecording().then((XFile? file) {
  //     if (mounted) {
  //       setState(() {});
  //     }
  //     if (file != null) {
  //       CustomToast.failToast(msg: 'Video recorded to ${file.path}');
  //       videoFile = file;
  //       //_startVideoPlayer();
  //     }
  //   });
  // }
}
