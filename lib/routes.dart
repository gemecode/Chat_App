import 'package:chat_app/constants/app_routes.dart';
import 'package:chat_app/views/chat_view.dart';
import 'package:chat_app/views/login_view.dart';
import 'package:chat_app/views/register_view.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> routes = {
  AppRoutes.loginView: (context) => const LoginView(),
  AppRoutes.registerView: (context) => const RegisterView(),
  AppRoutes.chatView: (context) => const ChatView(),
};
