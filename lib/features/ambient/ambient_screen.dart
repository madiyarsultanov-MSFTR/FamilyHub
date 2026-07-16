import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/colors.dart';
import '../child_pulse/child_pulse_providers.dart';
import '../child_pulse/child_pulse_screen.dart';
import 'ambient_providers.dart';

/// The always-on main screen — landscape-first. Left: who this hub belongs to.
/// Right: the child's pulse (view-only). Solid emerald blocks, no gradients.
class AmbientScreen extends ConsumerWidget {
  const AmbientScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = ref.watch(ambientTitleProvider);
    final child = ref.watch(childProfileProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- identity block ---
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(
                        color: HubColors.emerald,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2)),
                    const Spacer(),
                    Text('Привет,', style: TextStyle(
                        color: HubColors.inkDim, fontSize: 22)),
                    Text(child.name, style: const TextStyle(
                        color: HubColors.ink,
                        fontSize: 44,
                        fontWeight: FontWeight.w700)),
                    const Spacer(),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              // --- child pulse ---
              const Expanded(flex: 3, child: ChildPulseView()),
            ],
          ),
        ),
      ),
    );
  }
}
