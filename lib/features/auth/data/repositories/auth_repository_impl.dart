import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth;
  final fb.FirebaseAuth _firebaseAuth = fb.FirebaseAuth.instance;

  AuthRepositoryImpl({GoogleSignIn? googleSignIn, FacebookAuth? facebookAuth})
    : _googleSignIn = googleSignIn ?? GoogleSignIn(scopes: const ['email']),
      _facebookAuth = facebookAuth ?? FacebookAuth.instance;

  @override
  Future<AuthUser?> signInWithGoogle() async {
    try {
      // Force account chooser each time
      await _googleSignIn.signOut();
      final account = await _googleSignIn.signIn();
      if (account == null) return null;
      final auth = await account.authentication;
      final credential = fb.GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );
      final userCred = await _firebaseAuth.signInWithCredential(credential);
      final u = userCred.user;
      if (u == null) return null;
      return AuthUser(
        id: u.uid,
        name: u.displayName ?? 'User',
        email: u.email ?? '',
      );
    } on PlatformException catch (e) {
      throw Exception(_mapGoogleError(e));
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<AuthUser?> signInWithFacebook() async {
    final result = await _facebookAuth.login(
      permissions: const ['email', 'public_profile'],
    );
    if (result.status != LoginStatus.success) return null;
    final token = result.accessToken?.token;
    if (token == null) return null;
    final credential = fb.FacebookAuthProvider.credential(token);
    final userCred = await _firebaseAuth.signInWithCredential(credential);
    final u = userCred.user;
    if (u == null) return null;
    return AuthUser(
      id: u.uid,
      name: u.displayName ?? 'User',
      email: u.email ?? '',
    );
  }

  @override
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    try {
      await _facebookAuth.logOut();
    } catch (_) {}
    try {
      await _firebaseAuth.signOut();
    } catch (_) {}
  }

  String _mapGoogleError(PlatformException e) {
    final code = e.code; // Usually 'sign_in_failed'
    final details = e.details?.toString() ?? '';
    if (details.contains('10:')) {
      return 'Google sign-in failed (code 10: DEVELOPER_ERROR). Check SHA-1 and OAuth client configuration.';
    }
    if (details.contains('12500')) {
      return 'Google sign-in failed (12500). Verify Google Play Services and OAuth client settings.';
    }
    if (details.contains('12501')) {
      return 'Google sign-in cancelled by user.';
    }
    if (details.contains('7:')) {
      return 'Network error during Google sign-in. Check connection.';
    }
    return 'Google sign-in error: ${e.message ?? code}';
  }
}
