import 'package:chat_app/cubit/chat_cubit/chat_state.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  List<MessageModel> messagesList = [];

  CollectionReference message =
      FirebaseFirestore.instance.collection('messages');
  TextEditingController textController = TextEditingController();
  ScrollController scrollController = ScrollController();

  sendMessage({required String data, required String email}) {
    try {
      message.add(
        {'message': data, 'createdAt': DateTime.now(), 'email': email},
      );
    } on Exception catch (e) {
      print(e);
    }
  }

  getMessages() {
    message.orderBy('createdAt', descending: true).snapshots().listen((event) {
      messagesList.clear();
      for (var doc in event.docs) {
        messagesList.add(MessageModel.fromJson(doc));
      }
      emit(ChatSuccess());
    });
  }
}
