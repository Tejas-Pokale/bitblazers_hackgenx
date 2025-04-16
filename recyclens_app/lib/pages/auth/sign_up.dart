import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:recyclens_app/pages/auth/sign_in.dart';
import 'package:recyclens_app/utils/dialog_utils.dart';
import 'package:recyclens_app/widgets/animated_gradient_background.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: AnimatedGradientBackground(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Top Animated Text
              Positioned(
                top: 10,
                left: 10,
                child: SizedBox(
                  width: 300.0,
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 30.0,
                      fontFamily: 'Agne',
                      color: Colors.white,
                    ),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText('Let\'s make the world better', speed: const Duration(milliseconds: 100)),
                        TypewriterAnimatedText('Let\'s make the world beautiful', speed: const Duration(milliseconds: 100)),
                        TypewriterAnimatedText('Save the earth from the harm', speed: const Duration(milliseconds: 100)),
                        TypewriterAnimatedText('Go Green , Go clean', speed: const Duration(milliseconds: 100)),
                      ],
                      isRepeatingAnimation: true,
                      repeatForever: true,
                    ),
                  ),
                ),
              ),

              // Gradient overlay
              Container(
                width: size.width,
                height: size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.0),
                      Colors.black.withOpacity(0.2),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [.1, 1],
                  ),
                ),
              ),

              // Bottom form
              Positioned(
                left: 0,
                right: 0,
                bottom: 20,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Email Field
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  hintText: 'Enter your email',
                                  prefixIcon: const Icon(Icons.email),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () => _emailController.clear(),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (value) => value!.isEmpty ? 'Email is required' : null,
                              ),
                              const SizedBox(height: 15),

                              // Password Field
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  hintText: 'Enter your password',
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (value) => value!.isEmpty ? 'Password is required' : null,
                              ),
                              const SizedBox(height: 15),

                              // Confirm Password Field
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: _obscureConfirmPassword,
                                decoration: InputDecoration(
                                  hintText: 'Confirm your password',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
                                    onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) return 'Confirm password is required';
                                  if (value != _passwordController.text) return 'Passwords do not match';
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Sign Up Button
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                signUp();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                            ),
                            child: Text(
                              'Sign Up',
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Navigate to Sign In
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?',
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                color: Theme.of(context).colorScheme.onInverseSurface,
                              ),
                            ),
                            TextButton(
                              onPressed: () => navigateToSignIn(),
                              child: Text(
                                'Sign in!',
                                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signUp() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmpassword = _confirmPasswordController.text.trim();
    print('email :- ${_emailController.text}');
    print('password :- ${_passwordController.text}');
    print('confirm password :- ${_confirmPasswordController.text}');

    try {
      EasyLoading.show(status: 'Creating your account...', dismissOnTap: false);
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user!.sendEmailVerification();
      EasyLoading.dismiss();
      AwesomeDialog(
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.success,
        body:  Center(
          child: Text(
            'Your account created successfully\nVerify email sent to you check your inbox or scam',
            style: TextStyle(fontStyle: FontStyle.italic,color: Theme.of(context).colorScheme.onPrimaryContainer,),
            textAlign: TextAlign.center,
          ),
        ),
        title: 'This is Ignored',
        desc: 'This is also Ignored',
        btnOkOnPress: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => SignInPage(),
          ));
        },
      ).show();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        DialogUtils.showAwesomeError('Failure', 'Password is too weak', context);
        EasyLoading.dismiss();
      } else if (e.code == 'email-already-in-use') {
        DialogUtils.showAwesomeError('Failure', 'email-already-in-use', context);
        EasyLoading.dismiss();
      }
    } catch (e) {
      print(e);
    }
  }

  void navigateToSignIn() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => SignInPage(),
    ));
  }

  @override
  void dispose() {
   
    super.dispose();
  }
}

