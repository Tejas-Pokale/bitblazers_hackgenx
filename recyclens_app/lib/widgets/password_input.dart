import 'package:flutter/material.dart';

class PasswordInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  PasswordInputWidget({required this.controller, this.hintText = 'Password'});

  @override
  State<PasswordInputWidget> createState() => _PasswordInputWidgetState();
}

class _PasswordInputWidgetState extends State<PasswordInputWidget> {
  bool hidePass = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: hidePass, 
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        icon: const Icon(Icons.lock),
        suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                hidePass = hidePass ? false : true;
              });
            },
            icon: hidePass
                ? const Icon(Icons.remove_red_eye)
                : const Icon(Icons.visibility_off)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters long';
        }
        return null;
      },
    );
  }
}
