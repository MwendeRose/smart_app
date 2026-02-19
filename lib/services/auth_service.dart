// lib/services/auth_service.dart
// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AppUser {
  final String id;
  final String name;
  final String email;
  final String role;
  final String phone;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
  });

  factory AppUser.fromJson(Map<String, dynamic> j) => AppUser(
        id:    j['id']?.toString()   ?? '',
        name:  j['name']?.toString() ?? 'User',
        email: j['email']?.toString() ?? '',
        role:  j['role']?.toString()  ?? 'User',
        phone: j['phone']?.toString() ?? '',
      );

  /// Initials (up to 2 letters)
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  /// First name only
  String get firstName => name.split(' ').first;

  AppUser copyWith({String? name, String? role, String? phone}) => AppUser(
        id: id,
        name: name ?? this.name,
        email: email,
        role: role ?? this.role,
        phone: phone ?? this.phone,
      );
}

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._();
  factory AuthService() => _instance;
  AuthService._();

  // ── Replace with your machine's LAN IP when running on a real device ──
  static const String _baseUrl = 'http://10.0.2.2:3000'; // Android emulator
  // static const String _baseUrl = 'http://localhost:3000'; // iOS simulator

  AppUser? _user;
  String?  _token;
  bool     _loading = false;

  AppUser? get user    => _user;
  String?  get token   => _token;
  bool     get loading => _loading;
  bool     get isLoggedIn => _token != null && _user != null;

  // ── Persist token ─────────────────────────────────────────
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    final userJson = prefs.getString('user');
    if (_token != null && userJson != null) {
      _user = AppUser.fromJson(jsonDecode(userJson));
      notifyListeners();
      // Refresh user data from server
      await fetchMe();
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    if (_token != null) {
      await prefs.setString('token', _token!);
    } else {
      await prefs.remove('token');
    }
    if (_user != null) {
      await prefs.setString('user', jsonEncode({
        'id': _user!.id, 'name': _user!.name,
        'email': _user!.email, 'role': _user!.role, 'phone': _user!.phone,
      }));
    } else {
      await prefs.remove('user');
    }
  }

  Map<String, String> get _authHeaders => {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  // ── Sign Up ───────────────────────────────────────────────
  Future<String?> signUp({
    required String name,
    required String email,
    required String password,
    String phone = '',
    String role  = 'System Administrator',
  }) async {
    _loading = true; notifyListeners();
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/api/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name, 'email': email, 'password': password,
          'phone': phone, 'role': role,
        }),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 201) {
        _token = data['token'];
        _user  = AppUser.fromJson(data['user']);
        await _persist();
        notifyListeners();
        return null; // success
      }
      return data['error'] ?? 'Sign-up failed';
    } catch (e) {
      return 'Network error: $e';
    } finally {
      _loading = false; notifyListeners();
    }
  }

  // ── Login ─────────────────────────────────────────────────
  Future<String?> login({required String email, required String password}) async {
    _loading = true; notifyListeners();
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        _token = data['token'];
        _user  = AppUser.fromJson(data['user']);
        await _persist();
        notifyListeners();
        return null;
      }
      return data['error'] ?? 'Login failed';
    } catch (e) {
      return 'Network error: $e';
    } finally {
      _loading = false; notifyListeners();
    }
  }

  // ── Fetch current user from server ────────────────────────
  Future<void> fetchMe() async {
    if (_token == null) return;
    try {
      final res = await http.get(
        Uri.parse('$_baseUrl/api/auth/me'),
        headers: _authHeaders,
      );
      if (res.statusCode == 200) {
        _user = AppUser.fromJson(jsonDecode(res.body));
        await _persist();
        notifyListeners();
      } else if (res.statusCode == 401) {
        // Token expired
        await signOut();
      }
    } catch (_) {}
  }

  // ── Update profile ────────────────────────────────────────
  Future<String?> updateProfile({String? name, String? phone, String? role, String? password}) async {
    if (_token == null) return 'Not authenticated';
    _loading = true; notifyListeners();
    try {
      final body = <String, dynamic>{};
      if (name     != null) body['name']     = name;
      if (phone    != null) body['phone']    = phone;
      if (role     != null) body['role']     = role;
      if (password != null) body['password'] = password;

      final res = await http.patch(
        Uri.parse('$_baseUrl/api/auth/me'),
        headers: _authHeaders,
        body: jsonEncode(body),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        _user = AppUser.fromJson(data);
        await _persist();
        notifyListeners();
        return null;
      }
      return data['error'] ?? 'Update failed';
    } catch (e) {
      return 'Network error: $e';
    } finally {
      _loading = false; notifyListeners();
    }
  }

  // ── Sign Out ──────────────────────────────────────────────
  Future<void> signOut() async {
    _token = null;
    _user  = null;
    await _persist();
    notifyListeners();
  }
}