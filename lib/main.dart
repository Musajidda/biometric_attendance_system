import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sqflite/sqflite.dart';

import 'model/database_helper.dart';

class BiometricAttendanceSystem extends StatefulWidget {
  @override
  _BiometricAttendanceSystemState createState() => _BiometricAttendanceSystemState();
}

class _BiometricAttendanceSystemState extends State<BiometricAttendanceSystem> {
  final LocalAuthentication auth = LocalAuthentication();
  DatabaseHelper dbHelper = DatabaseHelper();
  bool _isAuthenticated = false;
  String _message = 'Please scan your biometric to mark attendance';

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
        int userId = 1; // Fetch the user ID based on biometric data
        await dbHelper.logAttendance(userId);
        int attendanceCount = await dbHelper.getAttendanceCount(userId);
        setState(() {
          _message = 'Attendance marked successfully! You have attended $attendanceCount times.';
        });
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_message),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _authenticate,
              child: Text('Scan Biometric'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: BiometricAttendanceSystem(),
  ));
}
