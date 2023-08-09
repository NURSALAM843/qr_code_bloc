part of 'auth_bloc.dart';

abstract class AuthState {}

// state -> kondisi saat ini
//1.AuthStateLogin -> tidak terauthtentikasi
//3.AuthStateLogin ->  terauthtentikasi
//3.AuthStateLoading ->  Loading
//4.AuthStateError ->  Gagal Login

class AuthStateLogin extends AuthState {}

class AuthStateLoading extends AuthState {}

class AuthStateLogout extends AuthState {}

class AuthStateError extends AuthState {
  AuthStateError(this.message);

  final String message;
}
