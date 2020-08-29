import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Map<String, Marker> _markers = {};
  static LatLng _initialPosition;

  @override
  void initState() {
    _getLocation();
    super.initState();
  }

  void _getLocation() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    setState(() {
      _markers.clear();
      final marker = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        infoWindow: InfoWindow(title: 'Your Location'),
      );
      _markers["Current Location"] = marker;
      _initialPosition =
          LatLng(currentLocation.latitude, currentLocation.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _initialPosition != null
          ? GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 15,
              ),
              markers: _markers.values.toSet(),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
