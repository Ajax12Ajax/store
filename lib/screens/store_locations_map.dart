import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:store/widgets/location_marker.dart';

class StoreLocationsMap extends StatefulWidget {
  const StoreLocationsMap({super.key});

  @override
  State<StoreLocationsMap> createState() => StoreLocationsMapState();
}

class StoreLocationsMapState extends State<StoreLocationsMap> {
  static StoreLocationsMapState? _instance;
  static final MapController mapController = MapController();
  static LatLng center = const LatLng(50.061250709159886, 7.79069436321845);
  static double zoom = 3.9;

  static late List<LocationMarker> markers;
  LocationMarker poznanMarker = LocationMarker(
    location: const LatLng(52.40073072909504, 16.92723058948336),
    name: 'Poznań Store',
    address: 'pl. Władysława Andersa 5, 61-894 Poznań',
    openingHours: 'Mon - Fri: 9:00 AM - 6:00 PM\nSat: 10:00 AM - 4:00 PM\nSun: Closed',
  );
  LocationMarker gdanskMarker = LocationMarker(
    location: const LatLng(54.398859181362184, 18.576543083939065),
    name: 'Gdańsk Store',
    address: 'pl. Władysława Andersa 5, 61-894 Poznań',
    openingHours: 'Mon - Fri: 9:00 AM - 6:00 PM\nSat: 10:00 AM - 4:00 PM\nSun: Closed',
  );
  LocationMarker newYorkMarker = LocationMarker(
    location: const LatLng(40.75242545834049, -73.97918863810726),
    name: 'New York Store',
    address: 'pl. Władysława Andersa 5, 61-894 Poznań',
    openingHours: 'Mon - Fri: 9:00 AM - 6:00 PM\nSat: 10:00 AM - 4:00 PM\nSun: Closed',
  );
  LocationMarker miamiMarker = LocationMarker(
    location: const LatLng(25.77042867078461, -80.18991824489082),
    name: 'Miami Store',
    address: 'pl. Władysława Andersa 5, 61-894 Poznań',
    openingHours: 'Mon - Fri: 9:00 AM - 6:00 PM\nSat: 10:00 AM - 4:00 PM\nSun: Closed',
  );
  LocationMarker londonMarker = LocationMarker(
    location: const LatLng(51.50727351961355, -0.10726761578905235),
    name: 'London Store',
    address: 'pl. Władysława Andersa 5, 61-894 Poznań',
    openingHours: 'Mon - Fri: 9:00 AM - 6:00 PM\nSat: 10:00 AM - 4:00 PM\nSun: Closed',
  );

  static void forceMapRebuild() {
    if (_instance != null) {
      _instance!.setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _instance = this;
    markers = [poznanMarker, gdanskMarker, newYorkMarker, miamiMarker, londonMarker];

    mapController.mapEventStream.listen((event) {
      if (mounted) {
        setState(() {
          center = event.camera.center;
          zoom = event.camera.zoom;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Stores Locations",
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF000000),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: FlutterMap(
        mapController: mapController,
        options: const MapOptions(
          initialCenter: LatLng(50.061250709159886, 7.79069436321845),
          initialZoom: 3.9,
          minZoom: 3,
          maxZoom: 20,
          interactionOptions: InteractionOptions(
            flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://basemaps.cartocdn.com/rastertiles/light_all/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: markers
                .map(
                  (marker) => Marker(
                    point: marker.location,
                    width: marker.markerWidth,
                    height: marker.markerHeight,
                    child: marker,
                  ),
                )
                .toList(),
          ),
          Scalebar(
            alignment: Alignment.bottomLeft,
            textStyle: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF000000),
            ),
            lineColor: Colors.black,
            strokeWidth: 2,
            lineHeight: 5,
            padding: const EdgeInsets.all(40),
            length: ScalebarLength.m,
          ),
        ],
      ),
    );
  }
}
