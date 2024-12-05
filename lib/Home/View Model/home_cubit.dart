import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());


static HomeCubit get(context) => BlocProvider.of(context);
  String address = "Address will appear here.";

  Future<void> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          showToast("Location permission denied");
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      getAddressFromCoordinates(position.latitude, position.longitude);
      emit(GetCurrentLocation());
    } catch (e) {
      showToast("Error getting current location: $e");
    }
  }

  Future<void> getAddressFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      Placemark place = placemarks.first;
        address =
        "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        emit(GetCurrentLocation());
    } catch (e) {
      showToast("Error fetching address: $e");
    }
  }

  Future<void> getAddressFromMapLink(String mapLink) async {
    try {
      Uri uri = Uri.parse(mapLink);
      String? query = uri.queryParameters['query'];

      if (query != null) {
        List<String> coordinates = query.split(',');
        if (coordinates.length == 2) {
          double lat = double.parse(coordinates[0]);
          double lng = double.parse(coordinates[1]);
          getAddressFromCoordinates(lat, lng);
          emit(GetAddressFromMapLink());
        } else {
          showToast("Invalid coordinates in Google Maps link");
        }
      } else {
        showToast("Invalid Google Maps link");
      }
    } catch (e) {
      showToast("Error parsing Google Maps link: $e");
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

}
