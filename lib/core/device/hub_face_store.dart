import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'device_mode.dart';

const _kHubFaceKey = 'hub_face';

/// Local persistence for the chosen [HubFace]. Device-local only
/// (SharedPreferences) — no Supabase, no migrations (CONTRACT §1).
class HubFaceStore {
  HubFaceStore(this._prefs);

  final SharedPreferences _prefs;

  HubFace? read() => HubFace.decode(_prefs.getString(_kHubFaceKey));

  Future<void> write(HubFace face) =>
      _prefs.setString(_kHubFaceKey, face.encode());

  Future<void> clear() => _prefs.remove(_kHubFaceKey);
}

/// Overridden in `main()` with the loaded instance.
final sharedPreferencesProvider = Provider<SharedPreferences>((_) {
  throw UnimplementedError(
      'sharedPreferencesProvider must be overridden in main()');
});

final hubFaceStoreProvider = Provider<HubFaceStore>((ref) {
  return HubFaceStore(ref.watch(sharedPreferencesProvider));
});

/// The device's current face — `null` until setup makes a choice.
class HubFaceController extends Notifier<HubFace?> {
  @override
  HubFace? build() => ref.watch(hubFaceStoreProvider).read();

  Future<void> choose(HubFace face) async {
    await ref.read(hubFaceStoreProvider).write(face);
    state = face;
  }

  Future<void> reset() async {
    await ref.read(hubFaceStoreProvider).clear();
    state = null;
  }
}

final hubFaceControllerProvider =
    NotifierProvider<HubFaceController, HubFace?>(HubFaceController.new);
