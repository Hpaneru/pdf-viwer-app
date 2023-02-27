import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter PDF Vierwer Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PDFViewerScreen(),
    );
  }
}

class PDFViewerScreen extends StatefulWidget {
  const PDFViewerScreen({super.key});

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  late TextEditingController _query;
  late PdfTextSearchResult _searchResult;
  late PdfViewerController _pdfViewerController;

  @override
  void initState() {
    _query = TextEditingController();
    _searchResult = PdfTextSearchResult();
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  void startSearch(String q) {
    _searchResult = _pdfViewerController.searchText(q);
    _searchResult.addListener(() {
      if (_searchResult.hasResult) {
        setState(() {});
      }
    });
  }

  void showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Search Text'),
        children: <Widget>[
          TextField(
            controller: _query,
            textInputAction: TextInputAction.go,
            decoration: const InputDecoration(
              hintText: 'Search',
            ),
            onSubmitted: (value) {
              startSearch(value);
              Navigator.pop(context);
            },
          ),
          TextButton(
            onPressed: () {
              startSearch(_query.text);
              Navigator.pop(context);
            },
            child: const Text("Done"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _query.dispose();
    _searchResult.dispose();
    _pdfViewerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter PdfViewer'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              _query.clear();
              showSearchDialog();
            },
          ),
          Visibility(
            visible: _searchResult.hasResult,
            child: IconButton(
              icon: const Icon(
                Icons.clear,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _searchResult.clear();
                });
              },
            ),
          ),
          Visibility(
            visible: _searchResult.hasResult,
            child: IconButton(
              icon: const Icon(
                Icons.keyboard_arrow_up,
                color: Colors.white,
              ),
              onPressed: () {
                _searchResult.previousInstance();
              },
            ),
          ),
          Visibility(
            visible: _searchResult.hasResult,
            child: IconButton(
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
              ),
              onPressed: () {
                _searchResult.nextInstance();
              },
            ),
          ),
        ],
      ),
      body: SfPdfViewer.network(
        'https://www.orimi.com/pdf-test.pdf',
        controller: _pdfViewerController,
        otherSearchTextHighlightColor: Colors.yellow.withOpacity(0.3),
        currentSearchTextHighlightColor: Colors.yellow.withOpacity(0.8),
      ),
    );
  }
}
