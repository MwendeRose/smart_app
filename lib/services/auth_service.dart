// lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

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

  // ── Google Sign-In (only used on Android/iOS) ─────────────
  GoogleSignIn? _googleSignInInstance;
  GoogleSignIn get _googleSignIn {
    _googleSignInInstance ??= GoogleSignIn();
    return _googleSignInInstance!;
  }

  // ── State ─────────────────────────────────────────────────
  bool     loading    = false;
  bool     isLoggedIn = false;
  AppUser? user;
  String?  lastError;

  // ── Init: restore saved session ───────────────────────────
  Future<void> init() async {
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        final prefs = await SharedPreferences.getInstance();
        user = AppUser(
          name:  firebaseUser.displayName?.isNotEmpty == true
                 ? firebaseUser.displayName!
                 : (firebaseUser.email?.split('@').first ?? 'User'),
          email: firebaseUser.email ?? '',
          role:  prefs.getString('user_role')  ?? 'System Administrator',
          phone: prefs.getString('user_phone') ?? '',
        );
        isLoggedIn = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('AuthService.init error: $e');
    }
  }

  // ── Email / password login ────────────────────────────────
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    lastError = null;
    try {
      final result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: email.trim(),
            password: password,
          );
      final prefs = await SharedPreferences.getInstance();
      user = AppUser(
        name:  result.user?.displayName?.isNotEmpty == true
               ? result.user!.displayName!
               : email.split('@').first,
        email: result.user?.email ?? email,
        role:  prefs.getString('user_role')  ?? 'System Administrator',
        phone: prefs.getString('user_phone') ?? '',
      );
      isLoggedIn = true;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      debugPrint('Login error: ${e.code} - ${e.message}');
      lastError = _parseFirebaseError(e);
      return lastError;
    } catch (e) {
      debugPrint('Login unknown error: $e');
      lastError = 'Something went wrong. Please try again.';
      return lastError;
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
    lastError = null;
    try {
      final result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password,
          );
      await result.user?.updateDisplayName(name.trim());
      await result.user?.reload();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_phone', phone ?? '');
      user = AppUser(
        name:  name.trim(),
        email: result.user?.email ?? email,
        phone: phone ?? '',
      );
      isLoggedIn = true;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      debugPrint('SignUp error: ${e.code} - ${e.message}');
      lastError = _parseFirebaseError(e);
      return lastError;
    } catch (e) {
      debugPrint('SignUp unknown error: $e');
      lastError = 'Something went wrong. Please try again.';
      return lastError;
    } finally {
      _setLoading(false);
    }
  }

  // ── Google Sign-In ────────────────────────────────────────
  // On WEB  → uses Firebase's built-in popup (no google_sign_in needed)
  // On mobile → uses google_sign_in package
  Future<String?> signInWithGoogle() async {
    _setLoading(true);
    lastError = null;
    try {
      UserCredential result;

      if (kIsWeb) {
        // ✅ Web: use Firebase GoogleAuthProvider popup directly
        final provider = GoogleAuthProvider()
          ..addScope('email')
          ..addScope('profile');
        result = await FirebaseAuth.instance.signInWithPopup(provider);
      } else {
        // ✅ Mobile: use google_sign_in package
        final googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          lastError = 'Google sign-in was cancelled.';
          return lastError;
        }
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken:     googleAuth.idToken,
        );
        result = await FirebaseAuth.instance.signInWithCredential(credential);
      }

      final prefs = await SharedPreferences.getInstance();
      user = AppUser(
        name:  result.user?.displayName?.isNotEmpty == true
               ? result.user!.displayName!
               : (result.user?.email?.split('@').first ?? 'User'),
        email: result.user?.email ?? '',
        role:  prefs.getString('user_role')  ?? 'System Administrator',
        phone: prefs.getString('user_phone') ?? '',
      );
      isLoggedIn = true;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      debugPrint('Google SignIn Firebase error: ${e.code} - ${e.message}');
      lastError = _parseFirebaseError(e);
      return lastError;
    } catch (e) {
      debugPrint('Google SignIn unknown error: $e');
      lastError = 'Google sign-in failed. Please try again.';
      return lastError;
    } finally {
      _setLoading(false);
    }
  }

  // ── Reset password ────────────────────────────────────────
  Future<String?> resetPassword({required String email}) async {
    _setLoading(true);
    lastError = null;
    try {
      final trimmed = email.trim();
      if (trimmed.isEmpty) return 'Please enter your email address.';
      if (!trimmed.contains('@')) return 'Please enter a valid email address.';
      await FirebaseAuth.instance.sendPasswordResetEmail(email: trimmed);
      return null;
    } on FirebaseAuthException catch (e) {
      lastError = _parseFirebaseError(e);
      return lastError;
    } catch (e) {
      lastError = 'Something went wrong. Please try again.';
      return lastError;
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
    lastError = null;
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) return 'Not logged in.';

      if (password != null && password.isNotEmpty) {
        await firebaseUser.updatePassword(password);
      }
      if (name != null && name.trim().isNotEmpty) {
        await firebaseUser.updateDisplayName(name.trim());
      }
      if (user != null) {
        user = user!.copyWith(
          name:  (name != null && name.trim().isNotEmpty) ? name.trim() : null,
          phone: phone,
          role:  role,
        );
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_role',  user!.role);
        await prefs.setString('user_phone', user!.phone);
        notifyListeners();
      }
      return null;
    } on FirebaseAuthException catch (e) {
      lastError = _parseFirebaseError(e);
      return lastError;
    } catch (e) {
      lastError = 'Something went wrong. Please try again.';
      return lastError;
    } finally {
      _setLoading(false);
    }
  }

  // ── Sign out ──────────────────────────────────────────────
  Future<void> signOut() async {
    _setLoading(true);
    try {
      await FirebaseAuth.instance.signOut();
      if (!kIsWeb && await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
      user       = null;
      isLoggedIn = false;
      lastError  = null;
      notifyListeners();
    } catch (e) {
      debugPrint('SignOut error: $e');
    } finally {
      _setLoading(false);
    }
  }

  // ── FirebaseAuthException parser ──────────────────────────
  String _parseFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with that email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'email-already-in-use':
        return 'An account with that email already exists.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      case 'requires-recent-login':
        return 'Please sign out and sign in again before changing your password.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled. Please contact support.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different sign-in method for this email.';
      case 'popup-closed-by-user':
        return 'Sign-in popup was closed. Please try again.';
      case 'cancelled-popup-request':
        return 'Another sign-in is in progress. Please wait.';
      case 'popup-blocked':
        return 'Sign-in popup was blocked. Please allow popups for this site.';
      default:
        return e.message ?? 'Something went wrong (${e.code}). Please try again.';
    }
  }

  // ── Helper ────────────────────────────────────────────────
  void _setLoading(bool value) {
    loading = value;
    notifyListeners();
  }
}