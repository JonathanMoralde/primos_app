import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_auth/firebase_auth.dart';

final userProvider = StateProvider<User?>((ref) => null);
