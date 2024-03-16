import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class HomeController extends GetxController {
  void downloadCatalog() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Center(
          child: pw.Text(
            "test pdf",
            style: pw.TextStyle(
              fontSize: 50,
            ),
          ),
        ),
      ),
    );

    // Simpan PDF
    final Uint8List bytes = await pdf.save();

    // Dapatkan direktori aplikasi
    final Directory directory = await getApplicationDocumentsDirectory();

    // Buat file PDF
    final String path = '${directory.path}/mydocument.pdf';
    final File file = File(path);

    // Tulis bytes ke file
    await file.writeAsBytes(bytes);

    // Buka file PDF
    await OpenFile.open(path);
  }
}
