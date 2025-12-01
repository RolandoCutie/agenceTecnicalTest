import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class SignInWithFacebook {
  final AuthRepository repository;
  SignInWithFacebook(this.repository);

  Future<AuthUser?> call() => repository.signInWithFacebook();
}
