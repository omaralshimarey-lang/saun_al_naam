import 'package:cloud_firestore/cloud_firestore.dart';

class RatingModel {
  final String id;
  final String orderId;
  final String ratedUserId;
  final String ratedByUserId;
  final double rating;
  final String comment;
  final List<String> images;
  final DateTime createdAt;
  final Map<String, dynamic> additionalData;

  RatingModel({
    required this.id,
    required this.orderId,
    required this.ratedUserId,
    required this.ratedByUserId,
    required this.rating,
    required this.comment,
    this.images = const [],
    required this.createdAt,
    this.additionalData = const {},
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderId': orderId,
      'ratedUserId': ratedUserId,
      'ratedByUserId': ratedByUserId,
      'rating': rating,
      'comment': comment,
      'images': images,
      'createdAt': Timestamp.fromDate(createdAt),
      ...additionalData,
    };
  }

  factory RatingModel.fromMap(Map<String, dynamic> map) {
    return RatingModel(
      id: map['id'] ?? '',
      orderId: map['orderId'] ?? '',
      ratedUserId: map['ratedUserId'] ?? '',
      ratedByUserId: map['ratedByUserId'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      comment: map['comment'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      additionalData: map,
    );
  }
}
