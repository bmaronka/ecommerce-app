import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentDateBuilderProvider = Provider<DateTime Function()>((ref) => DateTime.now);
