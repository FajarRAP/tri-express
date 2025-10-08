import 'package:flutter/material.dart';

import 'mobile_scanner_advanced_page.dart';
import 'mobile_scanner_simple_page.dart';

/// Homepage for example app with selection between basic and advanced screen.
class ScanBarcodePage extends StatelessWidget {
  const ScanBarcodePage({super.key});

  Widget _buildItem(
    BuildContext context,
    String label,
    String subtitle,
    Widget page,
    IconData icon,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute<void>(builder: (context) => page));
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.blueAccent),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mobile Scanner Example',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 20),
              _buildItem(
                context,
                'Simple Mobile Scanner',
                'Example of a simple mobile scanner instance without defining '
                    'a controller.',
                MobileScannerSimplePage(onDetect: (barcode) {}),
                Icons.qr_code_scanner,
              ),
              _buildItem(
                context,
                'Advanced Mobile Scanner',
                'Example of an advanced mobile scanner instance with a '
                    'controller, and multiple control widgets.',
                const MobileScannerAdvancedPage(),
                Icons.settings_remote,
              ),
              // TODO(juliansteenbakker): Fix picklist example
              // _buildItem(
              //   context,
              //   'Mobile Scanner with Crosshair',
              //  'Example of a mobile scanner instance with a crosshair, that '
              //       'only detects barcodes which the crosshair hits.',
              //   const BarcodeScannerPicklist(),
              //   Icons.list,
              // ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
