import 'package:flutter/material.dart';

import '../../../../core/themes/colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/decorated_icon_button.dart';
import '../../../../core/widgets/primary_gradient_card.dart';
import '../../../../uhf_result_model.dart';
import '../widgets/batch_card_item.dart';
import 'on_the_way_page.dart';

class ReceiveGoodsPage extends StatefulWidget {
  const ReceiveGoodsPage({super.key});

  @override
  State<ReceiveGoodsPage> createState() => _ReceiveGoodsPageState();
}

class _ReceiveGoodsPageState extends State<ReceiveGoodsPage> {
  late final UHFMethodHandler _uhfMethodHandler;
  final _tagInfos = <UHFResultModel>[];
  var _isInventoryRunning = false;

  @override
  void initState() {
    super.initState();
    _uhfMethodHandler = UHFMethodHandler(platform);
    platform.setMethodCallHandler(
      (call) async => await _uhfMethodHandler.methodHandler(
        call,
        onGetTag: (tagInfo) {
          final index = _tagInfos.indexWhere((e) => e.epcId == tagInfo.epcId);

          setState(() => index != -1
              ? _tagInfos[index].updateInfo(tagInfo: tagInfo)
              : _tagInfos.add(tagInfo));
        },
        onToggleInventory: (toggleCase, response) {
          setState(() => _isInventoryRunning = response.statusCode == 1);

          call.method == startInventoryMethod
              ? TopSnackbar.successSnackbar(message: response.message)
              : TopSnackbar.dangerSnackbar(message: response.message);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terima Barang'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Card
            SizedBox(
              width: double.infinity,
              child: PrimaryGradientCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Barang di Gudang Bekasi',
                      style: const TextStyle(
                        color: light,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total Barang',
                      style: const TextStyle(
                        color: light,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$Number',
                      style: const TextStyle(
                        color: light,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Headers
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
                DecoratedIconButton(
                  onTap: () {},
                  icon: const Icon(Icons.qr_code_scanner_outlined),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // List
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
                  itemBuilder: (context, index) => BatchCardItem(
                    batch: Batch(
                      id: '-',
                      batch: _tagInfos[index].epcId,
                      destination: '-',
                      itemCount: _tagInfos[index].frequency,
                      origin: '-',
                      path: '-',
                      sendAt: DateTime.now(),
                      status: '-',
                    ),
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemCount: _tagInfos.length,
                  padding: const EdgeInsets.only(bottom: 24),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _uhfMethodHandler.invokeHandleInventory,
        backgroundColor: primary,
        foregroundColor: light,
        child: _isInventoryRunning
            ? const Icon(Icons.stop)
            : const Icon(Icons.play_arrow),
      ),
    );
  }
}
