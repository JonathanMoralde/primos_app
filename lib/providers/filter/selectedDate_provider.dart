import 'package:flutter_riverpod/flutter_riverpod.dart';

// class SelectedDateNotifier extends StateNotifier<DateTime?> {
//   SelectedDateNotifier() : super(null);

//   void setDate(DateTime? date) {
//     state = date;
//   }
// }

// final selectedDateProvider1 =
//     StateNotifierProvider<SelectedDateNotifier, DateTime?>((ref) {
//   return SelectedDateNotifier();
// });
// final selectedDateProvider2 =
//     StateNotifierProvider<SelectedDateNotifier, DateTime?>((ref) {
//   return SelectedDateNotifier();
// });
// final selectedDateProvider3 =
//     StateNotifierProvider<SelectedDateNotifier, DateTime?>((ref) {
//   return SelectedDateNotifier();
// });

final selectedDate1Provider = StateProvider<DateTime?>((ref) => null);
final selectedDate2Provider = StateProvider<DateTime?>((ref) => null);
final isReset = StateProvider<bool>((ref) => false);
