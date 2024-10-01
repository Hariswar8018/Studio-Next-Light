import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_managment_app/model/bus.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackBus extends StatefulWidget {
  final String id;
  final bool edit;
  BusModel bus;

  TrackBus({required this.id, required this.edit,required this.bus});

  @override
  _TrackBusState createState() => _TrackBusState();
}

class _TrackBusState extends State<TrackBus> {
  GoogleMapController? _mapController;
  Set<Polyline> _polylines = {};
  Marker? _busMarker;
  Marker? _userMarker;
  BitmapDescriptor? _busIcon;
  BitmapDescriptor? _userIcon;
  StreamSubscription<Position>? _positionStream;
  late LatLng _currentLocation;
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    _setCustomMarkers();
    _loadRouteFromFirestore();
    _startUserLocationUpdates();
    _startBusLocationUpdates();
    _fetchInitialLocation();
  }
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: BusModel.color,
          title: Text("Live Bus Tracking"),
        actions: [
          Text("${df()}   ")
        ],
      ),
      body: _initialLocation == null
          ? Center(child: CircularProgressIndicator())
          :GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialLocation!,
          zoom: 12,
        ),
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        markers: {_busMarker ?? Marker(markerId: MarkerId("bus")), _userMarker ?? Marker(markerId: MarkerId("user"))},
        polylines: _polylines,
      ),
    );
  }

  // Load route from Firestore
  Future<void> _loadRouteFromFirestore() async {
    DocumentSnapshot routeSnapshot = await FirebaseFirestore.instance
        .collection("Bus")
        .doc(widget.id)
        .collection("Route")
        .doc(widget.id)
        .get();

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

  Future<BitmapDescriptor> getResizedMarker(String path, int width) async {
    final ByteData byteData = await rootBundle.load(path);
    final codec = await ui.instantiateImageCodec(
      byteData.buffer.asUint8List(),
      targetWidth: width, // 👈 Size in pixels (try 24 or less for very small)
    );
    final frame = await codec.getNextFrame();
    final byteDataResized = await frame.image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(byteDataResized!.buffer.asUint8List());
  }

  Future<void> _setCustomMarkers() async {
    _busIcon = await getResizedMarker("assets/bus.png", 120);  // Very small bus marker
    _userIcon = await getResizedMarker("assets/user.png", 120); // Very small user marker
  }

  void _startUserLocationUpdates() {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 5),
    ).listen((Position position) {
      LatLng userLatLng = LatLng(position.latitude, position.longitude);

      setState(() {
        _userMarker = Marker(
          markerId: MarkerId("user"),
          position: userLatLng,
          icon: _userIcon ?? BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: "Your Location"),
        );
      });

      _mapController?.animateCamera(CameraUpdate.newLatLng(userLatLng));
    });
  }

  // Fetch Bus Location from Firestore every 5 seconds
  void _startBusLocationUpdates() {
    _updateTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      my=DateTime.now();
      print("yes");
      DocumentSnapshot busSnapshot = await FirebaseFirestore.instance.collection("Bus").doc(widget.id).get();
      if (busSnapshot.exists && busSnapshot["liveLocation"] != null) {
        LatLng busLatLng = LatLng(
          busSnapshot["liveLocation"]["lat"],
          busSnapshot["liveLocation"]["lng"],
        );
        setState(() {
          _busMarker = Marker(
            markerId: MarkerId("bus"),
            position: busLatLng,
            icon: _busIcon ?? BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(title: "Bus Location"),
          );
        });

        _mapController?.animateCamera(CameraUpdate.newLatLng(busLatLng));
      }
    });
  }

  DateTime my=DateTime.now();

  String df() {
    final now = DateTime.now();
    final diff = now.difference(widget.bus.date);

    if (diff.inSeconds < 60) {
      return "just now";
    } else if (diff.inMinutes < 60) {
      return "${diff.inMinutes} minute${diff.inMinutes == 1 ? '' : 's'} ago";
    } else if (diff.inHours < 24) {
      return "${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago";
    } else if (diff.inDays == 1) {
      return "yesterday";
    } else {
      return "${diff.inDays} days ago";
    }
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _updateTimer?.cancel();
    super.dispose();
  }
}
