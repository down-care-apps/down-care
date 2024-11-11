import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:down_care/widgets/input_field.dart'; // Update the import path as necessary
import 'dart:convert'; // For handling JSON responses
import 'package:http/http.dart' as http; // HTTP package for API requests

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late LatLng _userLocation;
  bool _isLocationLoaded = false;
  List<Marker> _hospitalMarkers = [];
  List<String> _hospitalNames = [];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enable location services.'),
        ),
      );
      await Geolocator.openLocationSettings();
      return;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permissions are denied. Please allow access.'),
          ),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permissions are permanently denied. Please allow access from settings.'),
        ),
      );
      return;
    }

    // Get the current location
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
        _isLocationLoaded = true;
      });
      _fetchNearbyHospitals();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error getting location: $e'),
        ),
      );
    }
  }

  Future<void> _fetchNearbyHospitals() async {
    final String url = 'https://overpass-api.de/api/interpreter?data=[out:json];'
        'node["amenity"="hospital"](around:5000,${_userLocation.latitude},${_userLocation.longitude});'
        'out body;';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final elements = data['elements'] as List;

        setState(() {
          _hospitalMarkers.clear();
          _hospitalNames.clear();
          _hospitalMarkers = elements.map((element) {
            final LatLng hospitalLocation = LatLng(
              element['lat'],
              element['lon'],
            );
            final hospitalName = element['tags']?['name'] ?? 'Unnamed Hospital';
            _hospitalNames.add(hospitalName);
            print('Hospital found: $hospitalName'); // Debug print
            return Marker(
              point: hospitalLocation,
              width: 40.0,
              height: 40.0,
              child: const Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 40.0,
              ),
            );
          }).toList();
        });
      } else {
        throw Exception('Failed to load hospital data');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching hospitals: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final TextEditingController _controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rumah Sakit Terdekat'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            InputField(
              hintText: 'Search for hospitals...',
              controller: _controller,
            ),
            const SizedBox(height: 16.0),
            _isLocationLoaded
                ? SizedBox(
                    height: screenHeight * 0.4, // Adjust the map size
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: _userLocation,
                          initialZoom: 15.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: _userLocation,
                                width: 40.0,
                                height: 40.0,
                                child: Icon(
                                  Icons.location_pin,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 40.0,
                                ),
                              ),
                              ..._hospitalMarkers,
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 16.0),
            Expanded(
              child: _hospitalNames.isNotEmpty
                  ? ListView.builder(
                      itemCount: _hospitalNames.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.local_hospital_outlined, color: Colors.red),
                          title: Text(_hospitalNames[index]),
                        );
                      },
                    )
                  : const Center(child: Text('No hospitals found nearby')),
            ),
          ],
        ),
      ),
    );
  }
}
