import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> generatePdf(List<Map<String, dynamic>> orders) async {
  final status = await Permission.manageExternalStorage.request();
  if (status != PermissionStatus.granted) {
    return;
  }
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
                ...orders.map((order) => pw.TableRow(
                      children: [
                        pw.Text(order['orderId']),
                        pw.Text(order['products'].toString()),
                        pw.Text(order['orderDate'].toDate().toString()),
                        pw.Text(order['orderValue'].toString()),
                      ],
                      verticalAlignment: pw.TableCellVerticalAlignment.middle,
                    )),
              ],
            ),
          ],
        );
      },
    ),
  );

  Directory? directory;
  try {
    if (Platform.isAndroid) {
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
  }

  final file = File('${directory!.path}/orders.pdf');
  await file.writeAsBytes(await pdf.save());
  // Let the user choose where to save the file
  final saveFile = await FilePicker.platform.saveFile(
    initialDirectory: directory.path,
    allowedExtensions: ['pdf'],
  );

  if (saveFile != null) {
    // Open the file on the user's device
    await FlutterDocumentPicker.openDocument(
        params: FlutterDocumentPickerParams(
      allowedFileExtensions: ['pdf'],
      allowedMimeTypes: ['application/pdf'],
    ));
  }
}
