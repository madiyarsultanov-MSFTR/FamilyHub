import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors.dart';

/// Dark emerald navigation rail on the light parent face. Only "Главная" leads
/// to real content; Календарь/Карта are stub routes ("скоро"); Заставка → idle.
class LeftRail extends StatelessWidget {
  const LeftRail({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = GoRouterState.of(context).matchedLocation;
    return Container(
      width: 74,
      color: HubColors.railDark,
      child: SafeArea(
        right: false,
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: HubColors.emerald.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('O',
                  style: TextStyle(
                      color: HubColors.emerald,
                      fontSize: 22,
                      fontWeight: FontWeight.w800)),
            ),
            const SizedBox(height: 28),
            _RailItem(icon: Icons.home_rounded, path: '/', current: loc),
            _RailItem(
                icon: Icons.calendar_today_rounded, path: '/cal', current: loc),
            _RailItem(icon: Icons.map_rounded, path: '/map', current: loc),
            const Spacer(),
            _RailItem(
                icon: Icons.nightlight_round, path: '/idle', current: loc),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _RailItem extends StatelessWidget {
  const _RailItem(
      {required this.icon, required this.path, required this.current});

  final IconData icon;
  final String path;
  final String current;

  @override
  Widget build(BuildContext context) {
    final active = current == path;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: active ? null : () => context.go(path),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 46,
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active
                ? HubColors.emerald.withValues(alpha: 0.16)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon,
              color: active ? HubColors.emerald : Colors.white38, size: 24),
        ),
      ),
    );
  }
}
