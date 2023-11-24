import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng currentLocation = LatLng(10.9903, 76.985);
  GoogleMapController? _controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: (controller) {
                _controller = controller;
              },
              initialCameraPosition: CameraPosition(
                target: currentLocation,
                zoom: 14.0,
              ),
              markers: {
                Marker(
                  markerId: MarkerId("sourcelocation"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: currentLocation,
                ),
              },
            ),
            Positioned(
              bottom: 10,
              left: 20,
              child: ElevatedButton(
                onPressed: () async {
                  await _fetchLocation();
                },
                child: Text("Fetch"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    setState(() {
      currentLocation = LatLng(_locationData.latitude!, _locationData.longitude!);
      print(currentLocation);
    });

    _controller?.animateCamera(CameraUpdate.newLatLng(currentLocation));
  }
}
