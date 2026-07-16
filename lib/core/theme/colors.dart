import 'package:flutter/material.dart';

/// FamilyHub brand tokens — **emerald**, not the phone app's gold (CONTRACT §4 /
/// README). Backgrounds are solid colour blocks, never gradients.
class HubColors {
  const HubColors._();

  /// GDARK emerald — deep base for the always-on surface.
  static const emeraldDark = Color(0xFF0E7A40);

  /// Primary emerald — accents, active states.
  static const emerald = Color(0xFF159A55);

  static const bg = Color(0xFF0B1F14); // near-black green, solid
  static const surface = Color(0xFF123024); // solid card block
  static const line = Color(0xFF1E4632);

  static const ink = Color(0xFFF1F7F3);
  static const inkDim = Color(0xFF9CB7A8);
}
