import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:document_file_save_plus/document_file_save_plus.dart';

Future<void> generatePdf(List<Map<String, dynamic>> orders) async {
  late final status;

  if (Platform.isAndroid) {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    var sdkInt = androidInfo.version.sdkInt;
    if (sdkInt >= 30) {
      status = await Permission.manageExternalStorage;
    } else {
      status = await Permission.storage.request();
    }

    // Android 9 (SDK 28), Xiaomi Redmi Note 7
  }

  if (Platform.isIOS) {
    status = await Permission.storage.request();
  }

  if (status == PermissionStatus.denied ||
      status == PermissionStatus.restricted) {
    throw Exception('Storage permission is denied or restricted');
  }

  log(status.toString());
  log(orders.toString());

  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              children: [
                //pw.Image(logoImage),
              ],
            ),
            pw.SizedBox(height: 16),
            pw.Center(
              child: pw.Text(
                'MCEME URC',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 16),
            pw.Table(
              columnWidths: {
                0: pw.FlexColumnWidth(1),
                1: pw.FlexColumnWidth(2),
                2: pw.FlexColumnWidth(1),
                3: pw.FlexColumnWidth(2),
                4: pw.FlexColumnWidth(1),
                5: pw.FlexColumnWidth(2),
              },
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    pw.Text('Order ID'),
                    pw.Text('Product Index'),
                    pw.Text('Product'),
                    pw.Text('Order Date'),
                    pw.Text('Order Value'),
                  ],
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.grey300,
                  ),
                  verticalAlignment: pw.TableCellVerticalAlignment.middle,
                ),
                ...orders.map((order) {
                  final products = order['products'].keys.map((product) {
                    return product;
                  });
                  return pw.TableRow(
                    children: [
                      pw.Text(order['orderId']),
                      pw.Text(products.toString()),
                      pw.Text(products.toString()),
                      pw.Text(order['orderDate'].toDate().toString()),
                      pw.Text(order['orderValue'].toString()),
                    ],
                    verticalAlignment: pw.TableCellVerticalAlignment.middle,
                  );
                }),
              ],
            ),
          ],
        );
      },
    ),
  );

  final fileSaver = DocumentFileSavePlus();

  fileSaver.saveFile(await pdf.save(),
      'orders${DateTime.now().millisecondsSinceEpoch}.pdf', 'application/pdf');
}
