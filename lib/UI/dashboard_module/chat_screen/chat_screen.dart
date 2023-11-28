import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:http/http.dart' as http;
import 'package:fitnesss_app/data/controllers/auth_controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:uuid/uuid.dart';

import '../../../values/constants.dart';
import '../../../widgets/app_bar_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {Key? key,
      required this.title,
      required this.remoteId,
      required this.channelName,
      required this.currentUserId,
      required this.token})
      : super(key: key);

  final String title;
  final String remoteId;
  final String channelName;
  final String currentUserId;
  final String token;

  @override
  State<ChatScreen> createState() => _ChatScreen();
}

class _ChatScreen extends State<ChatScreen> {
  ScrollController scrollController = ScrollController();
  AuthController authController = Get.find();
  var uuid = const Uuid();

  String _messageContent = "";
  // String _chatId = "";
  final List<String> _logText = [];

  @override
  void initState() {
    super.initState();
    _addChatListener();
    _signIn();
   // generateToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HelpingWidgets().appBarWidget(() {
        Get.back();
      }, text: "All Users"),
      body: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            TextField(
              decoration: const InputDecoration(hintText: "Enter content"),
              onChanged: (msg) => _messageContent = msg,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _sendMessage,
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.white),
                backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
              ),
              child: const Text("SEND TEXT"),
            ),
            Flexible(
              child: ListView.builder(
                controller: scrollController,
                itemBuilder: (_, index) {
                  return Text(_logText[index]);
                },
                itemCount: _logText.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    ChatClient.getInstance.chatManager.removeMessageEvent("UNIQUE_HANDLER_ID");
    ChatClient.getInstance.chatManager.removeEventHandler("UNIQUE_HANDLER_ID");
    super.dispose();
  }

  void _addChatListener() {
    var messageId = uuid.v4();
    ChatClient.getInstance.chatManager.addMessageEvent(
        "UNIQUE_HANDLER_ID",
        ChatMessageEvent(
          onSuccess: (msgId, msg) {
            _addLogToConsole("on message succeed");
          },
          onProgress: (msgId, progress) {
            _addLogToConsole("on message progress");
          },
          onError: (msgId, msg, error) {
            _addLogToConsole(
              "on message failed, code: ${error.code}, desc: ${error.description}",
            );
          },
        ));

    ChatClient.getInstance.chatManager.addEventHandler(
      "UNIQUE_HANDLER_ID",
      ChatEventHandler(
        onMessagesReceived: (messages) {
          for (var msg in messages) {
            switch (msg.body.type) {
              case MessageType.TXT:
                {
                  ChatTextMessageBody body = msg.body as ChatTextMessageBody;
                  _addLogToConsole(
                    "receive text message: ${body.content}, from: ${msg.from}",
                  );
                }
                break;
              case MessageType.IMAGE:
                {
                  _addLogToConsole(
                    "receive image message, from: ${msg.from}",
                  );
                }
                break;
              case MessageType.VIDEO:
                {
                  _addLogToConsole(
                    "receive video message, from: ${msg.from}",
                  );
                }
                break;
              case MessageType.LOCATION:
                {
                  _addLogToConsole(
                    "receive location message, from: ${msg.from}",
                  );
                }
                break;
              case MessageType.VOICE:
                {
                  _addLogToConsole(
                    "receive voice message, from: ${msg.from}",
                  );
                }
                break;
              case MessageType.FILE:
                {
                  ChatClient.getInstance.chatManager.downloadAttachment(msg);
                  _addLogToConsole(
                    "receive file message, from: ${msg.from}",
                  );
                }
                break;
              case MessageType.CUSTOM:
                {
                  _addLogToConsole(
                    "receive custom message, from: ${msg.from}",
                  );
                }
                break;
              case MessageType.CMD:
                {
                }
                break;
            }
          }
        },
      ),
    );
  }

  void _signIn() async {
    // if (_userId.isEmpty || _password.isEmpty) {
    //   _addLogToConsole("username or password is null");
    //   return;
    // }

    try {
      await ChatClient.getInstance.loginWithAgoraToken(
          authController.logInUser!.fullName, widget.token);
      _addLogToConsole(
          "sign in succeed, username: ${authController.logInUser!.fullName}");
    } on ChatError catch (e) {
      _addLogToConsole("sign in failed, e: ${e.code} , ${e.description}");
      _signUp();
    }
  }

  void _signOut() async {
    try {
      await ChatClient.getInstance.logout(true);
      _addLogToConsole("sign out succeed");
    } on ChatError catch (e) {
      _addLogToConsole(
          "sign out failed, code: ${e.code}, desc: ${e.description}");
    }
  }

  void _signUp() async {
    // if (_userId.isEmpty || _password.isEmpty) {
    //   _addLogToConsole("username or password is null");
    //   return;
    // }

    try {
      await ChatClient.getInstance.createAccount(
          authController.logInUser!.fullName,
          authController.logInUser!.password);
      _addLogToConsole(
          "sign up succeed, username: ${authController.logInUser!.fullName}");
    } on ChatError catch (e) {
      _addLogToConsole("sign up failed, e: ${e.code} , ${e.description}");
    }
  }

  // generateToken() async {
  //   var response = await http.post(
  //       Uri.parse(
  //           "https://a41.chat.agora.io/v1/apps/${Constants.appID}/chat/token"),
  //       body: {"username": "ab", "role": "publisher "},
  //       headers: {"Authorization": "71a1aa7106d9447ba8e10ffcee0a2545"});
  //   print("response${response.body}");
  // }

  void _sendMessage() async {
    if (widget.remoteId.isEmpty || _messageContent.isEmpty) {
      _addLogToConsole("single chat id or message content is null");
      return;
    }

    var msg = ChatMessage.createTxtSendMessage(
      targetId: widget.remoteId,
      content: _messageContent,
    );

    ChatClient.getInstance.chatManager.sendMessage(msg);
  }

  void _addLogToConsole(String log) {
    _logText.add("$_timeString: $log");
    setState(() {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  String get _timeString {
    return DateTime.now().toString().split(".").first;
  }
}
