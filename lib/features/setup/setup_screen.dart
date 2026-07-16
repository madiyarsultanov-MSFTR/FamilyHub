import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/device/device_mode.dart';
import '../../core/device/hub_face_store.dart';
import '../../core/models/child_profile.dart';
import '../../core/theme/colors.dart';
import 'setup_providers.dart';

/// One-time setup: "Whose device is this?" → parent, or a child (with a code
/// field stub). The choice is saved locally (SharedPreferences) and the router
/// then routes to the matching face. Light "warm paper" surface, landscape.
class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  String? _selectedChildId;
  final _code = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _choose(HubFace face) async {
    if (_saving) return;
    setState(() => _saving = true);
    await ref.read(hubFaceControllerProvider.notifier).choose(face);
    if (!mounted) return;
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final children = ref.watch(stubChildrenProvider);
    return Scaffold(
      backgroundColor: HubColors.paper,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('OYNA HOME',
                      style: TextStyle(
                          color: HubColors.emeraldDark,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2)),
                  const SizedBox(height: 12),
                  const Text('Чьё это устройство?',
                      style: TextStyle(
                          color: HubColors.paperInk,
                          fontSize: 32,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  const Text('Выберите, чьё лицо показывать на этом экране.',
                      style: TextStyle(
                          color: HubColors.paperInkDim, fontSize: 15)),
                  const SizedBox(height: 28),
                  _OptionTile(
                    icon: Icons.person_outline_rounded,
                    label: 'Родитель',
                    subtitle: 'Витрина роста ребёнка',
                    selected: false,
                    onTap: () => _choose(const ParentFace()),
                  ),
                  const SizedBox(height: 12),
                  for (final c in children) ...[
                    _OptionTile(
                      icon: Icons.child_care_rounded,
                      label: c.name,
                      subtitle: c.age == null ? 'Ребёнок' : '${c.age} лет',
                      selected: _selectedChildId == c.id,
                      onTap: () =>
                          setState(() => _selectedChildId = c.id),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (_selectedChildId != null) _codeSection(children),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _codeSection(List<ChildProfile> children) {
    final name = children
        .firstWhere((c) => c.id == _selectedChildId,
            orElse: () => ChildProfile(id: _selectedChildId!, name: ''))
        .name;
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: HubColors.paperCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: HubColors.paperLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Код для входа · $name',
              style: const TextStyle(
                  color: HubColors.paperInk,
                  fontSize: 15,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          TextField(
            controller: _code,
            style: const TextStyle(color: HubColors.paperInk, fontSize: 16),
            cursorColor: HubColors.emerald,
            decoration: InputDecoration(
              hintText: 'Введите код',
              hintStyle: const TextStyle(color: HubColors.paperInkDim),
              filled: true,
              fillColor: HubColors.paper,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: HubColors.paperLine),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: HubColors.emerald, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: _saving
                  ? null
                  : () => _choose(ChildFace(_selectedChildId!)),
              style: FilledButton.styleFrom(
                backgroundColor: HubColors.emerald,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 22, vertical: 14),
              ),
              child: const Text('Продолжить',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: HubColors.paperCard,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? HubColors.emerald : HubColors.paperLine,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: HubColors.emerald.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: HubColors.emeraldDark, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: const TextStyle(
                            color: HubColors.paperInk,
                            fontSize: 17,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: const TextStyle(
                            color: HubColors.paperInkDim, fontSize: 13)),
                  ],
                ),
              ),
              Icon(
                selected
                    ? Icons.check_circle_rounded
                    : Icons.chevron_right_rounded,
                color: selected ? HubColors.emerald : HubColors.paperInkDim,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
