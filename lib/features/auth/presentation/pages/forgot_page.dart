import 'package:flutter/material.dart';

class ForgotPage extends StatelessWidget {
  const ForgotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot my password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Informative screen (placeholder)'),
            SizedBox(height: 8),
            Text('Here goes the password recovery flow.'),
          ],
        ),
      ),
    );
  }
}
