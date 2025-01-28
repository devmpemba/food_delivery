import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'verify_otp.dart'; // Import the VerifyOtp screen

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final TextEditingController _phoneController = TextEditingController();

  // Function to send OTP via API
  Future<http.Response> sendOtp(String phoneNumber) async {
    final url = Uri.parse('https://msosi.dawadirect.co.tz/api/register'); // Replace with your API endpoint
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({'mobile': phoneNumber});

    final response = await http.post(url, headers: headers, body: body);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create Account',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Mulish"),
            ),
            const SizedBox(height: 8),
            const Text(
              'Step 1 of 2',
              style: TextStyle(
                  fontSize: 16, color: Colors.grey, fontFamily: "Mulish"),
            ),
            const SizedBox(height: 20),
            const Text(
              'Enter your mobile number',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Mulish"),
            ),
            const SizedBox(height: 10),
            const Text(
              "We'll send you a 6-digit verification code to your mobile number to confirm your account.",
              style: TextStyle(
                  fontSize: 14, color: Colors.grey, fontFamily: "Mulish"),
            ),
            const SizedBox(height: 20),
            // Phone number input box
            Row(
              children: [
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      hintText: '0713XXXXXX',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    maxLength: 10, // Assuming a 10-digit phone number
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Send OTP button
            ElevatedButton(
              onPressed: () async {
                String phoneNumber = _phoneController.text;
                if (phoneNumber.isNotEmpty) {
                  // Call the API to send OTP
                  final response = await sendOtp(phoneNumber);

                  if (response.statusCode == 200) {
                    // Parse the response
                    final responseData = json.decode(response.body);
                    final otp = responseData['otp'];

                    // Navigate to the OTP verification screen
                    Get.to(() => VerifyOtp(phoneNumber: phoneNumber, otp: otp.toString()));

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('OTP sent successfully to $phoneNumber')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to send OTP. Please try again.')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid phone number')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Set button color
                minimumSize: const Size(double.infinity, 50), // Full width
              ),
              child: const Text('Send OTP',
                  style: TextStyle(
                      fontSize: 16, fontFamily: "Mulish", color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}