import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnesss_app/data/controllers/auth_controller/auth_controller.dart';
import 'package:fitnesss_app/data/controllers/home_controller/home_controller.dart';
import 'package:fitnesss_app/values/my_colors.dart';
import 'package:fitnesss_app/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../data/GetServices/CheckConnectionService.dart';
import '../../../widgets/toasts.dart';

class ChatRoom extends StatefulWidget {
  final String chatRoomId;
  bool isUpdated = false;
  ChatRoom({required this.chatRoomId});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _animationController;

  //Mic
  late Animation<double> _micTranslateTop;
  late Animation<double> _micRotationFirst;
  late Animation<double> _micTranslateRight;
  late Animation<double> _micTranslateLeft;
  late Animation<double> _micRotationSecond;
  late Animation<double> _micTranslateDown;
  late Animation<double> _micInsideTrashTranslateDown;

  //Trash Can
  late Animation<double> _trashWithCoverTranslateTop;
  late Animation<double> _trashCoverRotationFirst;
  late Animation<double> _trashCoverTranslateLeft;
  late Animation<double> _trashCoverRotationSecond;
  late Animation<double> _trashCoverTranslateRight;
  late Animation<double> _trashWithCoverTranslateDown;
  CheckConnectionService connectionService = CheckConnectionService();

  bool temp = false;

  bool audio = false;

  int _limit = 20;

  int _limitIncrement = 20;

  List<QueryDocumentSnapshot> listMessage = [];

  late String recordFilePath;

  Stream<QuerySnapshot>? chatMessageStream;

  final ScrollController _scrollController = ScrollController();

  String groupChatId = "";

  bool isShowSticker = false;

  final FocusNode focusNode = FocusNode();

  String currentUserId = "";

  final TextEditingController _message = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  File? imageFile;

  File? videoFile;

  void onSendMessage() async {
    try {
      await connectionService.checkConnection().then((value) async {
        if (!value) {
          CustomToast.failToast(msg: "Check your internet connection");
        } else {
          if (_message.text.isEmpty) {
            CustomToast.failToast(msg: "Please enter some text");
          } else {

            await _firestore.collection(widget.chatRoomId).add({
              "sendBy": Get.find<AuthController>().logInUser!.fullName,
              "message": _message.text
            });
            _message.clear();
          }
        }
      });
    } catch (e) {
      CustomToast.failToast(
          msg: "Something went wrong, please try again later");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GetBuilder<HomeController>(builder: (homeController) {
      return GestureDetector(
          onTap: () {
            //    Get.find<AudioController>().selectedId="";
          },
          child: Scaffold(
            appBar: HelpingWidgets().appBarWidget(() {
              Get.back();
            }, text: "Chat Room"),
            body:
                // SingleChildScrollView(
                //     child:
                Column(
              children: [
                Expanded(
                  child: Container(
                    //height: size.height / 1.25,
                    width: size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream:
                          _firestore.collection(widget.chatRoomId).snapshots(),
                      builder: (BuildContext context, snapshot) {
                        print("snapshot $snapshot");
                        if (snapshot.data != null) {
                          var data = snapshot.data!.docs;
                          print("data  ${snapshot.data}");
                          return Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  shrinkWrap: false,
                                  reverse: true,
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> map =
                                        snapshot.data!.docs[index].data()
                                            as Map<String, dynamic>;
                                    return messages(
                                      size,
                                      map,
                                      context,
                                      index,
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                ),
                Container(
                  height: 48.h,
                  margin:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextFormField(
                          expands: true,
                          controller: _message,
                          //  cursorHeight: 30,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(5),
                            hintText: "Send Message ...",
                            hintStyle: TextStyle(
                              decoration: TextDecoration.none,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),

                      Container(
                        // padding: EdgeInsets.all(8),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: MyColors.buttonColor),
                        child: IconButton(
                            icon: Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 25.w,
                            ),
                            onPressed: onSendMessage),
                      )

                      //   );
                      // }),
                    ],
                  ),
                ),
              ],
            ),
            //    ),
          ));
    });
  }

  Widget messages(
      Size size, Map<String, dynamic> map, BuildContext context, int index) {

    return Container(
      width: size.width,
      alignment: map['sendBy'] == Get.find<AuthController>().logInUser!.fullName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 7, bottom: 5),
        margin: EdgeInsets.only(
            left: map['sendBy'] == Get.find<AuthController>().logInUser!.fullName ? 100 : 10,
            right: map['sendBy'] == Get.find<AuthController>().logInUser!.fullName ? 10 : 100,
            bottom: 5,
            top: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(8),
              topLeft: Radius.circular(8),
              bottomLeft: map['sendBy'] == Get.find<AuthController>().logInUser!.fullName
                  ? Radius.circular(8)
                  : Radius.circular(0),
              bottomRight: map['sendBy'] == Get.find<AuthController>().logInUser!.fullName
                  ? Radius.circular(0)
                  : Radius.circular(8)),
          color: Colors.blue,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              map['sendBy'],
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              map['message'],
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),


          ],
        ),
      ),
    );
  }
}
