import 'package:flutter/material.dart';

import '../../../../core/themes/colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/decorated_icon_button.dart';
import '../../../../core/widgets/primary_gradient_card.dart';
import '../../../../main.dart';
import '../../../../uhf_result_model.dart';
import '../../domain/entity/batch_entity.dart';
import '../widgets/batch_card_item.dart';

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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: kToolbarHeight + kSpaceBarHeight + 128,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryGradientCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Barang di Gudang \$Warehouse',
                              style: const TextStyle(
                                color: light,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Total Koli',
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
                    Row(
                      children: <Widget>[
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
                  ],
                ),
              ),
            ),
            floating: true,
            pinned: true,
            snap: true,
            title: const Text('Terima Barang'),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: _buildList(),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: gray),
          ),
          color: light,
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton.small(
              onPressed: () {},
              backgroundColor: light,
              foregroundColor: danger,
              heroTag: 'scan_again',
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: danger),
              ),
              tooltip: 'Scan Ulang',
              child: Icon(Icons.restore),
            ),
            const SizedBox(width: 16),
            FloatingActionButton.small(
              onPressed: _uhfMethodHandler.invokeHandleInventory,
              backgroundColor: primary,
              foregroundColor: light,
              heroTag: 'start_stop_scan',
              tooltip: _isInventoryRunning ? 'Berhenti Scan' : 'Mulai Scan',
              child: _isInventoryRunning
                  ? const Icon(Icons.stop)
                  : const Icon(Icons.play_arrow),
            ),
            const SizedBox(width: 16),
            FloatingActionButton.small(
              onPressed: () {},
              backgroundColor: light,
              foregroundColor: primary,
              heroTag: 'save',
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: primary),
              ),
              tooltip: 'Simpan',
              child: Icon(Icons.save),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildList() {
    if (_tagInfos.isEmpty) {
      return SliverFillRemaining(
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
      );
    }

    return SliverList.separated(
      itemBuilder: (context, index) => BatchCardItem(
        batch: BatchEntity(
          id: '-',
          batch: _tagInfos[index].epcId,
          destination: faker.address.city(),
          itemCount: _tagInfos[index].frequency,
          origin: faker.address.city(),
          path: '-',
          sendAt: DateTime.now(),
          status: '-',
        ),
      ),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemCount: _tagInfos.length,
    );
  }
}
