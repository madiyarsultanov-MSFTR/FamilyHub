import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

/// Root widget — MaterialApp.router wired to the hub theme and GoRouter.
class FamilyHubApp extends ConsumerWidget {
  const FamilyHubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'OYNA Home',
      debugShowCheckedModeBanner: false,
      theme: buildHubTheme(),
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
