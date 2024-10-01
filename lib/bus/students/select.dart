import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:student_managment_app/function/send.dart';

class LocationPicker extends StatelessWidget {
  final Function(LatLng) onLocationPicked; // Callback to return the selected location

  LocationPicker({required this.onLocationPicked, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pick Location")),
      body: LocationPickerMap(onLocationPicked: onLocationPicked),
    );
  }
}

class LocationPickerMap extends StatefulWidget {
  final Function(LatLng) onLocationPicked;

  const LocationPickerMap({required this.onLocationPicked, Key? key}) : super(key: key);

  @override
  _LocationPickerMapState createState() => _LocationPickerMapState();
}

class _LocationPickerMapState extends State<LocationPickerMap> {
  late GoogleMapController _mapController;
  LatLng? _selectedLocation; // Store tapped location

  Future<LatLng> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return LatLng(position.latitude, position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LatLng>(
      future: _getCurrentLocation(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        LatLng initialPosition = snapshot.data!;

        return GoogleMap(
          initialCameraPosition: CameraPosition(target: initialPosition, zoom: 15),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
          },
          markers: _selectedLocation != null
              ? {
            Marker(
              markerId: MarkerId("selected_location"),
              position: _selectedLocation!,
              infoWindow: InfoWindow(title: "Selected Location"),
            ),
          }
              : {},
          onTap: (LatLng tappedLocation) {
            Send.message(context, "Long Press to Confirm", false);
            setState(() {
              _selectedLocation = tappedLocation; // Update marker
            });
          },
          onLongPress: (LatLng confirmedLocation) {
            if (_selectedLocation != null) {
              widget.onLocationPicked(_selectedLocation!);
              Navigator.pop(context, _selectedLocation!); // Return selected location
            }
          },
        );
      },
    );
  }
}
