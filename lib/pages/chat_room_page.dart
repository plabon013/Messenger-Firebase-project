import 'package:firebase_batch6/providers/chat_room_provider.dart';
import 'package:firebase_batch6/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/message_item.dart';

class ChatRoomPage extends StatefulWidget {
  static const String routeName = '/chat_room';

  const ChatRoomPage({Key? key}) : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  bool isFirst = true;
  final txtController = TextEditingController();

  @override
  void dispose() {
    txtController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (isFirst) {
      Provider.of<ChatRoomProvider>(context, listen: false)
          .getChatRoomMessages();
      isFirst = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      drawer: const MainDrawer(),
      appBar: AppBar(
        elevation: 0,
        title: const Text('Chat Room'),
      ),
      body: Consumer<ChatRoomProvider>(
        builder: (context, provider, _) => Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: provider.msgList.length,
                itemBuilder: (context, index) {
                  final messageModel = provider.msgList[index];
                  return MessageItem(messageModel: messageModel);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      //keyboardType: TextInputType.text,
                      controller: txtController,
                      decoration: InputDecoration(
                        filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          hintText: 'Type your message here'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if(txtController.text.isEmpty) return;
                      provider.addMessage(txtController.text);
                      txtController.clear();
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
