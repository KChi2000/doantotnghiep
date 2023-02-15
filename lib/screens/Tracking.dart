import 'dart:async';

import 'package:doantotnghiep/bloc/FetchLocation/fetch_location_cubit.dart';
import 'package:doantotnghiep/model/UserInfo.dart';
import 'package:doantotnghiep/screens/connectToFriend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../bloc/GroupInfoCubit/group_info_cubit_cubit.dart';
import '../bloc/getUserGroup/get_user_group_cubit.dart';

class Tracking extends StatefulWidget {
  Tracking({super.key});

  @override
  State<Tracking> createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
  // List<LatLng> polylineCoordinates = [];
  late final Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor icon = BitmapDescriptor.defaultMarker;
  final GlobalKey globalKey = GlobalKey();
  @override
  void initState() {
    context.read<FetchLocationCubit>().requestLocation();
    
    getIcons();
    context.read<GetUserGroupCubit>().getUerGroup();
    super.initState();
  }

  getIcons() async {
    // BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
    //     ImageConfiguration(devicePixelRatio: 2.0), "assets/images/travel.jpeg");

    // setState(() {
    //   icon = markerbitmap;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Map',
                  style: TextStyle(color: Colors.black),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.pink, width: 1.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: BlocBuilder<GetUserGroupCubit, GetUserGroupState>(
                      builder: (context, state) {
                        return StreamBuilder(
                            stream: state.stream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                context
                                    .read<GroupInfoCubitCubit>()
                                    .updateGroup(snapshot.data);
                                return BlocBuilder<GroupInfoCubitCubit,
                                    GroupInfoCubitState>(
                                  builder: (context, state) {
                                    if (state is GroupInfoCubitLoaded) {
                                      return Container(
                                      
                                       constraints: BoxConstraints(minWidth: 100,maxWidth: 250),
                                        child: DropdownButtonFormField(
                                         
                                          isExpanded: true,
                                              value: state.selected,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              items: state.groupinfo!
                                                  .map((e) => DropdownMenuItem(
                                                      value: e,
                                                      child: Text(
                                                        '${e.groupName}',
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                            color: Colors.pink,
                                                            fontSize: 18),
                                                      )))
                                                  .toList(),
                                              onChanged: (value) {
                                              //   print('click on ${value!.groupName.toString()}');
                                              // context.read<GroupInfoCubitCubit>().selectToShowLocation(value);
                                              }
                                        ),
                                      );
                                    }
                                    return DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          hint: Text('Đang tải...',style: TextStyle(color: Colors.grey),),
                                          items: [
                                            // DropdownMenuItem(
                                            //     child: Text(
                                            //   'Đi phượt',
                                            //   style: TextStyle(
                                            //       color: Colors.pink,
                                            //       fontSize: 18),
                                            // ))
                                          ],
                                          onChanged: (aa) {}),
                                    );
                                  },
                                );
                              }

                              return DropdownButtonHideUnderline(
                                child: DropdownButton(
                                    borderRadius: BorderRadius.circular(5),
                                    value: 'Đang tải...',
                                    hint: Text('Đang tải...'),
                                    items: [
                                      // DropdownMenuItem(
                                      //     child: Text(
                                      //   'Đi phượt',
                                      //   style: TextStyle(
                                      //       color: Colors.pink,
                                      //       fontSize: 18),
                                      // ))
                                    ],
                                    onChanged: (aa) {}),
                              );
                            });
                      },
                    ),
                  ),
                ),
              ],
            ),
            // backgroundColor: Colors.yellow,
            actions: [],
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              // customMarker(globalKey),
              Positioned.fill(
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(21.5752612 ,105.8281156), zoom: 14.5),
                  markers: {
                    Marker(
                        infoWindow: InfoWindow(title: 'Chi'),
                        markerId: MarkerId('G'),
                        position: LatLng(21.5752612 ,105.8281156),
                        icon: icon),
                    // Marker(
                    //   infoWindow: InfoWindow(title: 'Yến'),
                    //   markerId: MarkerId('A'),
                    //   position: LatLng(21.000341, 105.842419),
                    //   // icon: icon
                    // ),
                    // Marker(
                    //   infoWindow: InfoWindow(title: 'Linh'),
                    //   markerId: MarkerId('AB'),
                    //   position: LatLng(21.037500, 105.833362),
                    //   // icon: icon
                    // )
                  },
                  // onMapCreated: (GoogleMapController controller) {
                  //   _controller.complete(controller);
                  // },
                ),
              ),
            ],
          ),
        
        ),
      ],
    );
  }
}
