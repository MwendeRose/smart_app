// lib/services/auth_service.dart
//
// ── SETUP INSTRUCTIONS ────────────────────────────────────────
// This file works in TWO modes:
//
// MODE 1 (current) — No Firebase, compiles immediately.
//   Auth is mocked so you can build the full UI right now.
//
// MODE 2 — Real Firebase (when you're ready):
//   1. Run:  flutter pub add firebase_core firebase_auth
//                          google_sign_in shared_preferences
//   2. Follow: https://firebase.google.com/docs/flutter/setup
//   3. In this file: set  _useFirebase = true  (line 23)
//      and uncomment the three import lines below.
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/foundation.dart';

// ─── toggle ──────────────────────────────────────────────────
// Set to true once Firebase is installed & configured.
const bool _useFirebase = false;

// ─── User model ───────────────────────────────────────────────

class AppUser {
  final String name;
  final String email;
  final String role;
  final String phone;

  const AppUser({
    required this.name,
    required this.email,
    this.role  = 'System Administrator',
    this.phone = '',
  });

  String get firstName => name.split(' ').first;

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  AppUser copyWith({String? name, String? email, String? role, String? phone}) {
    return AppUser(
      name:  name  ?? this.name,
      email: email ?? this.email,
      role:  role  ?? this.role,
      phone: phone ?? this.phone,
    );
  }
}

// ─── AuthService ─────────────────────────────────────────────

class AuthService extends ChangeNotifier {
  // ── Singleton ─────────────────────────────────────────────
  AuthService._internal();
  static final AuthService instance = AuthService._internal();
  factory AuthService() => instance;

  // ── State ─────────────────────────────────────────────────
  bool     loading    = false;
  bool     isLoggedIn = false;
  AppUser? user;

  // ── Init: restore saved session ───────────────────────────
  Future<void> init() async {
    if (!_useFirebase) {
      // Mock: nothing to restore
      return;
    }

    // ── Firebase (uncomment when _useFirebase = true) ────────
    // final firebaseUser = FirebaseAuth.instance.currentUser;
    // if (firebaseUser != null) {
    //   final prefs = await SharedPreferences.getInstance();
    //   user = AppUser(
    //     name:  firebaseUser.displayName
    //            ?? firebaseUser.email!.split('@').first,
    //     email: firebaseUser.email ?? '',
    //     role:  prefs.getString('user_role')  ?? 'System Administrator',
    //     phone: prefs.getString('user_phone') ?? '',
    //   );
    //   isLoggedIn = true;
    //   notifyListeners();
    // }
  }

  // ── Email / password login ────────────────────────────────
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      if (!_useFirebase) {
        // ── Mock login ───────────────────────────────────────
        await Future.delayed(const Duration(milliseconds: 800));
        if (password.length < 6) return 'Incorrect password.';
        user = AppUser(name: email.split('@').first, email: email);
        isLoggedIn = true;
        notifyListeners();
        return null;
      }

      // ── Firebase (uncomment when _useFirebase = true) ────────
      // final result = await FirebaseAuth.instance
      //     .signInWithEmailAndPassword(email: email, password: password);
      // final prefs = await SharedPreferences.getInstance();
      // user = AppUser(
      //   name:  result.user?.displayName ?? email.split('@').first,
      //   email: result.user?.email ?? email,
      //   role:  prefs.getString('user_role')  ?? 'System Administrator',
      //   phone: prefs.getString('user_phone') ?? '',
      // );
      // isLoggedIn = true;
      // notifyListeners();
      // return null;

      return null;
    } on Exception catch (e) {
      return _parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  // ── Email / password sign-up ──────────────────────────────
  Future<String?> signUp({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    _setLoading(true);
    try {
      if (!_useFirebase) {
        // ── Mock sign-up ─────────────────────────────────────
        await Future.delayed(const Duration(milliseconds: 800));
        user = AppUser(name: name, email: email, phone: phone ?? '');
        isLoggedIn = true;
        notifyListeners();
        return null;
      }

      // ── Firebase (uncomment when _useFirebase = true) ────────
      // final result = await FirebaseAuth.instance
      //     .createUserWithEmailAndPassword(email: email, password: password);
      // await result.user?.updateDisplayName(name);
      // user = AppUser(name: name, email: email, phone: phone ?? '');
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setString('user_phone', phone ?? '');
      // isLoggedIn = true;
      // notifyListeners();
      // return null;

      return null;
    } on Exception catch (e) {
      return _parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  // ── Google Sign-In ────────────────────────────────────────
  Future<String?> signInWithGoogle() async {
    _setLoading(true);
    try {
      if (!_useFirebase) {
        await Future.delayed(const Duration(milliseconds: 800));
        return 'Google Sign-In requires Firebase. Set _useFirebase = true.';
      }

      // ── Firebase (uncomment when _useFirebase = true) ────────
      // final googleUser = await GoogleSignIn().signIn();
      // if (googleUser == null) return 'Google sign-in cancelled.';
      // final googleAuth = await googleUser.authentication;
      // final credential = GoogleAuthProvider.credential(
      //   accessToken: googleAuth.accessToken,
      //   idToken:     googleAuth.idToken,
      // );
      // final result = await FirebaseAuth.instance
      //     .signInWithCredential(credential);
      // final prefs = await SharedPreferences.getInstance();
      // user = AppUser(
      //   name:  result.user?.displayName ?? googleUser.displayName ?? 'User',
      //   email: result.user?.email ?? googleUser.email,
      //   role:  prefs.getString('user_role')  ?? 'System Administrator',
      //   phone: prefs.getString('user_phone') ?? '',
      // );
      // isLoggedIn = true;
      // notifyListeners();
      // return null;

      return null;
    } on Exception catch (e) {
      return _parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  // ── Reset password (forgot password) ─────────────────────
  Future<String?> resetPassword({required String email}) async {
    _setLoading(true);
    try {
      if (email.trim().isEmpty) return 'Please enter your email address.';
      if (!email.contains('@')) return 'Please enter a valid email address.';

      if (!_useFirebase) {
        // ── Mock: simulate sending reset email ───────────────
        await Future.delayed(const Duration(milliseconds: 900));
        return null; // null = success
      }

      // ── Firebase (uncomment when _useFirebase = true) ────────
      // await FirebaseAuth.instance.sendPasswordResetEmail(
      //   email: email.trim(),
      // );
      // return null;

      return null;
    } on Exception catch (e) {
      return _parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  // ── Update profile / password ─────────────────────────────
  Future<String?> updateProfile({
    String? name,
    String? phone,
    String? role,
    String? password,
  }) async {
    _setLoading(true);
    try {
      if (!_useFirebase) {
        // ── Mock update ──────────────────────────────────────
        await Future.delayed(const Duration(milliseconds: 600));
        if (user != null) {
          user = user!.copyWith(name: name, phone: phone, role: role);
          notifyListeners();
        }
        return null;
      }

      // ── Firebase (uncomment when _useFirebase = true) ────────
      // final firebaseUser = FirebaseAuth.instance.currentUser;
      // if (firebaseUser == null) return 'Not logged in.';
      // if (password != null && password.isNotEmpty) {
      //   await firebaseUser.updatePassword(password);
      // }
      // if (name != null && name.isNotEmpty) {
      //   await firebaseUser.updateDisplayName(name);
      // }
      // if (user != null) {
      //   user = user!.copyWith(name: name, phone: phone, role: role);
      //   final prefs = await SharedPreferences.getInstance();
      //   await prefs.setString('user_role',  user!.role);
      //   await prefs.setString('user_phone', user!.phone);
      //   notifyListeners();
      // }
      // return null;

      return null;
    } on Exception catch (e) {
      return _parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  // ── Sign out ──────────────────────────────────────────────
  Future<void> signOut() async {
    _setLoading(true);
    try {
      if (_useFirebase) {
        // await FirebaseAuth.instance.signOut();
        // await GoogleSignIn().signOut();
      }
      await Future.delayed(const Duration(milliseconds: 300));
      user       = null;
      isLoggedIn = false;
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // ── Error parser ──────────────────────────────────────────
  String _parseError(Exception e) {
    final msg = e.toString();
    // Firebase error codes (active when _useFirebase = true)
    if (msg.contains('user-not-found'))     return 'No account found with that email.';
    if (msg.contains('wrong-password'))     return 'Incorrect password.';
    if (msg.contains('invalid-credential')) return 'Invalid email or password.';
    if (msg.contains('email-already-in-use')) return 'An account with that email already exists.';
    if (msg.contains('weak-password'))      return 'Password must be at least 6 characters.';
    if (msg.contains('invalid-email'))      return 'Please enter a valid email address.';
    if (msg.contains('too-many-requests'))  return 'Too many attempts. Try again later.';
    if (msg.contains('network-request-failed')) return 'Network error. Check your connection.';
    if (msg.contains('requires-recent-login')) {
      return 'Please sign out and sign in again before changing your password.';
    }
    return 'Something went wrong. Please try again.';
  }

  // ── Helper ────────────────────────────────────────────────
  void _setLoading(bool value) {
    loading = value;
    notifyListeners();
  }
}