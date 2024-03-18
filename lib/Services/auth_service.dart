import 'package:a/Services/auth_provider.dart';
import 'package:a/Services/auth_user.dart';
import 'package:a/Services/firebase_auth_providers.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;

  AuthService(this.provider);
  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) =>
      provider.login(
        email: email,
        password: password,
      );

  @override
  Future<void> logout() => provider.logout();

  @override
  Future<AuthUser> register({
    required String email,
    required String password,
  }) =>
      provider.register(
        email: email,
        password: password,
      );
  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initialize() => provider.initialize();
}
