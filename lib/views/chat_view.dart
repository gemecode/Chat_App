import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/constants/app_images.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatView extends StatelessWidget {
  ChatView({super.key});

  CollectionReference message =
      FirebaseFirestore.instance.collection('messages');
  TextEditingController textController = TextEditingController();
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              height: 60,
              AppImages.scholarLogo,
            ),
            const Text(
              'Chat',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: message.orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<MessageModel> messagesList = [];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              messagesList.add(MessageModel.fromJson(snapshot.data!.docs[i]));
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      reverse: true,
                      controller: scrollController,
                      itemCount: messagesList.length,
                      itemBuilder: (context, index) {
                        return messagesList[index].email == email
                            ? ChatBubble(
                                messageModel: messagesList[index],
                              )
                            : ChatBubbleForFriend(
                                messageModel: messagesList[index]);
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: textController,
                    onSubmitted: (data) {
                      message.add(
                        {
                          'message': data,
                          'createdAt': DateTime.now(),
                          'email': email
                        },
                      );
                      textController.clear();
                      // scrollController.jumpTo(scrollController.position.maxScrollExtent);
                      scrollController.animateTo(
                          // scrollController.position.maxScrollExtent,
                          0,
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeIn);
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                          ),
                        ),
                        suffixIcon: const Icon(
                          Icons.send,
                          color: AppColors.primaryColor,
                        ),
                        hintText: 'Send Message'),
                  ),
                )
              ],
            );
          } else {
            return const Text('Loading...');
          }
        },
      ),
    );
  }
}
