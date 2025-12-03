import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:soulware_app/core/services/session_provider.dart';
import 'package:soulware_app/features/auth/presentation/login/login_page.dart';
import 'package:soulware_app/features/sessions/presentation/sessions_legal_page.dart';
import 'package:soulware_app/features/sessions/presentation/sessions_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',

    redirect: (context, state) async {
      final container = ProviderScope.containerOf(context);
      final session = container.read(sessionServiceProvider);

      final logged = await session.isLogged();
      final role = await session.getRole();
      final isLogin = state.matchedLocation == '/login';

      if (!logged && !(isLogin)) {
        return '/login';
      }

      if (logged && (isLogin)) {
        return '/login';
      }

      if (role == "LEGAL_RESPONSIBLE" && state.matchedLocation == '/home') {
        return '/legal';
      }

      if (role == "THERAPIST" && state.matchedLocation == '/home') {
        return '/therapist';
      }

      // Legal Responsable no puede acceder a rutas de Therapist
      if (role == "LEGAL_RESPONSIBLE" &&
          state.matchedLocation == '/therapist') {
        return '/legal';
      }

      // Therapist no puede acceder a rutas de Legal
      if (role == "THERAPIST" && state.matchedLocation == '/legal') {
        return '/therapist';
      }

      return null;
    },

    routes: [
      // ---------- RUTAS SIN APPBAR ----------
      GoRoute(path: '/login', name: 'login', builder: (_, __) => LoginPage()),

      // ---------- RUTAS CON APPBAR + DRAWER ----------
      ShellRoute(
        builder: (context, state, child) {
          final title = _getTitleFor(state.matchedLocation);

          return Scaffold(
            appBar: AppBar(
              title: Text(title),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
            ),

            body: child,

            // ---------- NUEVO NAVIGATION BAR ----------
            bottomNavigationBar: FutureBuilder(
              future: ref.read(sessionServiceProvider).getRole(),
              builder: (context, snapshot) {
                final role = snapshot.data;

                // Items según el ROL
                final items = <_NavItem>[];

                if (role == null) {
                  return SizedBox(height: 65); 
                }

                if (role == "THERAPIST") {
                  items.add(
                    _NavItem(
                      label: "Therapist",
                      icon: Icons.healing,
                      location: "/therapist",
                    ),
                  );
                }

                if (role == "LEGAL_RESPONSIBLE") {
                  items.add(
                    _NavItem(
                      label: "Legal",
                      icon: Icons.family_restroom,
                      location: "/legal",
                    ),
                  );
                }

                // Logout siempre disponible
                items.add(
                  _NavItem(
                    label: "Salir",
                    icon: Icons.logout,
                    location: "/logout",
                  ),
                );

                // Índice actual
                final currentIndex = items.indexWhere(
                  (i) => i.location == state.matchedLocation,
                );

                return NavigationBar(
                  height: 65,
                  selectedIndex: currentIndex >= 0 ? currentIndex : 0,
                  backgroundColor: Colors.white,
                  indicatorColor: Colors.blue.shade100,
                  elevation: 12,
                  labelBehavior:
                      NavigationDestinationLabelBehavior.onlyShowSelected,
                  onDestinationSelected: (index) async {
                    final item = items[index];

                    if (item.location == "/logout") {
                      final s = ref.read(sessionServiceProvider);
                      await s.logout();
                      if (!context.mounted) return;
                      context.go('/login');
                      return;
                    }

                    context.go(item.location);
                  },

                  destinations: [
                    for (final item in items)
                      NavigationDestination(
                        icon: Icon(item.icon),
                        label: item.label,
                      ),
                  ],
                );
              },
            ),
          );
        },
        routes: [
          GoRoute(
            path: '/legal',
            builder: (_, __) => const SessionsLegalPage(),
          ),
          GoRoute(
            path: '/therapist',
            builder: (_, __) => const SessionsPage(),
          ),
          
        ],

        // ---------- RUTAS HIJAS DE SHELLROUTE ---------
      ),
    ],
  );
});

// -------- TITULOS DE CADA RUTA --------
String _getTitleFor(String location) {
  switch (location) {
    case '/therapist':
      return 'Therapist Area';
    case '/legal':
      return 'Legal Responsible Area';
    case '/home':
      return 'Home';

    default:
      return '';
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final String location;

  _NavItem({required this.label, required this.icon, required this.location});
}

// -------- WIDGET TEMPORAL PARA RUTAS QUE AÚN NO HICISTE --------
class PlaceholderWidget extends StatelessWidget {
  final String text;
  const PlaceholderWidget(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(text, style: const TextStyle(fontSize: 22)));
  }
}
