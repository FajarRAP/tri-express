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
import '../../../../../core/widgets/primary_gradient_card.dart';
import '../../../../../core/widgets/triple_floating_action_buttons.dart';
import '../../../../auth/presentation/cubit/auth_cubit.dart';
import '../../cubit/inventory_cubit.dart';
import '../../widgets/batch_card_item.dart';
import '../../widgets/scanned_item_card.dart';
import '../../widgets/shipment_receipt_numbers_bottom_sheet.dart';

class ReceiveGoodsScanPage extends StatefulWidget {
  const ReceiveGoodsScanPage({super.key});

  @override
  State<ReceiveGoodsScanPage> createState() => _ReceiveGoodsScanPageState();
}

class _ReceiveGoodsScanPageState extends State<ReceiveGoodsScanPage>
    with UHFMethodHandlerMixin {
  late final AuthCubit _authCubit;
  late final InventoryCubit _inventoryCubit;

  @override
  void initState() {
    super.initState();
    _authCubit = context.read<AuthCubit>();
    _inventoryCubit = context.read<InventoryCubit>();
    initUHFMethodHandler(platform);
  }

  @override
  InventoryCubit get inventoryCubit => _inventoryCubit;

  @override
  void Function() get onInventoryStop =>
      () => _inventoryCubit.fetchPreviewReceiveShipments(
          uniqueCodes: uhfResults.map((e) => e.epcId).toList());

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
                              'Barang di ${_authCubit.user.warehouse?.name}',
                              style: paragraphMedium[bold].copyWith(
                                color: light,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildTotalUnits(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: <Widget>[
                        const Expanded(
                          child: TextField(
                            decoration: InputDecoration(
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
        child: BlocListener<InventoryCubit, InventoryState>(
          listener: (context, state) {
            if (state is CreateShipmentsLoaded) {
              TopSnackbar.successSnackbar(message: state.message);
              context
                ..go(menuRoute)
                ..push(receiveGoodsRoute);
            }

            if (state is CreateShipmentsError) {
              TopSnackbar.dangerSnackbar(message: state.message);
            }
          },
          child: TripleFloatingActionButtons(
            onReset: onReset,
            onScan: onScan,
            onSave: () => showModalBottomSheet(
              context: context,
              builder: (context) => BlocBuilder<InventoryCubit, InventoryState>(
                builder: (context, state) {
                  final onPressed = switch (state) {
                    CreateShipmentsLoading() => null,
                    _ => () => _inventoryCubit.createReceiveShipments(
                          receivedAt: DateTime.now(),
                          uniqueCodes: uhfResults.map((e) => e.epcId).toList(),
                        ),
                  };

                  return ActionConfirmationBottomSheet(
                    onPressed: onPressed,
                    message: 'Apakah anda yakin akan menyimpan barang ini?',
                  );
                },
              ),
            ),
            isScanning: isInventoryRunning,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _buildList() {
    if (uhfResults.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
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
              itemBuilder: (context, index) => BatchCardItem(
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

  Widget _buildTotalUnits() {
    return BlocBuilder<InventoryCubit, InventoryState>(
      bloc: _inventoryCubit,
      buildWhen: (previous, current) =>
          current is FetchPreviewBatchesShipments || current is UHFAction,
      builder: (context, state) {
        final (String title, String value) = switch (state) {
          FetchPreviewBatchesShipmentsLoading() => ('Memuat', '...'),
          FetchPreviewBatchesShipmentsLoaded s => (
              'Total Koli Aktual',
              '${s.batches.fold<int>(0, (prev, e) => prev + e.totalAllUnits)}'
            ),
          OnUHFScan() => ('Total Koli Terscan', '${uhfResults.length}'),
          _ => ('Mulai scan untuk melihat total koli', '...'),
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: paragraphSmall[medium].copyWith(
                color: light,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: paragraphSmall[medium].copyWith(
                color: light,
              ),
            ),
          ],
        );
      },
    );
  }
}
