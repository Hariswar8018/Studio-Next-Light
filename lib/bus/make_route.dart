import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/main.dart';


class BusRouteScreen extends StatefulWidget {
  String routeid, id;
  bool neww;
  BusRouteScreen({required this.id,required this.routeid,required this.neww});
  @override
  _BusRouteScreenState createState() => _BusRouteScreenState();
}

class _BusRouteScreenState extends State<BusRouteScreen> {
  GoogleMapController? _mapController;
  List<LatLng> _routePoints = [];
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

  void initState(){
    _fetchInitialLocation();
  }
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffF6BA24),
        title: Text("Create Bus Route",style: TextStyle(color: Colors.black),),
      actions: [
        IconButton(onPressed: (){
          setState(() {
            _routePoints=[];
            _polylines={};
          });
        }, icon: Icon(Icons.refresh)),
        SizedBox(width: 7,)
      ],
      ),
      body:  _initialLocation == null
          ? Center(child: CircularProgressIndicator())
          :GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialLocation!,
          zoom: 12,
        ),
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        onTap: _addPointToRoute, // Add points on tap
        polylines: _polylines,
      ),
      persistentFooterButtons: [
        InkWell(
            onTap: _saveRouteToFirestore,
            child: Center(child: Send.button(context, "Save Route & Continue"))),
      ],
    );
  }

  // Add tapped points to route
  void _addPointToRoute(LatLng point) {
    setState(() {
      _routePoints.add(point);
      _polylines.clear();
      _polylines.add(Polyline(
        polylineId: PolylineId("busRoute"),
        points: _routePoints,
        color: Colors.blue,
        width: 5,
      ));
    });
  }

  // Save route to Firestore
  Future<void> _saveRouteToFirestore() async {
    if (_routePoints.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No route points to save"))
      );
      return;
    }

    List<Map<String, double>> routeData = _routePoints.map((point) => {
      "lat": point.latitude,
      "lng": point.longitude,
    }).toList();

    if(widget.neww){
      try {
        await FirebaseFirestore.instance
            .collection("Bus")
            .doc(widget.id)
            .collection("Route")
            .doc(widget.id)
            .set({
          "routeId": widget.id,
          "points": routeData,
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final bool Admin = prefs.getBool('Admin') ?? false ;
        final bool Parent = prefs.getBool('Parent') ?? false ;
        final String Position = prefs.getString('What') ?? "None";
        Navigator.push(
            context,
            PageTransition(
                child:MyApp(Admin: Admin, Parent: Parent, position: Position,),
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 10)));
        Send.message(context, "Saved Successfully", true);
      } catch (e) {
        print(e);
        Send.message(context, "$e", false);
      }finally{
        return ;
      }
    }
    try {
      await FirebaseFirestore.instance
          .collection("Bus")
          .doc(widget.id)
          .collection("Route")
          .doc(widget.id)
          .update({
        "routeId": widget.id,
        "points": routeData,
      });
      Send.message(context, "Updated Successfully", true);
      Navigator.pop(context);
    } catch (e) {
      print(e);
      Send.message(context, "$e", false);
    }
  }
}
