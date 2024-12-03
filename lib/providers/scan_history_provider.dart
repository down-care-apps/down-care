import 'package:flutter/material.dart';
import 'package:down_care/api/image_camera_services.dart';
import 'package:down_care/models/scan_history.dart';
import 'package:intl/intl.dart';

class ScanHistoryProvider extends ChangeNotifier {
  List<ScanHistory> _scanHistories = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<ScanHistory> get scanHistories => _scanHistories;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Fetch scan history from the API
  Future<void> fetchScanHistory({bool forceFetch = false}) async {
    if (_isLoading) return; // Prevent multiple simultaneous API calls

    _isLoading = true;
    notifyListeners(); // Notify listeners about loading state

    try {
      // Fetch scan history from the API
      final scanHistoryList = await ImageCameraServices().getAllScan();
      _scanHistories = scanHistoryList;

      // Sort scan histories from newest to oldest
      _sortScanHistories();

      _isLoading = false;
      notifyListeners(); // Notify listeners after the data is fetched and sorted
    } catch (error) {
      _errorMessage = error.toString();
      _isLoading = false;
      notifyListeners(); // Notify listeners on error
    }
  }

  // Method to force refetch the data when new data is added (e.g., after taking a scan)
  Future<void> refreshScanHistory() async {
    await fetchScanHistory(forceFetch: true);
  }

  // Method to get the latest 3 scan histories, sorted from newest to oldest
  List<ScanHistory> get latestScanHistories {
    // Sort scan histories from newest to oldest
    _sortScanHistories();

    // Take the latest 3 scan histories
    return _scanHistories.take(3).toList();
  }

  // Helper method to sort scan histories
  void _sortScanHistories() {
    final dateFormat = DateFormat('dd-MM-yyyy HH:mm');

    // Sort scan histories from newest to oldest
    _scanHistories.sort((a, b) {
      DateTime dateA = dateFormat.parse(a.date);
      DateTime dateB = dateFormat.parse(b.date);
      return dateB.compareTo(dateA); // Sort descending (newest first)
    });
  }
}
