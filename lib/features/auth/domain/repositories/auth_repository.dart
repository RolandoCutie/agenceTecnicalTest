import '../entities/auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser?> signInWithGoogle();
  Future<AuthUser?> signInWithFacebook();
  Future<void> signOut();
}
