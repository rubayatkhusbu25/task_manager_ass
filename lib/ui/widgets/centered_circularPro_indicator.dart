import 'package:flutter/material.dart';

class CenteredCircularproIndicator extends StatefulWidget {
  const CenteredCircularproIndicator({super.key});

  @override
  State<CenteredCircularproIndicator> createState() => _CenteredCircularproIndicatorState();
}

class _CenteredCircularproIndicatorState extends State<CenteredCircularproIndicator> {
  @override
  Widget build(BuildContext context) {
    return  Center(
      child: CircularProgressIndicator(),
    );
  }
}
