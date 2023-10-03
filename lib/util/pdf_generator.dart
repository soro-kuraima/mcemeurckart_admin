import 'dart:developer';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:document_file_save_plus/document_file_save_plus.dart';

Future<void> generatePdf(List<Map<String, dynamic>> orders) async {
  final status = await Permission.storage.request();

  if (status == PermissionStatus.denied ||
      status == PermissionStatus.restricted) {
    throw Exception('Storage permission is denied or restricted');
  }

  log(status.toString());
  log(orders.toString());

  final pdf = pw.Document();

  // Add logo to the top left of the PDF
  //final logoImage = pw.MemoryImage(
  //File(AppAssets.appLogoBlack).readAsBytesSync(),
  //);
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
                3: pw.FlexColumnWidth(1),
                4: pw.FlexColumnWidth(2),
              },
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    pw.Text('Order ID'),
                    pw.Text('Products'),
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

  // The file has been downloaded and saved to the device's storage.
  // You can now use it or display it as needed.
  // For example, you can open the file using an external app:
  // await OpenFile.open(filePath);
/*
  Directory? directory;
  try {
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = Directory('/storage/emulated/0/Download');
      // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
      // ignore: avoid_slow_async_io
      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
      }
    }
  } catch (err) {
    print("Cannot get download folder path");
  }*/

  final fileSaver = DocumentFileSavePlus();

  fileSaver.saveFile(await pdf.save(),
      'orders${DateTime.now().millisecondsSinceEpoch}.pdf', 'application/pdf');

  /*final directory = await getExternalStorageDirectory();
  final filePath =
      '${directory!.path}/orders${DateTime.now().millisecondsSinceEpoch}.pdf';

  final file = File(filePath);
  await file.writeAsBytes(await pdf.save());
  await file.writeAsBytes(await pdf.save());*/
  // Let the user choose where to save the fil
}
