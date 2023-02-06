import 'package:doantotnghiep/bloc/Changetab/changetab_cubit.dart';
import 'package:doantotnghiep/bloc/checkLogged/check_logged_cubit.dart';
import 'package:doantotnghiep/helper/helper_function.dart';
import 'package:doantotnghiep/main.dart';
import 'package:doantotnghiep/screens/connectToFriend.dart';
import 'package:doantotnghiep/NetworkProvider/NetWorkProvider_Auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/plugin_api.dart';

import 'package:latlong2/latlong.dart';

class Tracking extends StatelessWidget {
  Tracking({super.key});
  List<LatLng> polylineCoordinates = [];
  

  @override
  Widget build(BuildContext context) {
   
        return Scaffold(
          // appBar: AppBar(
          //   title: Text(
          //     'Map',
          //     style: TextStyle(color: Colors.black),
          //   ),
          //   // backgroundColor: Colors.yellow,
          //   actions: [
          
          //   ],
          // ),
          body: FlutterMap(
            options: MapOptions(
              center: LatLng(21.0117040, 105.8114780),
              zoom: 5,
            ),
            nonRotatedChildren: [
              AttributionWidget.defaultWidget(
                source: 'OpenStreetMap contributors',
                onSourceTapped: null,
              ),
            ],
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.map',
              ),
              PolygonLayer(
                polygonCulling: false,
                polygons: [
                  Polygon(points: [
                    LatLng(30, 40),
                    LatLng(20, 50),
                    LatLng(25, 45),
                  ], color: Colors.blue, borderStrokeWidth: 3),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                      point: LatLng(21.0117040, 105.8114780),
                      width: 10,
                      height: 10,
                      rotate: true,
                      builder: (context) {
                        print('markerrrr');
                        return Icon(
                          Icons.location_on,
                          color: Colors.red[700],
                        );
                      }),
                  Marker(
                      point: LatLng(20, 50),
                      width: 10,
                      height: 10,
                      rotate: true,
                      builder: (context) {
                        print('markerrrr');
                        return Icon(
                          Icons.location_on,
                          color: Colors.red[700],
                        );
                      }),
                  Marker(
                      point: LatLng(25, 45),
                      width: 10,
                      height: 10,
                      rotate: true,
                      builder: (context) {
                        print('markerrrr');
                        return Icon(
                          Icons.location_on,
                          color: Colors.red[700],
                        );
                      }),
                ],
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ConnectToFriend()));
            },
            backgroundColor: Colors.yellow,
            child: Icon(
              Icons.message,
              color: Colors.black,
            ),
          ),
        
           
        );
     
  }
}
