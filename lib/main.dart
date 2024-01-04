import 'package:chat_app/constants/app_routes.dart';
import 'package:chat_app/cubit/chat_cubit/chat_cubit.dart';
import 'package:chat_app/cubit/login_cubit/login_cubit.dart';
import 'package:chat_app/cubit/register_cubit/register_cubit.dart';
import 'package:chat_app/helper/shared_pref.dart';
import 'package:chat_app/routes.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesManager().init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => RegisterCubit()),
        BlocProvider(create: (context) => ChatCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: routes,
        initialRoute: AppRoutes.loginView,
      ),
    );
  }
}
