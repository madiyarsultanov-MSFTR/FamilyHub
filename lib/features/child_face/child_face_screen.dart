import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/child_profile.dart';
import '../../core/theme/colors.dart';
import '../setup/setup_providers.dart';

/// Placeholder for a child's face — filled by a later ticket. Shows whose face
/// it is by resolving [childId] against the stub roster for now.
class ChildFaceScreen extends ConsumerWidget {
  const ChildFaceScreen({super.key, required this.childId});

  final String childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final children = ref.watch(stubChildrenProvider);
    final name = children
        .firstWhere(
          (c) => c.id == childId,
          orElse: () => ChildProfile(id: childId, name: childId),
        )
        .name;
    return Scaffold(
      backgroundColor: HubColors.bg,
      body: Center(
        child: Text('Лицо: $name',
            style: const TextStyle(
                color: HubColors.ink,
                fontSize: 34,
                fontWeight: FontWeight.w600)),
      ),
    );
  }
}
