import 'package:flutter/material.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 200, // Adjust the width as needed
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Old password',
                ),
              ),
            ),
            const SizedBox(
              height: 16, // Adjust the height between input fields
            ),
            const SizedBox(
              width: 200, // Adjust the width as needed
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'New password',
                ),
              ),
            ),
            const SizedBox(
              height: 16, // Adjust the height between input fields
            ),
            const SizedBox(
              width: 200, // Adjust the width as needed
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Confirm password',
                ),
              ),
            ),
            const SizedBox(
              height: 16, // Adjust the height between input fields and button
            ),
            SizedBox(
              width: 200, // Adjust the width as needed
              child: ElevatedButton(
                onPressed: () {
                  // Add your 'Change' button logic here
                  print('Change button pressed');
                },
                child: const Text('Change'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
