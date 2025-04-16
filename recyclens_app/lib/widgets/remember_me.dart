import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RememberMeWidget extends StatefulWidget {
  RememberMeWidget(
      {super.key,
      required this.remember,
      this.label = 'remember me?',
      required this.updateState});

  bool remember;
  String label;
  void Function(bool val) updateState;

  @override
  State<RememberMeWidget> createState() => _RememberMeWidgetState();
}

class _RememberMeWidgetState extends State<RememberMeWidget> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(
        widget.label,
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: Colors.black),
      ),
      activeColor: Theme.of(context).colorScheme.onPrimary,
      checkColor: Colors.black,
      controlAffinity: ListTileControlAffinity.leading,
      value: widget.remember,
      onChanged: (value) {
        setState(() {
          widget.remember = value!;
          widget.updateState(value);
        });
      },
    );
  }
}
