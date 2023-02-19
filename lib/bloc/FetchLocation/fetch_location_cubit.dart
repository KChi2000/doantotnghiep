import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:doantotnghiep/NetworkProvider/Networkprovider.dart';
import 'package:equatable/equatable.dart';
import 'package:location/location.dart';

part 'fetch_location_state.dart';

class FetchLocationCubit extends Cubit<FetchLocationState> {
  FetchLocationCubit() : super(FetchLocationState(location: Location()));
  requestLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    Location location = Location();
    _serviceEnabled = await location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();

      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    // if (_permissionGranted == PermissionStatus.granted) {
    //   LocationData currentLocation = await location.getLocation();
    //   await DatabaseService().pushLocation(currentLocation);
    //   print(
    //       'YOUR LOCATIONn : ${currentLocation.latitude} ${currentLocation.longitude}');
    // }
  }

  UpdateLocation() async {
    Timer.periodic(
      Duration(minutes: 5),
      (timer) async {
        bool _serviceEnabled;
        PermissionStatus _permissionGranted;
        Location location = Location();
        _serviceEnabled = await location.serviceEnabled();

        if (!_serviceEnabled) {
          _serviceEnabled = await location.requestService();

          if (!_serviceEnabled) {
            return;
          }
        }

        _permissionGranted = await location.hasPermission();
        if (_permissionGranted == PermissionStatus.denied) {
          _permissionGranted = await location.requestPermission();
          if (_permissionGranted != PermissionStatus.granted) {
            return;
          }
        }
        if (_permissionGranted == PermissionStatus.granted) {
          LocationData currentLocation = await location.getLocation();
          await DatabaseService().pushLocation(currentLocation);
          print(
              'Update LOCATION : ${currentLocation.latitude} ${currentLocation.longitude}');
        }
      },
    );
  }
}
