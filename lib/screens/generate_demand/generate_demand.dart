import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcemeurckart_admin/controller/products_controller_getx.dart';
import 'package:mcemeurckart_admin/util/firestore_helper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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
          onPressed: () async {
            var orders;

            orders = await FireBaseStoreHelper.getOrdersByDateRange(
                DateTime.now().subtract(const Duration(days: 30)),
                DateTime.now());
            //log(orders.toString());
            final products = Get.find<ProductsController>().products;

            var demandList = products.map((element) {
              return {
                'index': element['index'],
                'title': element['title'],
                'demand': 0,
              };
            }).toList();

            //log(demandList.toString());

            orders.forEach((element) {
              element['products'].keys.forEach((key) {
                var index = demandList.indexWhere((element) {
                  return element['index'] == int.parse(key);
                });
                log(index.toString());
                if (index >= 0) {
                  demandList[index]['demand'] +=
                      element['products'][key]['quantity'];
                }
              });
            });

            demandList =
                demandList.where((element) => element['demand'] != 0).toList();
            log(demandList.toString());

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

            pdf.addPage(pw.Page(build: (context) {
              return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      children: [],
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
                      },
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(2.0),
                              child: pw.Text(
                                'Index',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(2.0),
                              child: pw.Text(
                                'Title',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(2.0),
                              child: pw.Text(
                                'Demand',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        ...demandList.map((element) {
                          return pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text(
                                  element['index'].toString(),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text(
                                  element['title'],
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text(
                                  element['demand'].toString(),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ]);
            }));

            final fileSaver = DocumentFileSavePlus();

            fileSaver.saveFile(
                await pdf.save(),
                'demand${DateTime.now().millisecondsSinceEpoch}.pdf',
                'application/pdf');
          },
          child: const Text('Generate Demand'),
        ),
      ),
    );
  }
}
