import 'package:flutter/material.dart';
import '../../core/services/database_service.dart';
import '../../core/constants/database_endpoints.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController token = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool loading = false;

  Future<void> _reset() async {
    setState(() => loading = true);

    try {
      final response = await DatabaseService.post(
        DatabaseEndpoints.resetPassword,
        {
          "token": token.text.trim(),
          "newPassword": password.text.trim(),
        },
      );

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Contraseña actualizada")),
        );

        Navigator.popUntil(context, (route) => route.isFirst);
      } else {
        throw response.error ?? "Error";
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Restablecer contraseña")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Código enviado a ${widget.email}"),

            TextField(
              controller: token,
              decoration: const InputDecoration(labelText: "Código"),
            ),

            TextField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Nueva contraseña"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: loading ? null : _reset,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text("Cambiar contraseña"),
            )
          ],
        ),
      ),
    );
  }
}
