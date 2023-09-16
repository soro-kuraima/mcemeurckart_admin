import 'package:flutter/material.dart';
import 'package:mcemeurckart_admin/screens/generate_reports/widgets/date_selection_widget.dart';

class GenerateReports extends StatelessWidget {
  const GenerateReports({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Reports'),
      ),
      body: DateSelectionWidget(),
    );
  }
}
