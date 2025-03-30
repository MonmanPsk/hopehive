import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final locationProvider = StateProvider<GeoPoint?>((ref) => const GeoPoint(13.6851631, 13.165456));
final imageProvider = StateProvider<List<File>>((ref) => []);
final categoryProvider = StateProvider<String?>((ref) => null);
final categoryListProvider = Provider<List<String>>((ref) => [
      'Essential Needs',
      'Electronics & Gadgets',
      'Educational & Office',
      'Medical & Healthcare',
      'Baby & Kids',
      'Furniture & Home Items',
      'Sports & Recreation',
      'Miscellaneous & Other',
    ]);
final conditionPreferenceProvider = StateProvider<String?>((ref) => null);
final conditionPreferenceListProvider = Provider<List<String>>((ref) => [
      'New',
      'Like New',
      'Gently Used',
      'Fair Condition',
      'Heavily Used',
    ]);
final quantityProvider = StateProvider<int>((ref) => 1);
final deliveryOptionProvider = StateProvider<String>((ref) => 'Delivery');
final urgencyProvider = StateProvider<String>((ref) => 'Flexible');
final contactInfoProvider = StateProvider<List<Map<String, String?>>>((ref) => []);
final isLoadingProvider = StateProvider<bool>((ref) => false);
