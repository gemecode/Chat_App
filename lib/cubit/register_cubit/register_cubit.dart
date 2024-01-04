import 'package:chat_app/cubit/register_cubit/register_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  String? email;
  String? password;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> registerUser(
      {required String email, required String password}) async {
    emit(RegisterLoading());
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      print('########################################');
      print('Failed with error code: ${e.code}');
      print(' Failed with error message: ${e.message}');
      if (e.code == 'weak-password') {
        emit(RegisterFailure(error: 'The password provided is too weak'));
      } else if (e.code == 'email-already-in-use') {
        emit(RegisterFailure(
            error: 'The account already exists for that email'));
      } else {
        emit(RegisterFailure(
            error: 'There was an AuthException, please try again'));
      }
    } catch (e) {
      emit(RegisterFailure(error: 'There was an error, please try again'));
    }
  }
}
