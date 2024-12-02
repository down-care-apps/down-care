import 'package:flutter/material.dart';
import 'package:down_care/api/childrens_service.dart';

class KidsProvider extends ChangeNotifier {
  final ChildrensService _childrensService = ChildrensService();
  List<Map<String, dynamic>> _kidsList = [];
  bool _isLoading = false;
  String? _error;

  // Getters for state
  List<Map<String, dynamic>> get kidsList => _kidsList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch all kids
  Future<void> fetchKids() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _childrensService.getAllChildrens();
      _kidsList = data.map((item) => item as Map<String, dynamic>).toList();
    } catch (e) {
      _error = "Error fetching kids data: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new kid
  Future<void> addKid(Map<String, dynamic> kid) async {
    try {
      final createdKid = await _childrensService.createProfileChildren(
        kid['name'],
        kid['weight'],
        kid['height'],
        kid['gender'],
        kid['dateBirthday'],
      );
      _kidsList.add(createdKid!);
      notifyListeners();
    } catch (e) {
      _error = "Error adding kid: $e";
      notifyListeners();
    }
  }

  // Update kid profile
  Future<void> updateKid(String id, Map<String, dynamic> updatedKid) async {
    try {
      await _childrensService.updateProfileChildren(
        id,
        updatedKid['name'],
        updatedKid['weight'],
        updatedKid['height'],
        updatedKid['gender'],
        updatedKid['dateBirthday'],
      );

      final index = _kidsList.indexWhere((kid) => kid['id'].toString() == id);
      if (index != -1) {
        _kidsList[index] = updatedKid;
        notifyListeners();
      }
    } catch (e) {
      _error = "Error updating kid: $e";
      notifyListeners();
    }
  }

  // Delete a kid
  Future<void> deleteKid(String id) async {
    try {
      await _childrensService.deleteProfileChildren(id);
      _kidsList.removeWhere((kid) => kid['id'] == id);
      notifyListeners();
    } catch (e) {
      _error = "Error deleting kid: $e";
      notifyListeners();
    }
  }
}
