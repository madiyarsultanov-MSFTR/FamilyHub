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

  // Setup surface only — light "warm paper" per the v2 mock (emerald accent
  // reused above). The ambient faces stay dark; this is the one-time setup look.
  static const paper = Color(0xFFF3EFE6);
  static const paperCard = Color(0xFFFBF9F4);
  static const paperInk = Color(0xFF1C2A22);
  static const paperInkDim = Color(0xFF6C7A70);
  static const paperLine = Color(0xFFE3DDD0);

  /// Dark emerald left rail on the light parent face.
  static const railDark = Color(0xFF0C1D14);

  // Per-person accent palette (agenda borders, family avatars) — stub.
  static const personBlue = Color(0xFF3B82C4);
  static const personRose = Color(0xFFC85C7E);
  static const personAmber = Color(0xFFC98A2E);
  static const personTeal = Color(0xFF2E8B8B);
}
