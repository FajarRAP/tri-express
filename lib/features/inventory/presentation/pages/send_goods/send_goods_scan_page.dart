import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/fonts/fonts.dart';
import '../../../../../core/routes/router.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../../core/widgets/action_confirmation_bottom_sheet.dart';
import '../../../../../core/widgets/decorated_icon_button.dart';
import '../../../../../core/widgets/notification_icon_button.dart';
import '../../../../../core/widgets/primary_gradient_card.dart';
import '../../../../../core/widgets/triple_floating_action_buttons.dart';
import '../../../../../uhf_result_model.dart';
import '../../widgets/batch_card_item.dart';
import '../../widgets/shipment_receipt_numbers_bottom_sheet.dart';

class SendGoodsScanPage extends StatefulWidget {
  const SendGoodsScanPage({super.key});

  @override
  State<SendGoodsScanPage> createState() => _SendGoodsScanPageState();
}

class _SendGoodsScanPageState extends State<SendGoodsScanPage> {
  late final UHFMethodHandler _uhfMethodHandler;
  final _tagInfos = <UHFResultModel>[];
  final _selectedBatchIds = <String>[];
  var _isInventoryRunning = false;
  var _isSelectAll = false;

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
            actions: <Widget>[
              NotificationIconButton(),
              const SizedBox(width: 16),
            ],
            expandedHeight: kToolbarHeight + kSpaceBarHeight + 128,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Pengiriman ke Gudang Yogyakarta',
                      style: const TextStyle(
                        color: black,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryGradientCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Siap Kirim',
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
                    const SizedBox(height: 16),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
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
            snap: true,
            pinned: true,
            title: const Text('Kirim Barang'),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: _buildList(),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: gray)),
          color: light,
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            Expanded(
              child: CheckboxListTile.adaptive(
                onChanged: (value) {
                  if (value == null) return;

                  _isSelectAll = value;
                  _selectedBatchIds.clear();

                  setState(() {
                    if (_isSelectAll) {
                      for (var good in goods) {
                        _selectedBatchIds.add(good.id);
                      }
                    }
                  });
                },
                title: Text(
                  'Semua',
                  style: label[medium].copyWith(color: primary),
                ),
                value: _isSelectAll,
                side: const BorderSide(color: primary),
                controlAffinity: ListTileControlAffinity.leading,
                visualDensity: VisualDensity(
                  horizontal: VisualDensity.minimumDensity,
                  vertical: VisualDensity.minimumDensity,
                ),
              ),
            ),
            Expanded(
              child: TripleFloatingActionButtons(
                onSave: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => ActionConfirmationBottomSheet(
                    onPressed: () => context
                      ..go(menuRoute)
                      ..push(sendGoodsRoute),
                    message: 'Apakah anda yakin akan mengirim barang ini?',
                  ),
                ),
                isScanning: _isInventoryRunning,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildList() {
    if (_tagInfos.isNotEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Text(
            'Belum tersedia barang. Cek menu “Persiapan” untuk lanjut kirim.',
            style: label[medium].copyWith(color: primaryGradientEnd),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return SliverList.separated(
      itemBuilder: (context, index) {
        return BatchCardItem(
          onTap: () => showModalBottomSheet(
            builder: (context) => ShipmentReceiptNumbersBottomSheet(
              onSelected: (selectedReceiptNumbers) => context
                  .push('$itemDetailRoute/${selectedReceiptNumbers.first}'),
              batch: batch,
            ),
            backgroundColor: light,
            context: context,
          ),
          batch: batch,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemCount: null,
    );
  }
}
