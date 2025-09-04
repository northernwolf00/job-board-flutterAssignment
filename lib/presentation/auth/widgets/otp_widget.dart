import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:interviews_flutter_assignment/presentation/auth/bloc/bloc.dart';
import 'package:interviews_flutter_assignment/presentation/auth/bloc/event.dart';
import 'package:interviews_flutter_assignment/presentation/auth/bloc/state.dart';

class OtpWidget extends StatelessWidget {
  final String email;
  OtpWidget({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          String? otpError;
          if (state is OTPErrorState) {
            otpError = state.message;
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Enter OTP sent to $email'),
              SizedBox(height: 16),
              OtpTextField(
                numberOfFields: 5,
                borderColor: Colors.deepPurple,
                showFieldAsBox: true,
                onCodeChanged: (_) {},
                onSubmit: (code) {
                  context.read<AuthBloc>().add(OtpSubmitted(email, code));
                },
              ),
              if (otpError != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(otpError, style: TextStyle(color: Colors.red)),
                ),
              SizedBox(height: 16),
              ElevatedButton(onPressed: () {}, child: Text('Verify OTP')),
            ],
          );
        },
      ),
    );
  }
}
