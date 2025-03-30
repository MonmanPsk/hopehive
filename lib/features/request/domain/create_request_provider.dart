import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
