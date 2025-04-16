import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:recyclens_app/pages/auth/sign_up.dart';
import 'package:recyclens_app/pages/create_account/create_account.dart';
import 'package:recyclens_app/utils/dialog_utils.dart';
import 'package:recyclens_app/widgets/animated_gradient_background.dart';
import 'package:recyclens_app/widgets/remember_me.dart';


class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AnimatedTextController _animatedTextController = AnimatedTextController();
  final _formKey = GlobalKey<FormState>();
  bool remember = false;
  bool _obscurePassword = true;
  late Widget rememberMeWidget;

  @override
  void initState() {
    super.initState();
    rememberMeWidget = RememberMeWidget(
      remember: remember,
      label: 'remember me?',
      updateState: (val) {
        remember = val;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: AnimatedGradientBackground(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 10,
                left: 10,
                child: SizedBox(
                  width: 300.0,
                  child: DefaultTextStyle(
                    style: const TextStyle(
                        fontSize: 30.0, fontFamily: 'Agne', color: Colors.white),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText('Let\'s make the world better',
                            speed: const Duration(milliseconds: 100)),
                        TypewriterAnimatedText(
                            'Let\'s make the world beautiful',
                            speed: const Duration(milliseconds: 100)),
                        TypewriterAnimatedText('Save the earth from the harm',
                            speed: const Duration(milliseconds: 100)),
                        TypewriterAnimatedText('Go Green , Go clean',
                            speed: const Duration(milliseconds: 100)),
                      ],
                      isRepeatingAnimation: true,
                      repeatForever: true,
                      controller: _animatedTextController,
                    ),
                  ),
                ),
              ),
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
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  hintText: 'Enter your password',
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    icon: Icon(_obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off),
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
                            ],
                          ),
                        ),
                        const SizedBox(height: 7),
                        SizedBox(width: 220, child: rememberMeWidget),
                        const SizedBox(height: 7),
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                login();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.3),
                            ),
                            child: Text(
                              'login',
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium!.copyWith(
                                    color: Colors.black,
                                  ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'forgot password?',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium!.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account?',
                              style: Theme.of(
                                context,
                              ).textTheme.titleSmall!.copyWith(
                                    color: Theme.of(context).colorScheme.onInverseSurface,
                                  ),
                            ),
                            TextButton(
                              onPressed: () {
                                navigateToSignUp();
                              },
                              child: Text(
                                'Sign up!',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall!.copyWith(
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

  Future<void> login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      EasyLoading.show(status: 'Please wait...', dismissOnTap: false);
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user!.emailVerified) {
        EasyLoading.dismiss();
        navigateToCreateAccount();
      } else {
        EasyLoading.dismiss();
        DialogUtils.showAwesomeError('Failure', 'Please verify your email', context);
      }
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      if (e.code == 'user-not-found') {
        DialogUtils.showAwesomeError('Failure', 'No user found with that email', context);
      } else if (e.code == 'wrong-password') {
        DialogUtils.showAwesomeError('Failure', 'Wrong password provided', context);
      } else {
        DialogUtils.showAwesomeError('Failure', 'Wrong password or user don\'t exist', context);
      }
    }
  }

  void navigateToSignUp() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }

  void navigateToCreateAccount() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => CreateAccountPage()),
    );
  }
}