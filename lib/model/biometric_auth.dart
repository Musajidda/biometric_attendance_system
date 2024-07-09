import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuth extends StatefulWidget {
  @override
  _BiometricAuthState createState() => _BiometricAuthState();
}

class _BiometricAuthState extends State<BiometricAuth> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticated = false;

  Future<void> _authenticate() async {
    try {
      _isAuthenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to mark attendance',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      if (_isAuthenticated) {
        // Log attendance
        // Show success message
      }
    } catch (e) {
      print(e);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Biometric Attendance System')),
      body: Center(
        child: ElevatedButton(
          onPressed: _authenticate,
          child: Text('Scan Biometric'),
        ),
      ),
    );
  }
}
