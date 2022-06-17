import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:swiper_app/src/models/chat_user_model.dart';
import 'package:geocoding/geocoding.dart' as geo;

class UserController with ChangeNotifier {
  late StreamSubscription _userSub;
  late StreamSubscription _threadSub;
  List<ChatUser> users = [];
  List<ChatUser> threads = [];

  late LocationData currentLocation;
  late List<geo.Placemark> placemarks;
  final StreamController<String?> _controller =
      StreamController<String?>.broadcast();
  Stream<String?> get stream => _controller.stream;

  UserController() {
    _userSub = ChatUser.appUsers().listen(userCountHandler);
    _threadSub = ChatUser.currentThreads().listen(threadHandler);
    onStartUp();
  }

  @override
  void dispose() {
    _userSub.cancel();
    _threadSub.cancel();
    super.dispose();
  }

  void onStartUp() async {
    _controller.add(null);
    try {
      currentLocation = await getLocation();
      placemarks = await setLocation(
          currentLocation.latitude, currentLocation.longitude);
      _controller.add("success");
    } catch (e) {
      print(e);
      _controller.addError((e));
    }
  }

  setLocation(lat, long) async {
    return await geo.placemarkFromCoordinates(lat, long);
  }

  getLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

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

    _locationData = await location.getLocation();
    currentLocation = _locationData;
    return currentLocation;
  }

  threadHandler(List<ChatUser> update) {
    threads = update;
    notifyListeners();
  }

  userCountHandler(List<ChatUser> update) {
    users = update;
    notifyListeners();
  }
}
