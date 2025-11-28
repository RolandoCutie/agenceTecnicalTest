import 'package:mobx/mobx.dart';

import '../../domain/entities/auth_user.dart';
import '../../domain/usecases/sign_in_with_facebook.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_out.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  final SignInWithGoogle _signInWithGoogle;
  final SignInWithFacebook _signInWithFacebook;
  final SignOut _signOut;

  _AuthStore(this._signInWithGoogle, this._signInWithFacebook, this._signOut);

  @observable
  bool isLoading = false;

  @observable
  AuthUser? currentUser;

  @observable
  String? error;

  @action
  Future<bool> signInGoogle() async {
    isLoading = true;
    error = null;
    try {
      currentUser = await _signInWithGoogle();
      if (currentUser == null) {
        error = 'Google sign-in was cancelled or failed.';
        return false;
      }
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> signInFacebook() async {
    isLoading = true;
    error = null;
    try {
      currentUser = await _signInWithFacebook();
      if (currentUser == null) {
        error = 'Facebook sign-in was cancelled or failed.';
        return false;
      }
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> signOut() async {
    isLoading = true;
    try {
      await _signOut();
      currentUser = null;
    } finally {
      isLoading = false;
    }
  }
}
