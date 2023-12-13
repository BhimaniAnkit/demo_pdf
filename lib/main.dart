import 'dart:io';
import 'dart:math';
import 'package:external_path/external_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: first(),
  ));
}

class first extends StatefulWidget {
  const first({Key? key}) : super(key: key);

  @override
  State<first> createState() => _firstState();
}

class _firstState extends State<first> {

  @override
  void initState() {
    get();
  }

  get() async {
    var status = await Permission.storage.status;
    if(status.isDenied){
      // You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.storage,
      ].request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ElevatedButton(onPressed: () async {

        const String paragraphText =
            'Adobe Systems Incorporated\'s Portable Document Format (PDF) is the de facto'
            'standard for the accurate, reliable, and platform-independent representation of a paged'
            'document. It\'s the only universally accepted file format that allows pixel-perfect layouts.'
            'In addition, PDF supports user interaction and collaborative workflows that are not'
            'possible with printed documents.';

        // Create a new PDF document.
        final PdfDocument document = PdfDocument();
        final PdfPage page = document.pages.add();
        page.graphics.drawString('${paragraphText}', PdfStandardFont(PdfFontFamily.timesRoman, 10),
            bounds: const Rect.fromLTWH(0, 0, 500, 500),
            brush: PdfBrushes.green);
        // page.graphics.drawString('Hello World!..', PdfStandardFont(PdfFontFamily.timesRoman, 50),bounds: const Rect.fromLTWH(0, 0, 150, 20),
        // brush: PdfSolidBrush(PdfColor(0, 0, 255)));
        var path = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS+ "/MyFolder");
        print(path);
        Directory dir = Directory(path);
        if(! await dir.exists()){
          dir.create();
        }
        int r = Random().nextInt(100);
        // String name = "${r}.pdf";
        File f = File('${dir.path}/MyFolder${Random().nextInt(100)}.pdf');
        await f.writeAsBytes(await document.save());
        OpenFile.open(f.path);

        document.dispose();

      }, child: Text("Submit")),
    );
  }
}
