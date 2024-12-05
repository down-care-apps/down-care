import 'package:flutter/material.dart';
import 'package:down_care/api/image_camera_services.dart';
import 'package:down_care/models/scan_history.dart';
import 'package:intl/intl.dart';

class ScanHistoryProvider extends ChangeNotifier {
  List<ScanHistory> _scanHistories = [];
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isFetched = false;

  List<ScanHistory> get scanHistories => _scanHistories;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchScanHistory({bool forceFetch = false}) async {
    if (_isLoading || (_isFetched && !forceFetch)) return;

    _isLoading = true;
    notifyListeners();

    try {
      final scanHistoryList = await ImageCameraServices().getAllScan();
      _scanHistories = scanHistoryList;
      _sortScanHistories();
      _isFetched = true;
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshScanHistory() async {
    _isFetched = false;
    await fetchScanHistory(forceFetch: true);
  }

  List<ScanHistory> get latestScanHistories {
    _sortScanHistories();
    return _scanHistories.take(3).toList();
  }

  void _sortScanHistories() {
    final dateFormat = DateFormat('dd-MM-yyyy HH:mm');
    _scanHistories.sort((a, b) {
      DateTime dateA = dateFormat.parse(a.date);
      DateTime dateB = dateFormat.parse(b.date);
      return dateB.compareTo(dateA);
    });
  }
}
