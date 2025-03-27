import 'package:flutter_riverpod/flutter_riverpod.dart';

final registerIsLoadingProvider = StateProvider<bool>((ref) => false);
final registerErrorMessageProvider = StateProvider<String?>((ref) => null);
