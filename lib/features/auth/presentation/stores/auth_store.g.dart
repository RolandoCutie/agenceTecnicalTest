// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthStore on _AuthStore, Store {
  Computed<String>? _$displayNameComputed;

  @override
  String get displayName => (_$displayNameComputed ??= Computed<String>(
    () => super.displayName,
    name: '_AuthStore.displayName',
  )).value;

  late final _$isLoadingAtom = Atom(
    name: '_AuthStore.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$currentUserAtom = Atom(
    name: '_AuthStore.currentUser',
    context: context,
  );

  @override
  AuthUser? get currentUser {
    _$currentUserAtom.reportRead();
    return super.currentUser;
  }

  @override
  set currentUser(AuthUser? value) {
    _$currentUserAtom.reportWrite(value, super.currentUser, () {
      super.currentUser = value;
    });
  }

  late final _$errorAtom = Atom(name: '_AuthStore.error', context: context);

  @override
  String? get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String? value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$signInGoogleAsyncAction = AsyncAction(
    '_AuthStore.signInGoogle',
    context: context,
  );

  @override
  Future<bool> signInGoogle() {
    return _$signInGoogleAsyncAction.run(() => super.signInGoogle());
  }

  late final _$signInFacebookAsyncAction = AsyncAction(
    '_AuthStore.signInFacebook',
    context: context,
  );

  @override
  Future<bool> signInFacebook() {
    return _$signInFacebookAsyncAction.run(() => super.signInFacebook());
  }

  late final _$signOutAsyncAction = AsyncAction(
    '_AuthStore.signOut',
    context: context,
  );

  @override
  Future<void> signOut() {
    return _$signOutAsyncAction.run(() => super.signOut());
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
currentUser: ${currentUser},
error: ${error},
displayName: ${displayName}
    ''';
  }
}
