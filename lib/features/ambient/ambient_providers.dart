import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Ambient-surface level state. Kept tiny for now — the product title shown on
/// the always-on panel. Grows into idle/awake state, time-of-day, etc.
final ambientTitleProvider = Provider<String>((_) => 'OYNA Home');
