import 'package:flutter/material.dart';

class GenerateDemand extends StatelessWidget {
  const GenerateDemand({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Demand'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {},
          child: const Text('Generate Demand'),
        ),
      ),
    );
  }
}
