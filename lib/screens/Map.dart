import 'dart:async';

import 'package:doantotnghiep/bloc/FetchLocation/fetch_location_cubit.dart';
import 'package:doantotnghiep/bloc/fetchLocationToShow/fetch_location_to_show_cubit.dart';
import 'package:doantotnghiep/model/UserInfo.dart';
import 'package:doantotnghiep/screens/Chat/connectToFriend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../bloc/GroupInfoCubit/group_info_cubit_cubit.dart';
import '../bloc/getProfile/get_profile_cubit.dart';
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

    context.read<GetUserGroupCubit>().getUerGroup();
    // context.read<FetchLocationCubit>().UpdateLocation();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayOpacity: 0.6,
      overlayWidget: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(
            height: 10,
          ),
          Text(
            'Đang lấy dữ liệu...',
            style: TextStyle(color: Colors.white),
          )
        ],
      )),
      child: Scaffold(
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
                                    print(
                                        'DATA FROM FIREBASE: ${state.groupinfo!.length}');
                                    if (state.groupinfo!.length == 0) {
                                      return SizedBox();
                                    }
                                    context
                                        .read<FetchLocationToShowCubit>()
                                        .fetchFromDb(state.groupinfo!.last);
                                    return Container(
                                      constraints:
                                          BoxConstraints(maxWidth: 200),
                                      child: DropdownButtonFormField(
                                          isExpanded: true,
                                          value: state.groupinfo!.last,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          items: state.groupinfo!
                                              .map((e) => DropdownMenuItem(
                                                  value: e,
                                                  child: Text(
                                                    '${e.groupName}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors.pink,
                                                        fontSize: 18),
                                                  )))
                                              .toList(),
                                          decoration: InputDecoration(
                                              border: UnderlineInputBorder(
                                                  borderSide: BorderSide.none)),
                                          onChanged: (value) {
                                            if (value!.groupId.toString() !=
                                                (context
                                                            .read<
                                                                FetchLocationToShowCubit>()
                                                            .state
                                                        as FetchLocationToShowLoaded)
                                                    .selectedGroup
                                                    .groupId) {
                                              context
                                                  .read<
                                                      FetchLocationToShowCubit>()
                                                  .fetchFromDb(value!);
                                              // context
                                              //     .read<GroupInfoCubitCubit>()
                                              //     .changeSelectedGroup(value!);
                                            }
                                          }),
                                    );
                                  }
                                  return DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                        borderRadius: BorderRadius.circular(5),
                                        hint: Text(
                                          'Đang tải...',
                                          style: TextStyle(color: Colors.pink),
                                        ),
                                        items: [],
                                        onChanged: (aa) {}),
                                  );
                                },
                              );
                            }

                            return DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  borderRadius: BorderRadius.circular(5),
                                  value: 'Đang tải...',
                                  hint: Text(
                                    'Đang tải...',
                                    style: TextStyle(color: Colors.pink),
                                  ),
                                  items: [],
                                  onChanged: (aa) {}),
                            );
                          });
                    },
                  ),
                ),
              ),
            ],
          ),
          actions: [],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: BlocBuilder<FetchLocationToShowCubit,
                  FetchLocationToShowState>(
                builder: (context, state) {
                  if (state is FetchLocationToShowLoading) {
                    context.loaderOverlay.show();
                  } else if (state is FetchLocationToShowLoaded) {
                    context.loaderOverlay.hide();
                    return GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                          target: LatLng(21.5752612, 105.8281156), zoom: 8),
                      markers: state.list
                          .map(
                            (e) => Marker(
                                infoWindow: InfoWindow(
                                    title: Userinfo.userSingleton.uid == e.uid
                                        ? 'bạn'
                                        : '${e.name}'),
                                markerId: MarkerId('${e.uid}'),
                                position: LatLng(e.location!.latitude!,
                                    e.location!.longitude!),
                                icon: Userinfo.userSingleton.uid == e.uid
                                    ? BitmapDescriptor.defaultMarkerWithHue(
                                        BitmapDescriptor.hueRose)
                                    : icon),
                          )
                          .toSet(),
                    );
                  }
                  return GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(21.5752612, 105.8281156), zoom: 8),
                    markers: {
                      // Marker(
                      //     infoWindow: InfoWindow(title: 'Chi'),
                      //     markerId: MarkerId('G'),
                      //     position: LatLng(21.5752612, 105.8281156),
                      //     icon: icon),
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
