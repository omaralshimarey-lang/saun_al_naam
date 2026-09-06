import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUser == null) return null;
      final doc = await _firestore.collection('users').doc(currentUser!.uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() ?? {});
      }
      return null;
    } catch (e) {
      print('Error getting current user data: $e');
      return null;
    }
  }

  Future<String?> registerUser({
    required String email,
    required String password,
    required String phone,
    required String name,
    required UserType userType,
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = UserModel(
        id: userCredential.user!.uid,
        email: email,
        phone: phone,
        name: name,
        profileImage: '',
        userType: userType,
        latitude: latitude,
        longitude: longitude,
        address: address,
        isVerified: false,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set(user.toMap());

      return userCredential.user!.uid;
    } on FirebaseAuthException catch (e) {
      print('Registration error: ${e.message}');
      return null;
    }
  }

  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      print('Login error: ${e.message}');
      return false;
    }
  }

  Future<bool> logoutUser() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print('Logout error: $e');
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      print('Reset password error: ${e.message}');
      return false;
    }
  }

  Future<bool> updateUserProfile({
    required String userId,
    String? name,
    String? profileImage,
    String? address,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (name != null) updateData['name'] = name;
      if (profileImage != null) updateData['profileImage'] = profileImage;
      if (address != null) updateData['address'] = address;
      if (latitude != null) updateData['latitude'] = latitude;
      if (longitude != null) updateData['longitude'] = longitude;
      updateData['updatedAt'] = Timestamp.now();

      await _firestore.collection('users').doc(userId).update(updateData);
      return true;
    } catch (e) {
      print('Update profile error: $e');
      return false;
    }
  }

  Future<bool> verifyUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'isVerified': true,
        'updatedAt': Timestamp.now(),
      });
      return true;
    } catch (e) {
      print('Verify user error: $e');
      return false;
    }
  }
}
