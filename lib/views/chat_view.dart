import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/constants/app_images.dart';
import 'package:chat_app/cubit/chat_cubit/chat_cubit.dart';
import 'package:chat_app/cubit/chat_cubit/chat_state.dart';
import 'package:chat_app/helper/shared_pref.dart';
import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  void initState() {
    super.initState();
    var cubit = BlocProvider.of<ChatCubit>(context);
    cubit.getMessages();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<ChatCubit>(context);
    String email = SharedPreferencesManager().getString('email');

    void onSubmitted(String data) {
      cubit.sendMessage(data: data, email: email);
      cubit.textController.clear();
      // scrollController.jumpTo(scrollController.position.maxScrollExtent);
      cubit.scrollController.animateTo(
          // scrollController.position.maxScrollExtent,
          0,
          duration: const Duration(seconds: 1),
          curve: Curves.easeIn);
    }

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
        body: Column(
          children: [
            Expanded(
              child:
                  BlocBuilder<ChatCubit, ChatState>(builder: (context, state) {
                return ListView.builder(
                    reverse: true,
                    controller: cubit.scrollController,
                    itemCount: cubit.messagesList.length,
                    itemBuilder: (context, index) {
                      return cubit.messagesList[index].email == email
                          ? ChatBubble(
                              messageModel: cubit.messagesList[index],
                            )
                          : ChatBubbleForFriend(
                              messageModel: cubit.messagesList[index]);
                    });
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: cubit.textController,
                onSubmitted: (data) {
                  data != '' ? onSubmitted(data) : data = '';
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
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        cubit.textController.text != ''
                            ? onSubmitted(cubit.textController.text)
                            : cubit.textController.text = '';
                      },
                      color: AppColors.primaryColor,
                    ),
                    hintText: 'Send Message'),
              ),
            )
          ],
        ));
  }
}
