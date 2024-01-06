import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key, this.latitude, this.longitude}) : super(key: key);

  final double? latitude;
  final double? longitude;

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Set<Marker> markers = {};

  void _onMapCreated(GoogleMapController controller) {
    // Add a marker at the specified latitude and longitude
    if (widget.latitude != null && widget.longitude != null) {
      setState(() {
        markers.add(
          Marker(
            markerId: MarkerId('selected_location'),
            position: LatLng(widget.latitude!, widget.longitude!),
            infoWindow: InfoWindow(
              title: 'Selected Location',
              snippet: 'Lat: ${widget.latitude}, Lng: ${widget.longitude}',
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SafeArea(
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.latitude ?? 0.0, widget.longitude ?? 0.0),
            zoom: 12.0,
          ),
          markers: markers,
          mapType: MapType.normal,
          compassEnabled: true,
          zoomControlsEnabled: false,
        ),
      ),
    );
  }
}
