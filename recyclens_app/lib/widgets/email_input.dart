import 'package:flutter/material.dart';

class EmailInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  const EmailInputWidget({required this.controller, this.hintText = 'Email'});

  @override
  State<EmailInputWidget> createState() => _EmailInputWidgetState();
}

class _EmailInputWidgetState extends State<EmailInputWidget> {
  bool suffixIcon = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.emailAddress,
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        icon: const Icon(Icons.email),
        
        suffixIcon: widget.controller.text.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  widget.controller.text = '';
                },
                icon: const Icon(Icons.clear)),
      ),
      onChanged: (value) {
        setState(() {
          
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter an email address';
        }
        if (!isValidEmail(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }

  bool isValidEmail(String email) {
    // A simple regex to check for a valid email format.
    final emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegExp.hasMatch(email);
  }
}
