import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interviews_flutter_assignment/core/utils/auth_preferences.dart';
import 'package:interviews_flutter_assignment/data/datasources/user_local_data_source.dart';
import 'package:interviews_flutter_assignment/presentation/auth/bloc/event.dart';
import 'package:interviews_flutter_assignment/presentation/auth/bloc/state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(LoginState()) {

    on<ShowLogin>((event, emit) => emit(LoginState()));
    on<ShowSignup>((event, emit) => emit(SignupState()));


    on<ShowOtp>((event, emit) async {
      await AuthDatabase.insertOtp(event.email, "12345");
      emit(OtpState(event.email));
    });


    on<LoginSubmitted>((event, emit) async {
      final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
      if (!emailRegex.hasMatch(event.email)) {
        emit(LoginErrorState("Invalid email format"));
        return;
      }
      if (event.password.length < 6) {
        emit(LoginErrorState("Password must be at least 6 characters"));
        return;
      }

      final user = await AuthDatabase.getUser(event.email);
      if (user != null && user['password'] == event.password) {

        add(ShowOtp(event.email));
      } else {
        emit(LoginErrorState("Email or password is incorrect"));
      }
    });

    on<SignupSubmitted>((event, emit) async {
      final email = event.email.trim();
      final password = event.password.trim();

      if (email.isEmpty) {
        emit(SignupErrorState("Email is required"));
        return;
      }
      if (password.isEmpty) {
        emit(SignupErrorState("Password is required"));
        return;
      }
      final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
      if (!emailRegex.hasMatch(email)) {
        emit(SignupErrorState("Invalid email format"));
        return;
      }
      if (password.length < 6) {
        emit(SignupErrorState("Password must be at least 6 characters"));
        return;
      }

      final user = await AuthDatabase.getUser(email);
      if (user != null) {
        emit(SignupErrorState("Email is already registered"));
        return;
      }

      _pendingSignupEmail = email;
      _pendingSignupPassword = password;

      add(ShowOtp(email));
    });

    on<OtpSubmitted>((event, emit) async {
      final valid = await AuthDatabase.verifyOtp(event.email, event.code);
      if (valid) {
     
        if (_pendingSignupEmail != null && _pendingSignupEmail == event.email) {
          await AuthDatabase.insertUser(_pendingSignupEmail!, _pendingSignupPassword!);
          _pendingSignupEmail = null;
          _pendingSignupPassword = null;
        }

        await AuthPreferences.saveUserEmail(event.email);

        emit(Authenticated(event.email));
      } else {
        emit(OTPErrorState("Invalid OTP, please try again"));
      }
    });


    on<Logout>((event, emit) async {
      await AuthPreferences.clearUserEmail();
      emit(LoginState());
    });
  }

 
  String? _pendingSignupEmail;
  String? _pendingSignupPassword;
}
