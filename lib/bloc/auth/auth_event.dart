part of 'auth_bloc.dart';

abstract class AuthEvent {}
// state -> action/aksi/tindakan
//1.AuthEventLogout -> melakukan logout
//3.AuthEventLogin ->  melakukan login

class AuthEventLogin extends AuthEvent {
  AuthEventLogin(this.email, this.pass);
  final String email;
  final String pass;
}

class AuthEventLogout extends AuthEvent {}
