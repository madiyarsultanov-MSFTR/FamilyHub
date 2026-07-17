import 'package:flutter/material.dart';

import '../../../core/theme/colors.dart';

/// «Моё / Кто чем занят» switcher. `busy == true` → the shared read-only
/// calendar view.
class ChildSwitcher extends StatelessWidget {
  const ChildSwitcher({super.key, required this.busy, required this.onChanged});

  final bool busy;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: HubColors.childCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: HubColors.paperLine),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _seg('Моё', !busy, () => onChanged(false)),
          _seg('Кто чем занят', busy, () => onChanged(true)),
        ],
      ),
    );
  }

  Widget _seg(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: active ? HubColors.emerald : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            style: TextStyle(
                color: active ? Colors.white : HubColors.paperInkDim,
                fontSize: 14,
                fontWeight: FontWeight.w600)),
      ),
    );
  }
}
