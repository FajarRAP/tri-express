import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/themes/colors.dart';
import '../../../../core/widgets/notification_icon_button.dart';
import '../../../../core/widgets/primary_gradient_card.dart';
import '../../../../main.dart';
import '../../../../uhf_result_model.dart';
import 'on_the_way_page.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  static const platform =
      MethodChannel('com.example.tri_express/android_channel');
  final _tagInfos = <UHFResultModel>[];

  @override
  void initState() {
    super.initState();
    platform.setMethodCallHandler(callHandler);
  }

  Future<dynamic> callHandler(MethodCall call) async {
    switch (call.method) {
      case 'getTagInfo':
        final map = Map<String, dynamic>.from(call.arguments);
        final tagInfo = UHFResultModel.fromJson(map);
        final index = _tagInfos.indexWhere((e) => e.epcId == tagInfo.epcId);

        setState(() {
          index != -1
              ? _tagInfos[index].updateInfo(tagInfo: tagInfo)
              : _tagInfos.add(tagInfo);
        });

        break;
      case 'startInventory':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text('${call.arguments}'),
          ),
        );
        break;
      case 'stopInventory':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('${call.arguments}'),
          ),
        );
        break;
    }
  }

  Future<void> _callHandleInventoryButton() async {
    try {
      await platform.invokeMethod<void>('handleInventoryButton');
    } on PlatformException catch (pe) {
      print(pe);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Gudang'),
        actions: <Widget>[
          const NotificationIconButton(),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari resi atau invoice',
                      prefixIcon: const Icon(Icons.search_outlined),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: whiteTertiary),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x4D3F3F3F),
                        offset: Offset(0, 1),
                        spreadRadius: 0,
                      ),
                    ],
                    color: light,
                  ),
                  height: 40,
                  width: 40,
                  child: const Icon(Icons.qr_code_scanner_outlined),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: whiteTertiary),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x4D3F3F3F),
                        offset: Offset(0, 1),
                        spreadRadius: 0,
                      ),
                    ],
                    color: light,
                  ),
                  height: 40,
                  width: 40,
                  child: const Icon(Icons.print_outlined),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: <Widget>[
                Expanded(
                  child: PrimaryGradientCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Koli',
                          style: const TextStyle(
                            color: light,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '0',
                          style: const TextStyle(
                            color: light,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PrimaryGradientCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Scan',
                          style: const TextStyle(
                            color: light,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '0',
                          style: const TextStyle(
                            color: light,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PrimaryGradientCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Hilang',
                          style: const TextStyle(
                            color: light,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '0',
                          style: const TextStyle(
                            color: light,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_tagInfos.isNotEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    'Belum ada barang, terima barang sebelum cek inventory gudang',
                    style: const TextStyle(
                      color: grayTertiary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) => BatchCardItem(
                    batch: Batch(
                      id: '$index',
                      batch: '_tagInfos[$index].epcId',
                      destination: faker.address.city(),
                      itemCount: faker.randomGenerator.integer(100, min: 1),
                      origin: faker.address.city(),
                      path: 'Darat',
                      sendAt: faker.date.dateTime(),
                      status: 'Selesai',
                    ),
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemCount: 20,
                  padding: const EdgeInsets.only(bottom: 16),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _callHandleInventoryButton,
        backgroundColor: primary,
        foregroundColor: light,
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
