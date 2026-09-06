import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/food_listing_model.dart';
import '../models/order_model.dart';
import '../models/rating_model.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ============ FOOD LISTINGS ============

  Future<String?> createFoodListing(FoodListingModel listing) async {
    try {
      final docRef = await _firestore.collection('foodListings').add(listing.toMap());
      return docRef.id;
    } catch (e) {
      print('Error creating food listing: $e');
      return null;
    }
  }

  Future<FoodListingModel?> getFoodListing(String id) async {
    try {
      final doc = await _firestore.collection('foodListings').doc(id).get();
      if (doc.exists) {
        return FoodListingModel.fromMap({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      print('Error getting food listing: $e');
      return null;
    }
  }

  Future<List<FoodListingModel>> getFoodListingsNearby({
    required double latitude,
    required double longitude,
    required double radiusInKm,
    required ListingStatus? status,
  }) async {
    try {
      final listings = <FoodListingModel>[];
      final querySnapshot = await _firestore
          .collection('foodListings')
          .where('status', isEqualTo: status?.toString().split('.').last ?? 'available')
          .get();

      for (var doc in querySnapshot.docs) {
        final listing = FoodListingModel.fromMap({...doc.data(), 'id': doc.id});
        final distance = _calculateDistance(
          latitude,
          longitude,
          listing.latitude,
          listing.longitude,
        );

        if (distance <= radiusInKm) {
          listings.add(listing);
        }
      }

      listings.sort((a, b) => _calculateDistance(
            latitude,
            longitude,
            a.latitude,
            a.longitude,
          ).compareTo(
            _calculateDistance(
              latitude,
              longitude,
              b.latitude,
              b.longitude,
            ),
          ));

      return listings;
    } catch (e) {
      print('Error getting nearby food listings: $e');
      return [];
    }
  }

  Future<List<FoodListingModel>> getRestaurantListings(String restaurantId) async {
    try {
      final querySnapshot = await _firestore
          .collection('foodListings')
          .where('restaurantId', isEqualTo: restaurantId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => FoodListingModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error getting restaurant listings: $e');
      return [];
    }
  }

  Future<bool> updateFoodListing(String id, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = Timestamp.now();
      await _firestore.collection('foodListings').doc(id).update(data);
      return true;
    } catch (e) {
      print('Error updating food listing: $e');
      return false;
    }
  }

  // ============ ORDERS ============

  Future<String?> createOrder(OrderModel order) async {
    try {
      final docRef = await _firestore.collection('orders').add(order.toMap());
      return docRef.id;
    } catch (e) {
      print('Error creating order: $e');
      return null;
    }
  }

  Future<OrderModel?> getOrder(String id) async {
    try {
      final doc = await _firestore.collection('orders').doc(id).get();
      if (doc.exists) {
        return OrderModel.fromMap({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      print('Error getting order: $e');
      return null;
    }
  }

  Future<List<OrderModel>> getUserOrders(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => OrderModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error getting user orders: $e');
      return [];
    }
  }

  Future<List<OrderModel>> getRestaurantOrders(String restaurantId) async {
    try {
      final querySnapshot = await _firestore
          .collection('orders')
          .where('restaurantId', isEqualTo: restaurantId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => OrderModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error getting restaurant orders: $e');
      return [];
    }
  }

  Future<List<OrderModel>> getVolunteerOrders(String volunteerId) async {
    try {
      final querySnapshot = await _firestore
          .collection('orders')
          .where('volunteerId', isEqualTo: volunteerId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => OrderModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error getting volunteer orders: $e');
      return [];
    }
  }

  Future<bool> updateOrder(String id, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('orders').doc(id).update(data);
      return true;
    } catch (e) {
      print('Error updating order: $e');
      return false;
    }
  }

  // ============ RATINGS ============

  Future<String?> createRating(RatingModel rating) async {
    try {
      final docRef = await _firestore.collection('ratings').add(rating.toMap());
      return docRef.id;
    } catch (e) {
      print('Error creating rating: $e');
      return null;
    }
  }

  Future<List<RatingModel>> getUserRatings(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('ratings')
          .where('ratedUserId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => RatingModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error getting user ratings: $e');
      return [];
    }
  }

  // ============ STATISTICS ============

  Future<Map<String, dynamic>> getStatistics() async {
    try {
      final listingsCount = await _firestore.collection('foodListings').count().get();
      final ordersCount = await _firestore.collection('orders').count().get();
      final usersCount = await _firestore.collection('users').count().get();

      return {
        'totalListings': listingsCount.count,
        'totalOrders': ordersCount.count,
        'totalUsers': usersCount.count,
      };
    } catch (e) {
      print('Error getting statistics: $e');
      return {};
    }
  }

  // ============ HELPER FUNCTIONS ============

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadiusKm = 6371.0;
    final double dLat = _toRadian(lat2 - lat1);
    final double dLon = _toRadian(lon2 - lon1);
    final double a = (Math.sin(dLat / 2) * Math.sin(dLat / 2)) +
        (Math.cos(_toRadian(lat1)) *
            Math.cos(_toRadian(lat2)) *
            Math.sin(dLon / 2) *
            Math.sin(dLon / 2));
    final double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  double _toRadian(double degree) {
    return degree * (3.141592653589793 / 180);
  }
}

class Math {
  static double sin(double x) => throw UnimplementedError();
  static double cos(double x) => throw UnimplementedError();
  static double atan2(double y, double x) => throw UnimplementedError();
  static double sqrt(double x) => throw UnimplementedError();
}
