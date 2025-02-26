import 'package:geolocator/geolocator.dart';

class LocationMethods{
  static Future<void> getUserLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permission denied");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permission permanently denied. Open settings.");
      await Geolocator.openAppSettings();
      return;
    }

    // Use the new settings parameter instead of deprecated desiredAccuracy
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high, // Same as before, but using new method
      ),
    );

    print("Latitude: ${position.latitude}, Longitude: ${position.longitude}");
  }

}