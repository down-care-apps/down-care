import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Location _locationController = Location();
  LatLng? _currentP;
  final Set<Marker> _markers = {};
  GoogleMapController? _mapController;
  bool _initialLocationSet = false;
  bool _userMovedMap = false;

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentP == null
          ? const Center(
              child: Text('Loading...'),
            )
          : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentP!,
                zoom: 14.0,
              ),
              markers: _markers,
              onTap: (_) => setState(() => _userMovedMap = true),
              onCameraMove: (_) => setState(() => _userMovedMap = true),
            ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> getLocationUpdates() async {
    bool servicesEnabled;
    PermissionStatus permissionGranted;

    servicesEnabled = await _locationController.serviceEnabled();
    if (!servicesEnabled) {
      servicesEnabled = await _locationController.requestService();
      if (!servicesEnabled) {
        return;
      }
    }

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        setState(() {
          _currentP = LatLng(currentLocation.latitude!, currentLocation.longitude!);

          // Only set initial location and center once
          if (!_initialLocationSet) {
            _markers.add(
              Marker(
                markerId: const MarkerId('_currentLocation'),
                icon: BitmapDescriptor.defaultMarker,
                position: _currentP!,
                infoWindow: const InfoWindow(title: 'Your Location'),
              ),
            );

            // Find nearby hospitals only on initial location
            _findNearbyHospitals();

            // Move camera only if user hasn't moved the map
            if (!_userMovedMap) {
              _mapController?.animateCamera(
                CameraUpdate.newLatLngZoom(_currentP!, 14.0),
              );
            }

            _initialLocationSet = true;
          }
        });
      }
    });
  }

  Future<void> _findNearbyHospitals() async {
    if (_currentP == null) return;

    final String apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

    final String url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
        'location=${_currentP!.latitude},${_currentP!.longitude}'
        '&radius=5000'
        '&type=hospital'
        '&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Clear previous hospital markers
        setState(() {
          _markers.removeWhere((marker) => marker.markerId.value.contains('hospital'));
        });

        // Add new hospital markers
        if (data['results'] != null) {
          for (var hospital in data['results']) {
            final location = hospital['geometry']['location'];
            final LatLng hospitalLocation = LatLng(location['lat'], location['lng']);

            setState(() {
              _markers.add(
                Marker(
                  markerId: MarkerId('hospital_${hospital['place_id']}'),
                  position: hospitalLocation,
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                  infoWindow: InfoWindow(
                    title: hospital['name'],
                    snippet: hospital['vicinity'],
                  ),
                ),
              );
            });
          }

          // Adjust camera to show all markers if user hasn't moved map
          if (_mapController != null && !_userMovedMap) {
            _mapController!.animateCamera(
              CameraUpdate.newLatLngBounds(_calculateBounds(_markers), 50 // padding
                  ),
            );
          }
        }
      }
    } catch (e) {
      throw Exception('Error fetching nearby hospitals: $e');
    }
  }

  // Helper method to calculate bounds of markers
  LatLngBounds _calculateBounds(Set<Marker> markers) {
    if (markers.isEmpty) {
      // Return a default bounds if no markers
      return LatLngBounds(
        southwest: _currentP ?? const LatLng(0, 0),
        northeast: _currentP ?? const LatLng(0, 0),
      );
    }

    double minLat = markers.first.position.latitude;
    double maxLat = markers.first.position.latitude;
    double minLng = markers.first.position.longitude;
    double maxLng = markers.first.position.longitude;

    for (Marker marker in markers) {
      minLat = min(minLat, marker.position.latitude);
      maxLat = max(maxLat, marker.position.latitude);
      minLng = min(minLng, marker.position.longitude);
      maxLng = max(maxLng, marker.position.longitude);
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  // Utility methods
  double min(double a, double b) => a < b ? a : b;
  double max(double a, double b) => a > b ? a : b;
}
