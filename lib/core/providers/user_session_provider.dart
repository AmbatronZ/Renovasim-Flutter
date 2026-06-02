import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';

class UserSessionProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;
  int? get userId => _currentUser?.id;

  Future<void> loadUser(int userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await UserRepository.getUserById(userId);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _currentUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUserByEmail(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await UserRepository.getUserByEmail(email);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _currentUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? timezone,
    String? language,
    String? jobTitle,
  }) async {
    if (_currentUser == null) {
      _error = 'Pengguna tidak terautentikasi';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = <String, dynamic>{};
      if (firstName != null) data['first_name'] = firstName;
      if (lastName != null) data['last_name'] = lastName;
      if (phone != null) data['phone'] = phone;
      if (timezone != null) data['timezone'] = timezone;
      if (language != null) data['language'] = language;
      if (jobTitle != null) data['job_title'] = jobTitle;

      _currentUser = await UserRepository.updateProfile(_currentUser!.id, data);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearUser() {
    _currentUser = null;
    _error = null;
    notifyListeners();
  }
}
