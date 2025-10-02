import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:garage_management/l10n/app_localizations.dart';
import 'package:garage_management/src/screen/AuthGate.dart';
import 'package:garage_management/src/screen/HomePage.dart';
import 'package:garage_management/src/screen/LoginPage.dart';



class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String verificationId = "";
  bool otpSent = false;
  bool isLoading = false;
  int? resendToken;

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  // Step 1: Send OTP
  Future<void> sendOTP() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    String phone = phoneController.text.trim();

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),
        forceResendingToken: resendToken,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification (on some devices)
          try {
            await _auth.signInWithCredential(credential);
            if (mounted) {
              _navigateToHome();
            }
          } catch (e) {
            if (mounted) {
              _showMessage("Auto-verification failed: $e", isError: true);
            }
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() => isLoading = false);
          String message = "Verification failed";

          if (e.code == 'invalid-phone-number') {
            message = "Invalid phone number format";
          } else if (e.code == 'too-many-requests') {
            message = "Too many requests. Try again later.";
          } else if (e.code == 'network-request-failed') {
            message = "Network error. Check your internet connection.";
          } else {
            message = e.message ?? "Verification failed";
          }

          _showMessage(message, isError: true);
        },
        codeSent: (String verId, int? token) {
          setState(() {
            verificationId = verId;
            resendToken = token;
            otpSent = true;
            isLoading = false;
          });
          print("OTP sent successfully to $phone");
          _showMessage("OTP sent successfully to $phone");
        },
        codeAutoRetrievalTimeout: (String verId) {
          verificationId = verId;
          setState(() => isLoading = false);
        },
      );
    } catch (e) {
      setState(() => isLoading = false);
      _showMessage("Failed to send OTP: $e", isError: true);
      print("Failed to send OTP: $e");
    }
  }

  // Step 2: Verify OTP and Login/Signup
  Future<void> verifyOTP() async {
    if (otpController.text.trim().isEmpty) {
      _showMessage("Please enter OTP", isError: true);
      return;
    }

    setState(() => isLoading = true);

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpController.text.trim(),
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      if (mounted) {
        // Check if this is a new user (signup) or existing user (login)
        bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

        if (isNewUser) {
          _showMessage("✅ Account created successfully!");
        } else {
          _showMessage("✅ Welcome back!");
        }

        // Navigate to home screen
        _navigateToHome();
      }
    } on FirebaseAuthException catch (e) {
      setState(() => isLoading = false);
      String message = "Verification failed";

      if (e.code == 'invalid-verification-code') {
        message = "Invalid OTP code. Please try again.";
      } else if (e.code == 'session-expired') {
        message = "OTP expired. Please request a new one.";
        setState(() => otpSent = false);
      } else {
        message = e.message ?? "Verification failed";
      }

      _showMessage(message, isError: true);
    } catch (e) {
      setState(() => isLoading = false);
      _showMessage("An error occurred: $e", isError: true);
    }
  }

  // Resend OTP
  Future<void> resendOTP() async {
    otpController.clear();
    await sendOTP();
  }

  // Navigate to home screen
  void _navigateToHome() {
    // Replace this with your home screen route
    //  Navigator.of(context).pushReplacementNamed('/home');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  // Show snackbar message
  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black54,
        title: Text(otpSent ? "Verify OTP" : "Phone Authentication"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              // Icon
              Icon(
                otpSent ? Icons.sms_outlined : Icons.phone_android,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),

              const SizedBox(height: 20),

              // Title
              Text(
                otpSent ?  AppLocalizations.of(context)!.enterVerificationCode : AppLocalizations.of(context)!.welcome,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              // Subtitle
              Text(
                otpSent
                    ? "${AppLocalizations.of(context)!.weSentCodeTo} ${phoneController.text}"

                    : AppLocalizations.of(
                            context,
                          )?.enterPhoneNumberToContinue ??
                          "Enter your phone number to continue",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Input fields
              if (!otpSent) ...[
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)?.phoneNumber??"",
                    hintText: "+974 12 345 678",
                    prefixIcon: const Icon(Icons.phone),
                    // border: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(12),
                    // ),
                    filled: true,
                  //  fillColor: Colors.grey[100],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)?.pleaseEnterPhoneNumber??"Please enter your phone number";
                    }
                    if (!value.startsWith('+')) {
                      return AppLocalizations.of(
                            context,
                          )?.phoneMustStartWithCountryCode ??"Phone must start with country code (e.g., +216)";
                    }
                    if (value.length < 10) {
                      return AppLocalizations.of(context)?.pleaseEnterValidPhoneNumber??"Please enter a valid phone number";
                    }
                    return null;
                  },
                ),

          
                const SizedBox(height: 24),
                // Send OTP Button
                ElevatedButton(
                  onPressed: isLoading ? null : sendOTP,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          "Send OTP",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                  const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.email),
                      Text(
                        AppLocalizations.of(context)!.sign_in,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
          ] else ...[
                TextFormField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                  ),
                  decoration: InputDecoration(
                    labelText: "OTP Code",
                    hintText: "000000",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                //    fillColor: Colors.grey[100],
                    counterText: "",
                  ),
                ),

                const SizedBox(height: 24),

                // Verify Button
                ElevatedButton(
                  onPressed: isLoading ? null : verifyOTP,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          "Verify & Continue",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),

                const SizedBox(height: 16),

                // Resend OTP
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive code? ",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    TextButton(
                      onPressed: isLoading ? null : resendOTP,
                      child: const Text(
                        "Resend",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                // Change Number
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          setState(() {
                            otpSent = false;
                            otpController.clear();
                          });
                        },
                  child: const Text("Change Phone Number"),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
