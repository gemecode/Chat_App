import 'package:chat_app/cubit/login_cubit/login_state.dart';
import 'package:chat_app/helper/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool isLoading = false;

  Future<void> signInUser(
      {required String email, required String password}) async {
    emit(LoginLoading());
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      SharedPreferencesManager().setString('email', email);
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      print('########################################');
      print('Failed with error code: ${e.code}');
      print(' Failed with error message: ${e.message}');
      if (e.code == 'user-not-found') {
        emit(LoginFailure(error: 'No user found for that email'));
      } else if (e.code == 'wrong-password') {
        emit(LoginFailure(error: 'Wrong password provided for that user'));
      } else if (e.code == 'invalid-email') {
        emit(LoginFailure(error: 'Invalid Email'));
      } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        emit(LoginFailure(error: 'INVALID LOGIN CREDENTIALS'));
      } else {
        emit(LoginFailure(
            error: 'There was an AuthException, please try again'));
      }
    } catch (e) {
      emit(LoginFailure(error: 'There was an error, please try again'));
    }
  }
}
