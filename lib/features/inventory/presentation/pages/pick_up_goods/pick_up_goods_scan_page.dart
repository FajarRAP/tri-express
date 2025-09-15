import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/fonts/fonts.dart';
import '../../../../../core/routes/router.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../../core/widgets/action_confirmation_bottom_sheet.dart';
import '../../../../../core/widgets/decorated_icon_button.dart';
import '../../../../../core/widgets/primary_gradient_card.dart';
import '../../../../../core/widgets/triple_floating_action_buttons.dart';
import '../../../../../uhf_result_model.dart';
import '../../widgets/good_card_checkbox.dart';
import '../../widgets/shipment_receipt_numbers_bottom_sheet.dart';

class PickUpGoodsScanPage extends StatefulWidget {
  const PickUpGoodsScanPage({super.key});

  @override
  State<PickUpGoodsScanPage> createState() => _PickUpGoodsScanPageState();
}

class _PickUpGoodsScanPageState extends State<PickUpGoodsScanPage> {
  late final UHFMethodHandler _uhfMethodHandler;
  final _tagInfos = <UHFResultModel>[];
  final _selectedItemIds = <String>{};
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
                              style: paragraphMedium[bold].copyWith(
                                color: light,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Total Koli',
                              style: paragraphSmall[medium].copyWith(
                                color: light,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '\$Number',
                              style: paragraphSmall[medium].copyWith(
                                color: light,
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
                          onTap: () => context.push(scanBarcodeInnerRoute),
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
                  _selectedItemIds.clear();

                  setState(() {
                    if (_isSelectAll) {
                      for (var good in goods) {
                        _selectedItemIds.add(good.id);
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Center(
            child: Text(
              'Belum ada item di gudang, klik pada icon scan untuk menerima item dengan RFID',
              style: label[medium].copyWith(color: primaryGradientEnd),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 80),
      sliver: SliverList.separated(
        itemBuilder: (context, index) => GoodCardCheckbox(
          onChanged: (value) {
            if (value == null) return;

            setState(() => value
                ? _selectedItemIds.add(goods[index].id)
                : _selectedItemIds.remove(goods[index].id));
          },
          onTap: () => showModalBottomSheet(
            context: context,
            builder: (context) => ShipmentReceiptNumbersBottomSheet(
              onSelected: (selectedReceiptNumbers) =>
                  context.push(pickUpGoodsConfirmationRoute),
              batch: batch,
            ),
          ),
          good: goods[index],
          isActive: _selectedItemIds.contains(goods[index].id),
        ),
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemCount: null,
      ),
    );
  }
}
