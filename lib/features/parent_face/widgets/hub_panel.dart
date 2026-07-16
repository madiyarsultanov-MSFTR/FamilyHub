import 'package:flutter/material.dart';

import '../../../core/theme/colors.dart';

/// Shared light panel for the parent-face columns — solid block, no gradient.
class HubPanel extends StatelessWidget {
  const HubPanel({super.key, required this.title, required this.child, this.trailing});

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HubColors.paperCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: HubColors.paperLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title,
                  style: const TextStyle(
                      color: HubColors.paperInk,
                      fontSize: 17,
                      fontWeight: FontWeight.w700)),
              if (trailing != null) ...[const Spacer(), trailing!],
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
