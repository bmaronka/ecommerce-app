import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final dateFormatterProvider = Provider<DateFormat>((ref) => DateFormat.MMMEd());
