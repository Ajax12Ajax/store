import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:store/screens/store_locations_map.dart';
import 'package:store/widgets/icon_button.dart';

class LocationMarker extends StatefulWidget {
  final LatLng location;
  final String name;
  final String address;
  final String openingHours;

  double markerWidth = 30.0;
  double markerHeight = 37.0 * 2;
  bool selected = false;
  double opacity = 1.0;
  double zoom = StoreLocationsMapState.zoom;
  LatLng lastCenter = StoreLocationsMapState.center;
  double lastZoom = StoreLocationsMapState.zoom;

  LocationMarker({
    super.key,
    required this.location,
    required this.name,
    required this.address,
    required this.openingHours,
  });

  @override
  LocationMarkerState createState() => LocationMarkerState();
}

class LocationMarkerState extends State<LocationMarker> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          widget.opacity = 0.5;
        });
      },
      onTapUp: (_) {
        setState(() {
          widget.opacity = 1.0;
          widget.selected = true;
          widget.lastCenter = StoreLocationsMapState.center;
          widget.lastZoom = StoreLocationsMapState.zoom;
          StoreLocationsMapState.mapController.move(
            widget.location,
            widget.zoom = (StoreLocationsMapState.zoom < 14 ? 14.0 : StoreLocationsMapState.zoom),
          );
          widget.markerWidth = 220;
          widget.markerHeight = 208.1 * 2;

          int currentIndex = StoreLocationsMapState.markers.indexOf(widget);
          if (currentIndex != -1) {
            var marker = StoreLocationsMapState.markers.removeAt(currentIndex);
            StoreLocationsMapState.markers.add(marker);
            StoreLocationsMapState.forceMapRebuild();
          }
        });
      },
      onTapCancel: () {
        setState(() {
          widget.opacity = 1.0;
        });
      },
      child: Stack(
        children: [
          Visibility(
            visible: !widget.selected,
            child: AnimatedOpacity(
              opacity: widget.opacity,
              duration: Duration(milliseconds: 100),
              curve: Curves.easeInOut,
              child: Container(
                color: Colors.transparent,
                width: widget.markerWidth,
                height: widget.markerHeight - widget.markerHeight / 2,
                child: Center(
                  child: SvgPicture.asset('assets/icons/location_on.svg', width: 30, height: 37),
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.selected,
            child: Column(
              children: [
                Container(
                  width: widget.markerWidth,
                  height: 177.1,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Color(0xFFF6F6F6),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x40000000),
                        blurRadius: 4,
                        spreadRadius: 0,
                        offset: Offset(1, 2),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 9),
                        height: 34,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.name,
                              style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF000000),
                              ),
                            ),
                            CustomIconButton(
                              iconPath: 'assets/icons/close.svg',
                              iconWidth: 16,
                              iconHeight: 16,
                              maxWidth: 34,
                              maxHeight: 34,
                              onPressed: () {
                                setState(() {
                                  widget.selected = false;
                                  if (widget.location == StoreLocationsMapState.center &&
                                      widget.zoom == StoreLocationsMapState.zoom) {
                                    StoreLocationsMapState.mapController.move(
                                      widget.lastCenter,
                                      widget.lastZoom,
                                    );
                                  }
                                  widget.markerWidth = 30;
                                  widget.markerHeight = 37 * 2;
                                  StoreLocationsMapState.forceMapRebuild();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.5, vertical: 9.3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.address,
                              style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF000000),
                                height: 1.35,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 7),
                              height: 0.5,
                              width: double.infinity,
                              color: Color(0xFF000000),
                            ),
                            Text(
                              'Opening Hours: \n${widget.openingHours}',
                              style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF000000),
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                SimpleShadow(
                  opacity: 1,
                  color: Color(0x40000000),
                  offset: Offset(2, 1),
                  sigma: 4,
                  child: SvgPicture.asset('assets/icons/triangle.svg', width: 30, height: 26),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
