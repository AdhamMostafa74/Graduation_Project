import 'package:a/Services/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;

  Future<AuthUser> login({
    required String email,
    required String password,
  });
  Future<AuthUser> register({
    required String email,
    required String password,
  });
  Future<void> sendEmailVerification();
  Future<void> logout();
}
