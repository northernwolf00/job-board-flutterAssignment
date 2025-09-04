import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interviews_flutter_assignment/presentation/auth/bloc/bloc.dart';
import 'package:interviews_flutter_assignment/presentation/auth/bloc/state.dart';
import 'package:interviews_flutter_assignment/presentation/auth/widgets/login_widget.dart';
import 'package:interviews_flutter_assignment/presentation/auth/widgets/otp_widget.dart';
import 'package:interviews_flutter_assignment/presentation/auth/widgets/register_widget.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
        
          if (state is LoginState || state is LoginErrorState) {
            return LoginWidget(); 
          }
          if (state is SignupState || state is SignupErrorState) {
            return SignupWidget();
          }
          if (state is OtpState || state is OTPErrorState) {
            final email = state is OtpState ? state.email : (state as OTPErrorState).message;
            return OtpWidget(email: email);
          }

          return Container();
        },
      ),
    );
  }
}
