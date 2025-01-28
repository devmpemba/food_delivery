import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food_delivery/home_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerifyOtp extends StatefulWidget {
  final String phoneNumber;
  final String otp;

  const VerifyOtp({super.key, required this.phoneNumber, required this.otp});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());
  int _countdown = 60;
  late final Timer _timer;
  bool _isResendEnabled = false;
  bool _isLoading = false; // To show a loading indicator during API calls

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        setState(() {
          _isResendEnabled = true;
        });
        timer.cancel();
      }
    });
  }

  void _resendOtp() {
    setState(() {
      _countdown = 60;
      _isResendEnabled = false;
    });
    _startCountdown();
    // Call your API to resend OTP here
    //_verifyOtp();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP resent successfully!')),
    );
  }

  // Function to verify OTP via API
  Future<void> _verifyOtp() async {
    String enteredOtp =
        _otpControllers.map((controller) => controller.text).join();
    if (enteredOtp.length == 6) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      try {
        final response = await verifyOtpApi(widget.phoneNumber, enteredOtp);

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          if (responseData['success'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('OTP verified successfully!')),
            );
            // Navigate to the next screen or perform further actions
            Get.to(HomeScreen());
            
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(responseData['message'] ??
                      'Invalid OTP. Please try again.')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Failed to verify OTP. Please try again.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.')),
        );
      } finally {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit code')),
      );
    }
  }

  // Function to call the OTP verification API
  Future<http.Response> verifyOtpApi(String mobile, String otp) async {
    final url = Uri.parse(
        'https://msosi.dawadirect.co.tz/api/verify-otp'); // Replace with your API endpoint
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({'mobile': mobile, 'otp': otp});

    final response = await http.post(url, headers: headers, body: body);
    return response;
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account Confirmation',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: "Mulish",
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Step 2 of 2',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: "Mulish",
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Enter 6-digit verification code',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: "Mulish",
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Please enter a 6-digit verification code we sent to you at ${widget.phoneNumber}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontFamily: "Mulish",
              ),
            ),
            const SizedBox(height: 20),
            // OTP Input
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 40,
                  child: TextField(
                    controller: _otpControllers[index],
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      counterText: '',
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 5) {
                        FocusScope.of(context).nextFocus();
                      } else if (value.isEmpty && index > 0) {
                        FocusScope.of(context).previousFocus();
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            // Resend code
            GestureDetector(
              onTap: _isResendEnabled ? _resendOtp : null,
              child: Text(
                _isResendEnabled
                    ? 'Resend code'
                    : 'Resend code in $_countdown s',
                style: TextStyle(
                  color: _isResendEnabled ? Colors.blue : Colors.grey,
                  fontFamily: "Mulish",
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Verify button
            ElevatedButton(
              onPressed: _isLoading ? null : _verifyOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Set button color
                minimumSize: const Size(double.infinity, 50), // Full width
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white) // Show loading indicator
                  : const Text(
                      'VERIFY',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Mulish",
                          color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
