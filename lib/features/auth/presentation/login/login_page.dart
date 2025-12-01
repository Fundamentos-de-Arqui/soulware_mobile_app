import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soulware_app/features/auth/auth.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerWidget {
  LoginPage({super.key});

  final dniCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  // Color principal
  final Color primaryColor = const Color(0xFF5A9DE0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginControllerProvider);

    // Navegar si hay tokens
    if (state.tokens != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final role = state.tokens!.accountType;

        if (role == "LEGAL_RESPONSIBLE") {
          context.go('/legal');
        } else if (role == "THERAPIST") {
          context.go('/therapist');
        } else {
          context.go('/login'); // Rol desconocido, volver a login
        }
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 230),

            // Título grande
            Text(
              "Welcome Back",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 50),

            // DNI
            TextField(
              controller: dniCtrl,
              decoration: InputDecoration(
                labelText: 'DNI',
                labelStyle: TextStyle(color: primaryColor),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 60, 115, 170),
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Password
            TextField(
              controller: passwordCtrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: primaryColor),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 60, 115, 170),
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Botón login
            state.loading
                ? Center(child: CircularProgressIndicator(color: primaryColor))
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      ref
                          .read(loginControllerProvider.notifier)
                          .login(dniCtrl.text, passwordCtrl.text);
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

            const SizedBox(height: 10),

            if (state.error != null)
              Text(
                state.error!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
