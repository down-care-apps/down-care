import 'package:down_care/models/children_model.dart';
import 'package:flutter/material.dart';
import 'package:down_care/api/childrens_service.dart';

class KidsProvider with ChangeNotifier {
  List<ChildrenModel> _kidsList = [];
  final ChildrensService _childrensService = ChildrensService();
  bool _isLoading = false;
  String? _error;

  // Getters for state
  List<ChildrenModel> get kidsList => _kidsList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Method to fetch all kids
  Future<void> fetchKids() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _childrensService.getAllChildrens();
      _kidsList = data.map((item) => ChildrenModel.fromJson(item)).toList();
    } catch (e) {
      _error = "Error fetching kids data: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method to add a new kid
  Future<void> addKid(ChildrenModel kid) async {
    try {
      final createdKid = await _childrensService.createProfileChildren(
        kid.name,
        kid.weight,
        kid.height,
        kid.gender,
        kid.dateBirthday,
      );

      if (createdKid != null) {
        print('Created Kid: $createdKid');
        final newKid = ChildrenModel(
          id: createdKid['childrenId'],
          name: kid.name,
          age: kid.age,
          gender: kid.gender,
          weight: kid.weight,
          height: kid.height,
          dateBirthday: kid.dateBirthday,
        );
        print('New Kid ID: ${newKid.id}');
        _kidsList.add(newKid);
        notifyListeners();
      } else {
        _error = "Error adding kid: createdKid is null";
        notifyListeners();
      }
    } catch (e) {
      _error = "Error adding kid: $e";
      notifyListeners();
    }
  }

  // Method to update kid profile
  Future<void> updateKid(String id, ChildrenModel updatedKid) async {
    try {
      await _childrensService.updateProfileChildren(
        id,
        updatedKid.name,
        updatedKid.weight,
        updatedKid.height,
        updatedKid.gender,
        updatedKid.dateBirthday,
      );

      final index = _kidsList.indexWhere((kid) => kid.id == id);
      if (index != -1) {
        _kidsList[index] = updatedKid;
        notifyListeners();
      }
    } catch (e) {
      _error = "Error updating kid: $e";
      notifyListeners();
    }
  }

  // Method to delete a kid
  Future<void> deleteKid(String id) async {
    try {
      await _childrensService.deleteProfileChildren(id);
      _kidsList.removeWhere((kid) => kid.id == id);
      notifyListeners();
    } catch (e) {
      _error = "Error deleting kid: $e";
      notifyListeners();
    }
  }

  // Method to manually set kids list in the provider
  void setKidsList(List<ChildrenModel> kidsList) {
    _kidsList = kidsList;
    notifyListeners();
  }
}
