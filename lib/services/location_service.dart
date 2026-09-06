import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  Future<bool> requestLocationPermission() async {
    final permission = await Geolocator.requestPermission();
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  Future<Position?> getCurrentLocation() async {
    try {
      final hasPermission = await Geolocator.checkPermission();
      if (hasPermission == LocationPermission.denied) {
        await requestLocationPermission();
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
    } catch (e) {
      print('Error getting current location: $e');
      return null;
    }
  }

  Future<String?> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks[0];
        return '${place.street}, ${place.locality}, ${place.administrativeArea}';
      }
      return null;
    } catch (e) {
      print('Error getting address: $e');
      return null;
    }
  }

  Future<Position?> getCoordinatesFromAddress(String address) async {
    try {
      final locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        return Position(
          latitude: locations[0].latitude,
          longitude: locations[0].longitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
        );
      }
      return null;
    } catch (e) {
      print('Error getting coordinates: $e');
      return null;
    }
  }
}
