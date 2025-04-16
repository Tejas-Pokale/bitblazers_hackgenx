import 'package:flutter/material.dart';

class FakePage extends StatefulWidget {
  const FakePage({super.key});

  @override
  State<FakePage> createState() => _FakePageState();
}

class _FakePageState extends State<FakePage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}