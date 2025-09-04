abstract class AuthState {}
class LoginState extends AuthState {}

class LoginErrorState extends AuthState {
  final String message;
  LoginErrorState(this.message);
}
class SignupState extends AuthState {}
class SignupErrorState extends AuthState {
  final String message;
  SignupErrorState(this.message);
}
class OtpState extends AuthState {
  final String email;
  OtpState(this.email);
}
class OTPErrorState extends AuthState {
  final String message;
  OTPErrorState(this.message);
}
class Authenticated extends AuthState {
  final String email;
  Authenticated(this.email);
}