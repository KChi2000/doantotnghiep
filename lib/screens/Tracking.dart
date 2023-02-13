import 'dart:async';

import 'package:doantotnghiep/model/UserInfo.dart';
import 'package:doantotnghiep/screens/connectToFriend.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Tracking extends StatefulWidget {
  Tracking({super.key});

  @override
  State<Tracking> createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
  // List<LatLng> polylineCoordinates = [];
  late final Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor icon = BitmapDescriptor.defaultMarker;
  @override
  void initState() {
    getIcons();

    super.initState();
  }

  getIcons() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.0), "assets/images/Cùng Phượt.png")
        .then((value) {
      setState(() {
        icon = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Map',
          style: TextStyle(color: Colors.black),
        ),
        // backgroundColor: Colors.yellow,
        actions: [
          SizedBox(
            width: 100,
            child: DropdownButtonHideUnderline(
              child: DropdownButton(items: [
                DropdownMenuItem(
                    child: Text(
                  'Abcs',
                  style: TextStyle(color: Colors.pink, fontSize: 18),
                ))
              ], onChanged: (aa) {}),
            ),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: LatLng(21.028333, 105.853333), zoom: 14.5),
        markers: {
          Marker(
            infoWindow: InfoWindow(title: 'Chi'),
            markerId: MarkerId('ABDG'),
            position: LatLng(21.028333, 105.853333),
            icon: icon
          )
        },
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      // FlutterMap(
      //   options: MapOptions(
      //     center: LatLng(21.0117040, 105.8114780),
      //     zoom: 5,
      //   ),
      //   nonRotatedChildren: [
      //     AttributionWidget.defaultWidget(
      //       source: 'OpenStreetMap contributors',
      //       onSourceTapped: null,
      //     ),
      //   ],
      //   children: [
      //     TileLayer(
      //       urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      //       userAgentPackageName: 'com.example.map',
      //     ),
      //     PolygonLayer(
      //       polygonCulling: false,
      //       polygons: [
      //         Polygon(points: [
      //           LatLng(30, 40),
      //           LatLng(20, 50),
      //           LatLng(25, 45),
      //         ], color: Colors.blue, borderStrokeWidth: 3),
      //       ],
      //     ),
      //     MarkerLayer(
      //       markers: [
      //         Marker(
      //             point: LatLng(21.0117040, 105.8114780),
      //             width: 10,
      //             height: 10,
      //             rotate: true,
      //             builder: (context) {
      //               print('markerrrr');
      //               return Icon(
      //                 Icons.location_on,
      //                 color: Colors.red[700],
      //                 size: 40,
      //               );
      //             }),
      //         Marker(
      //             point: LatLng( 21.59422, 105.84817),
      //             width: 10,
      //             height: 10,
      //             rotate: true,
      //             builder: (context) {
      //               print('markerrrr');
      //               return Icon(

      //                 Icons.location_on,
      //                 color: Colors.red[700],
      //                 size: 40,
      //               );
      //             }),
      //         Marker(
      //             point: LatLng( 21.18608, 106.07631),
      //             width: 10,
      //             height: 10,
      //             rotate: true,
      //             builder: (context) {
      //               print('markerrrr');
      //               return
      //             //  ClipPath(clipper: CustomClipPath(),child: Container(height: 20,width: 20,),);
      //               Icon(
      //                 Icons.location_on,
      //                 color: Colors.red[700],
      //                 size: 40,
      //               );
      //             }),
      //       ],
      //     ),
      //   ],
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => ConnectToFriend()));
      //   },
      //   backgroundColor: Colors.yellow,
      //   child: Icon(
      //     Icons.message,
      //     color: Colors.black,
      //   ),
      // ),
    );
  }
}
