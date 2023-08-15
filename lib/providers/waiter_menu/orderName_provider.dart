import 'package:flutter_riverpod/flutter_riverpod.dart';

final orderNameProvider = StateProvider<String?>((ref) => null);

final lastTakeoutNumberProvider = StateProvider<int>((ref) => 0);
final lastOrderDateProvider = StateProvider<DateTime?>((ref) => null);
