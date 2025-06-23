import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pharmaciyti/features/client/home/data/models/pharmacy.dart' as myPharmacy;

class MapPage extends StatefulWidget {
  final myPharmacy.Pharmacy pharmacy;

  const MapPage({Key? key, required this.pharmacy}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _controller;
  LatLng? _pharmacyLocation;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchPharmacyCoordinates();
  }

  Future<void> _fetchPharmacyCoordinates() async {
    if (widget.pharmacy.address == null) {
      setState(() {
        _error = 'No address available';
        _isLoading = false;
      });
      return;
    }

    try {
      // Use Nominatim (free alternative to Google Maps Geocoding API)
      final String address = Uri.encodeComponent(widget.pharmacy.address!);
      final String url =
          'https://nominatim.openstreetmap.org/search?q=$address&format=json&limit=1';
      final response = await http.get(
        Uri.parse(url),
        headers: {'User-Agent': 'PharmcityApp/1.0'},
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final double lat = double.parse(data[0]['lat']);
          final double lon = double.parse(data[0]['lon']);
          setState(() {
            _pharmacyLocation = LatLng(lat, lon);
            _isLoading = false;
          });
        } else {
          setState(() {
            _error = 'Location not found';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _error = 'Failed to fetch location';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error fetching location: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pharmacy.name),
        backgroundColor: Colors.blue[700],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!, style: TextStyle(fontSize: screenWidth * 0.04)))
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _pharmacyLocation!,
                    zoom: 15,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId(widget.pharmacy.id),
                      position: _pharmacyLocation!,
                      infoWindow: InfoWindow(
                        title: widget.pharmacy.name,
                        snippet: widget.pharmacy.address,
                      ),
                    ),
                  },
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                  },
                ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}