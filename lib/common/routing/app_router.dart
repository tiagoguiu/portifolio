import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/home/pages/home_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [GoRoute(path: '/', builder: (context, state) => const HomePage())],
    errorBuilder: (context, state) => const Scaffold(body: Center(child: Text('Page not found'))),
  );
});
