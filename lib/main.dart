import 'package:flutter/material.dart';
import 'package:webapi/register.dart';

void main() {
  runApp(const webAPI());
}

class webAPI extends StatelessWidget {
  const webAPI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: register(),
    );
  }
}

