abstract class AuthEvent {}
class ShowLogin extends AuthEvent {}
class ShowSignup extends AuthEvent {}
class ShowOtp extends AuthEvent {
  final String email;
  ShowOtp(this.email);
}
class LoginSubmitted extends AuthEvent {
  final String email, password;
  LoginSubmitted(this.email, this.password);
}
class SignupSubmitted extends AuthEvent {
  final String email, password;
  SignupSubmitted(this.email, this.password);
}
class OtpSubmitted extends AuthEvent {
  final String email, code;
  OtpSubmitted(this.email, this.code);
}
class Logout extends AuthEvent {} 