import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/orderObject.dart';

final currentOrdersProvider = StateProvider<List<OrderObject>>((ref) => []);
