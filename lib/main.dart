import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _controller = TextEditingController();
  void displayPdf(String data) async {
    final doc = pw.Document();
    final myfont =
        await rootBundle.load('assets/font/NotoNaskhArabic-Regular.ttf');
    final myStyle = pw.TextStyle(font: pw.Font.ttf(myfont));
    doc.addPage(pw.Page(
        theme: pw.ThemeData.withFont(base: pw.Font.ttf(myfont)),
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.ltr,
        build: (pw.Context context) {
          return pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('1'),
              pw.Container(
                  width: 400,
                  child: pw.Text(
                    data,
                    textAlign: pw.TextAlign.justify,
                    textDirection: pw.TextDirection.rtl,
                    style: myStyle,
                  ))
            ],
          );
        }));

    gotoprintpreview(doc);
  }

  pw.Text arabWidget(String text, bool isRtl, pw.TextStyle style) =>
      pw.Text(text,
          style: style,
          textAlign: pw.TextAlign.left,
          textDirection: isRtl ? pw.TextDirection.rtl : null);

  pw.Expanded soalWidget(String soal, pw.TextStyle style) {
    return pw.Expanded(child: pw.Text(soal, style: style));
  }

  void gotoprintpreview(pw.Document doc) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewScreen(doc: doc),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mixing RTL LTR ')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SizedBox(
            width: 200,
            child: TextField(
              controller: _controller,
              onChanged: (value) => setState(() {}),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              displayPdf(_controller.text);
            },
            child: const Text('Show Pdf'),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            child: Row(
              children: [
                const Text('1'),
                Expanded(child: Text(_controller.text))
              ],
            ),
          )
        ],
      ),
    );
  }
}

class PreviewScreen extends StatelessWidget {
  final pw.Document doc;

  const PreviewScreen({
    Key? key,
    required this.doc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_outlined),
        ),
        centerTitle: true,
        title: const Text("Preview"),
      ),
      body: PdfPreview(
        build: (format) => doc.save(),
        allowSharing: true,
        allowPrinting: true,
        initialPageFormat: PdfPageFormat.a4,
        pdfFileName: "mydoc.pdf",
      ),
    );
  }
}
