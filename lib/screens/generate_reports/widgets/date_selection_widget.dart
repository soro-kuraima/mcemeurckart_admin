import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcemeurckart_admin/constants/app_colors.dart';
import 'package:mcemeurckart_admin/constants/index.dart';
import 'package:mcemeurckart_admin/util/firestore_helper.dart';
import 'package:mcemeurckart_admin/util/pdf_generator.dart';

class DateSelectionWidget extends StatefulWidget {
  DateSelectionWidget({Key? key}) : super(key: key);

  @override
  _DateSelectionWidgetState createState() => _DateSelectionWidgetState();
}

class _DateSelectionWidgetState extends State<DateSelectionWidget> {
  bool _isRangeSelected = false;
  DateTime? _startDate;
  DateTime? _endDate;

  void _selectDate() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      setState(() {
        _startDate = selectedDate;
        _endDate = null;
        _isRangeSelected = false;
      });
    }
  }

  void _selectDateRange() async {
    final DateTimeRange? selectedRange = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now(),
      ),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (selectedRange != null) {
      setState(() {
        _startDate = selectedRange.start;
        _endDate = selectedRange.end;
        _isRangeSelected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.p32,
        vertical: 8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _selectDate,
                child: Text('Select Date'),
              ),
              ElevatedButton(
                onPressed: _selectDateRange,
                child: Text('Select Date Range'),
              ),
            ],
          ),
          SizedBox(height: 16),
          Center(
              child: Text(
                  _startDate != null
                      ? _isRangeSelected
                          ? 'Selected Date Range: '
                          : 'Selected Date '
                      : 'No date selected',
                  style: Get.textTheme.headlineSmall)),
          SizedBox(height: Sizes.p10),
          Center(
            child: Text(
                _startDate != null
                    ? _isRangeSelected
                        ? '${_startDate!.toString()} - ${_endDate!.toString()}'
                        : '${_startDate!.toString()}'
                    : '',
                style: Get.textTheme.titleLarge),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _startDate != null
                ? () async {
                    var orders;
                    if (_isRangeSelected) {
                      orders = await FireBaseStoreHelper.getOrdersByDateRange(
                          _startDate!, _endDate!);
                    } else {
                      orders = await FireBaseStoreHelper.getOrdersByDate(
                          _startDate!);
                    }
                    /* orders = orders
                        .where((element) => element['status'] == 'Delivered')
                        .toList();*/

                    await generatePdf(orders);
                  }
                : null,
            child: Text('Generate Report'),
          ),
        ],
      ),
    );
  }
}
