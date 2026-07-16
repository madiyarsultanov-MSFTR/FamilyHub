import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';

/// Placeholder for the parent face — filled by a later ticket (likely the
/// ambient child-pulse view). Empty stub for now.
class ParentFaceScreen extends StatelessWidget {
  const ParentFaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: HubColors.bg,
      body: Center(
        child: Text('Лицо родителя',
            style: TextStyle(
                color: HubColors.ink,
                fontSize: 34,
                fontWeight: FontWeight.w600)),
      ),
    );
  }
}
