import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewRouteScreen extends StatefulWidget {
  String id;bool edit;
  ViewRouteScreen({required this.id,required this.edit});
  @override
  _ViewRouteScreenState createState() => _ViewRouteScreenState();
}

class _ViewRouteScreenState extends State<ViewRouteScreen> {
  GoogleMapController? _mapController;
  Set<Polyline> _polylines = {};
  Future<LatLng> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are disabled.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permission denied.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permission permanently denied.");
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return LatLng(position.latitude, position.longitude);
  }
  LatLng? _initialLocation;
  Future<void> _fetchInitialLocation() async {
    try {
      LatLng currentLocation = await _getCurrentLocation();
      setState(() {
        _initialLocation = currentLocation;
      });
    } catch (e) {
      print("Error fetching location: $e");
      // Fallback to a default location if location is not available
      setState(() {
        _initialLocation = LatLng(28.7041, 77.1025); // Default to Delhi
      });
    }
  }
  @override
  void initState() {
    super.initState();
    _loadRouteFromFirestore();
    _fetchInitialLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xffF6BA24),
          title: Text("View Bus Route")),
      body:_initialLocation == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialLocation!,
          zoom: 12,
        ),
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        polylines: _polylines,
      ),
    );
  }

  // Load saved route from Firestore
  Future<void> _loadRouteFromFirestore() async {
    DocumentSnapshot routeSnapshot = await FirebaseFirestore.instance.collection("Bus").doc(widget.id).collection("Route").doc(widget.id).get();

    if (routeSnapshot.exists) {
      List<dynamic> pointsData = routeSnapshot["points"];
      List<LatLng> routePoints = pointsData.map((point) => LatLng(point["lat"], point["lng"])).toList();

      setState(() {
        _polylines.add(Polyline(
          polylineId: PolylineId(widget.id),
          points: routePoints,
          color: Colors.blue,
          width: 5,
        ));
      });
    }
  }

  Marker? _busMarker;
  BitmapDescriptor? _busIcon;
  StreamSubscription<Position>? _positionStream;
  late LatLng _currentLocation;

  Future<void> _setCustomMarker() async {
    _busIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(48, 48)),
      "assets/bus.png", // Add a custom bus icon in assets
    );
  }

  // Start tracking user's live location

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }
}
