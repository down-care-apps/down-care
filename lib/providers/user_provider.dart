import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:down_care/models/user_model.dart';
import 'package:down_care/api/user_api.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  final UserService _userService = UserService();

  // Getter to retrieve the current user data
  UserModel? get user => _user;

  // Method to fetch current user data from API
  Future<void> fetchCurrentUser() async {
    try {
      _user = await _userService.getCurrentUserData();
      notifyListeners();
    } catch (e) {
      throw Exception('Error fetching user data: $e');
    }
  }

  // Method to update user data (email, name, phoneNumber)
  Future<void> updateUser(String? email, String? name, String? phoneNumber) async {
    try {
      // Update the user data on the server
      await _userService.updateUser(email, name, phoneNumber);

      // After successful update, fetch the latest data from the API
      await fetchCurrentUser();
    } catch (e) {
      throw Exception('Error updating user data: $e');
    }
  }

  // Method to manually set user data in the provider
  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  // Method to sign out the user
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    _user = null; // Clear the user data
    notifyListeners();
  }
}
