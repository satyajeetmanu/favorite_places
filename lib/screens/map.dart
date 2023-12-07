import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location = const PlaceLocation(
      latitude: 37.422,
      longitude: -122.084,
      address: '',
    ),
    this.isSelecting = true,
  });

  final PlaceLocation location;
  final bool isSelecting;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.isSelecting ? 'Pick your location' : 'Location details'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(_pickedLocation);
              },
              icon: const Icon(Icons.save_rounded),
            )
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          onTap: widget.isSelecting == false
              ? null
              : (pos, point) {
                  setState(() {
                    _pickedLocation = point;
                  });
                },
          initialCenter: LatLng(
            widget.location.latitude,
            widget.location.longitude,
          ),
          initialZoom: 16,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: (_pickedLocation == null && widget.isSelecting)
                ? []
                : [
                    Marker(
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40.0,
                      ),
                      point: _pickedLocation ??
                          LatLng(
                            widget.location.latitude,
                            widget.location.longitude,
                          ),
                      width: 80,
                      height: 80,
                    ),
                  ],
          )
        ],
      ),
    );
  }
}
