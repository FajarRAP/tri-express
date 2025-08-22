import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/themes/colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/notification_icon_button.dart';
import '../../../../main.dart';
import '../../../../uhf_result_model.dart';
import '../../domain/entity/batch_entity.dart';
import '../widgets/batch_card_status_item.dart';
import '../widgets/inventory_summary_card.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final _tagInfos = <UHFResultModel>[];
  var _isInventoryRunning = false;

  @override
  void initState() {
    super.initState();
    platform.setMethodCallHandler(callHandler);
  }

  Future<dynamic> callHandler(MethodCall call) async {
    final map = Map<String, dynamic>.from(call.arguments);

    switch (call.method) {
      case getTagInfoMethod:
        final tagInfo = UHFResultModel.fromJson(map);
        final index = _tagInfos.indexWhere((e) => e.epcId == tagInfo.epcId);

        setState(() => index != -1
            ? _tagInfos[index].updateInfo(tagInfo: tagInfo)
            : _tagInfos.add(tagInfo));
        break;
      case startInventoryMethod:
      case stopInventoryMethod:
      case failedInventoryMethod:
        final response = UHFResponse.fromJson(map);
        setState(() => _isInventoryRunning = response.statusCode == 1);
        call.method == startInventoryMethod
            ? TopSnackbar.successSnackbar(message: response.message)
            : TopSnackbar.dangerSnackbar(message: response.message);
        break;
    }
  }

  Future<void> _callHandleInventoryButton() async {
    final isSuccess =
        await platform.invokeMethod<int>(handleInventoryButtonMethod) ?? -1;

    if (isSuccess == -1) return;

    setState(() => _isInventoryRunning = isSuccess == 1);
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
            // Header
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
            // Cards
            Row(
              children: <Widget>[
                Expanded(
                  child: InventorySummaryCard(title: 'Koli', value: 0),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InventorySummaryCard(title: 'Scan', value: 0),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InventorySummaryCard(title: 'Hilang', value: 0),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Datas
            if (_tagInfos.isEmpty)
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
                  itemBuilder: (context, index) => BatchCardStatusItem(
                    batch: BatchEntity(
                      id: '$index',
                      batch: _tagInfos[index].epcId,
                      destination: faker.address.city(),
                      itemCount: faker.randomGenerator.integer(100, min: 1),
                      origin: faker.address.city(),
                      path: faker.randomGenerator.mapElementValue(shipmentPath),
                      sendAt: faker.date.dateTime(),
                      status:
                          faker.randomGenerator.mapElementValue(shipmentStatus),
                    ),
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemCount: _tagInfos.length,
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
        child: _isInventoryRunning
            ? const Icon(Icons.stop)
            : const Icon(Icons.play_arrow),
      ),
    );
  }
}
