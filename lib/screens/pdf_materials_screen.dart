import 'package:flutter/material.dart';

class PdfMaterialsScreen extends StatelessWidget {
  const PdfMaterialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Materials'),
      ),
      body: ListView(
        children: [
          _buildPdfItem(context, 'Material 1', 'PDF URL 1'),
          _buildPdfItem(context, 'Material 2', 'PDF URL 2'),
          _buildPdfItem(context, 'Material 3', 'PDF URL 3'),
        ],
      ),
    );
  }

  Widget _buildPdfItem(BuildContext context, String title, String url) {
    return ListTile(
      title: Text(title),
      leading: Icon(Icons.picture_as_pdf),
      onTap: () {
        // Handle PDF click - for now just show a snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening $title')),
        );
        // You can use a plugin like url_launcher to open the PDF URL
        // url_launcher.launch(url);
      },
    );
  }
}
