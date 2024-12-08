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

  Future<void> _safeUpdate(Function() updater) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updater();
      notifyListeners();
    });
  }

  Future<void> fetchScanHistory({bool forceFetch = false}) async {
    if (_isLoading || (_isFetched && !forceFetch)) return;

    _safeUpdate(() {
      _isLoading = true;
    });

    try {
      final scanHistoryList = await ImageCameraServices().getAllScan();
      _safeUpdate(() {
        _scanHistories = scanHistoryList;
        _sortScanHistories();
        _isFetched = true;
      });
    } catch (error) {
      _safeUpdate(() {
        _errorMessage = error.toString();
      });
    } finally {
      _safeUpdate(() {
        _isLoading = false;
      });
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

  void clearState() {
    _safeUpdate(() {
      _scanHistories = [];
      _isFetched = false;
      _errorMessage = '';
    });
  }
}
