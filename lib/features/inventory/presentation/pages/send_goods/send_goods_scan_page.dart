import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../../core/fonts/fonts.dart';
import '../../../../../core/routes/router.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/utils/top_snackbar.dart';
import '../../../../../core/utils/uhf_utils.dart';
import '../../../../../core/widgets/action_confirmation_bottom_sheet.dart';
import '../../../../../core/widgets/decorated_icon_button.dart';
import '../../../../../core/widgets/notification_icon_button.dart';
import '../../../../../core/widgets/primary_gradient_card.dart';
import '../../../../../core/widgets/triple_floating_action_buttons.dart';
import '../../../../core/domain/entities/dropdown_entity.dart';
import '../../../domain/entities/batch_entity.dart';
import '../../cubit/inventory_cubit.dart';
import '../../widgets/batch_card_checkbox.dart';
import '../../widgets/scanned_item_card.dart';
import '../../widgets/shipment_receipt_numbers_bottom_sheet.dart';

class SendGoodsScanPage extends StatefulWidget {
  const SendGoodsScanPage({
    super.key,
    required this.driver,
    required this.nextWarehouse,
  });

  final DropdownEntity driver;
  final DropdownEntity nextWarehouse;

  @override
  State<SendGoodsScanPage> createState() => _SendGoodsScanPageState();
}

class _SendGoodsScanPageState extends State<SendGoodsScanPage>
    with UHFMethodHandlerMixin {
  late final InventoryCubit _inventoryCubit;
  final _selectedBatches = <BatchEntity>{};

  @override
  void initState() {
    super.initState();
    _inventoryCubit = context.read<InventoryCubit>();
    initUHFMethodHandler(platform);
  }

  @override
  InventoryCubit get inventoryCubit => _inventoryCubit;

  @override
  void Function() get onInventoryStop =>
      () => _inventoryCubit.fetchPreviewDeliveryShipments(
          nextWarehouse: widget.nextWarehouse, uhfresults: uhfResults);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            actions: const <Widget>[
              NotificationIconButton(),
              SizedBox(width: 16),
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
                      'Pengiriman ke ${widget.nextWarehouse.value}',
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
                            const Text(
                              'Siap Kirim',
                              style: const TextStyle(
                                color: light,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            BlocBuilder<InventoryCubit, InventoryState>(
                              buildWhen: (previous, current) =>
                                  current is UHFAction ||
                                  current is FetchPreviewBatchesShipments,
                              builder: (context, state) {
                                if (state
                                    is FetchPreviewBatchesShipmentsLoaded) {
                                  return Text(
                                    '${state.batches.length} Koli',
                                    style: const TextStyle(
                                      color: light,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  );
                                }

                                return const Text(
                                  '...',
                                  style: TextStyle(
                                    color: light,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                  ),
                                );
                              },
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
                            decoration: const InputDecoration(
                              hintText: 'Cari resi atau invoice',
                              prefixIcon: const Icon(Icons.search_outlined),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        DecoratedIconButton(
                          onTap: () async {
                            final result = await context
                                .push<Barcode>(scanBarcodeInnerRoute);
                            if (result == null) return;

                            onQRScan('${result.displayValue}');
                          },
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

                  setState(() => value
                      ? _selectedBatches.addAll(_inventoryCubit.previewBatches)
                      : _selectedBatches.clear());
                },
                title: Text(
                  'Semua',
                  style: label[medium].copyWith(color: primary),
                ),
                value: _selectedBatches.length ==
                        _inventoryCubit.previewBatches.length &&
                    _inventoryCubit.previewBatches.isNotEmpty,
                side: const BorderSide(color: primary),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            Expanded(
              child: TripleFloatingActionButtons(
                onReset: onReset,
                onScan: onScan,
                onSave: () => showModalBottomSheet(
                  context: context,
                  builder: (context) =>
                      BlocConsumer<InventoryCubit, InventoryState>(
                    listener: (context, state) {
                      if (state is CreateShipmentsLoaded) {
                        TopSnackbar.successSnackbar(message: state.message);
                        context
                          ..go(menuRoute)
                          ..push(sendGoodsRoute);
                      }

                      if (state is CreateShipmentsError) {
                        TopSnackbar.dangerSnackbar(message: state.message);
                      }
                    },
                    builder: (context, state) {
                      final onPressed = switch (state) {
                        CreateShipmentsLoading() => null,
                        _ => () => _inventoryCubit.createDeliveryShipments(
                              nextWarehouse: widget.nextWarehouse,
                              driver: widget.driver,
                              batches: _selectedBatches,
                              deliveredAt: DateTime.now(),
                            ),
                      };
                      return ActionConfirmationBottomSheet(
                        onPressed: onPressed,
                        message: 'Apakah anda yakin akan mengirim barang ini?',
                      );
                    },
                  ),
                ),
                isScanning: isInventoryRunning,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildList() {
    if (uhfResults.isEmpty) {
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

    return BlocBuilder<InventoryCubit, InventoryState>(
      buildWhen: (previous, current) =>
          current is FetchPreviewBatchesShipments || current is UHFAction,
      builder: (context, state) {
        if (state is FetchPreviewBatchesShipmentsLoading) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        }

        if (state is FetchPreviewBatchesShipmentsLoaded) {
          return SliverPadding(
            padding: const EdgeInsets.only(bottom: 80),
            sliver: SliverList.separated(
              itemBuilder: (context, index) => BatchCardCheckbox(
                onChanged: (value) {
                  if (value == null) return;

                  setState(() => value
                      ? _selectedBatches.add(state.batches[index])
                      : _selectedBatches.remove(state.batches[index]));
                },
                onTap: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => ShipmentReceiptNumbersBottomSheet(
                    onSelected: (selectedGoods) => context.push(
                      receiveGoodsDetailRoute,
                      extra: {
                        'batch': state.batches[index],
                        'good': selectedGoods.first,
                      },
                    ),
                    batch: state.batches[index],
                  ),
                ),
                isActive: _selectedBatches.contains(state.batches[index]),
                batch: state.batches[index],
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemCount: state.batches.length,
            ),
          );
        }

        if (state is OnUHFScan || state is QRCodeScan) {
          return SliverPadding(
            padding: const EdgeInsets.only(bottom: 80),
            sliver: SliverList.builder(
              itemBuilder: (context, index) => ScannedItemCard(
                number: index + 1,
                item: uhfResults[index],
              ),
              itemCount: uhfResults.length,
            ),
          );
        }
        return const SliverToBoxAdapter();
      },
    );
  }
}
