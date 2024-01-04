import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/cubit/register_cubit/register_cubit.dart';
import 'package:chat_app/cubit/register_cubit/register_state.dart';
import 'package:chat_app/helper/show_snack_bar.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_register_button.dart';
import 'package:chat_app/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<RegisterCubit>(context);

    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterLoading) {
          cubit.isLoading = true;
        } else if (state is RegisterSuccess) {
          showSnackBar(context, message: 'Success Registration');
          cubit.isLoading = false;
        } else if (state is RegisterFailure) {
          showSnackBar(context, message: state.error);
          cubit.isLoading = false;
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: cubit.isLoading,
          child: Scaffold(
            backgroundColor: AppColors.primaryColor,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Form(
                key: cubit.formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 75),
                    Image.asset(
                      'assets/images/scholar.png',
                      height: 100,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Scholar Chat',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontFamily: 'Pacifico'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 75),
                    const Row(
                      children: [
                        Text(
                          'REGISTER',
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      hintText: 'email',
                      onChanged: (data) {
                        cubit.email = data;
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      hintText: 'password',
                      obscureText: true,
                      onChanged: (data) {
                        cubit.password = data;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      txt: 'REGISTER',
                      onTap: () async {
                        if (cubit.formKey.currentState!.validate()) {
                          cubit.registerUser(
                              email: cubit.email!, password: cubit.password!);
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomRegisterButton(
                      txt: 'already have an account?',
                      txtBtn: '  Login',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
