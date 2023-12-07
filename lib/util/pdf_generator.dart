import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcemeurckart_admin/controller/products_controller_getx.dart';
import 'package:mcemeurckart_admin/util/firestore_helper.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:document_file_save_plus/document_file_save_plus.dart';

Future<void> generatePdf(List<dynamic> orders) async {
  late final status;

  if (Platform.isAndroid) {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    var sdkInt = androidInfo.version.sdkInt;
    if (sdkInt >= 30) {
      status = await Permission.manageExternalStorage;
    } else {
      status = await Permission.storage.request();
    }
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

  final products = Get.find<ProductsController>().products;

  final fileSaver = DocumentFileSavePlus();

  final pdf = pw.Document();

  // Function to add a page for a batch of orders
  void addPage(List<dynamic> batch) {
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
                      pw.Text('Product'),
                      pw.Text('Order Date'),
                      pw.Text('Order Value'),
                    ],
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey300,
                    ),
                    verticalAlignment: pw.TableCellVerticalAlignment.middle,
                  ),
                  ...batch.map((order) {
                    final productTitles = order['products'].keys.map((product) {
                      final productTitle = products.firstWhere((element) =>
                          element['index'] == int.parse(product))['title'];
                      return {
                        'index': product,
                        'title': productTitle,
                        'quantity':
                            order['products'][product]['quantity'].toString(),
                      };
                    });
                    log(productTitles.toString());

                    return pw.TableRow(
                      children: [
                        pw.Text(order['orderId']),
                        pw.Container(
                            width: 400, // Adjust the width as needed
                            child: pw.Table(
                              columnWidths: {
                                0: pw.FlexColumnWidth(1),
                                1: pw.FlexColumnWidth(2),
                                2: pw.FlexColumnWidth(1),
                                3: pw.FlexColumnWidth(2),
                              },
                              border: pw.TableBorder.all(),
                              children: [
                                pw.TableRow(
                                  children: [
                                    pw.Text('Index'),
                                    pw.Text('Title'),
                                    pw.Text('Quantity'),
                                  ],
                                  decoration: const pw.BoxDecoration(
                                    color: PdfColors.grey300,
                                  ),
                                  verticalAlignment:
                                      pw.TableCellVerticalAlignment.middle,
                                ),
                                ...productTitles.map((product) {
                                  return pw.TableRow(
                                    children: [
                                      pw.Text(product['index']),
                                      pw.Text(product['title']),
                                      pw.Text(product['quantity']),
                                    ],
                                  );
                                }),
                              ],
                            )),
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
  }

  // Break orders into batches (you can adjust the batch size as needed)
  const batchSize = 10; // Example: 10 orders per page
  for (var i = 0; i < orders.length; i += batchSize) {
    var batchEndIndex =
        (i + batchSize < orders.length) ? i + batchSize : orders.length;
    var batch = orders.sublist(i, batchEndIndex);
    addPage(batch);
  }

  // Save the generated PDF
  await fileSaver.saveFile(
    await pdf.save(),
    'orders${DateTime.now().millisecondsSinceEpoch}.pdf',
    'application/pdf',
  );
}
