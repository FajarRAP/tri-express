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
import '../../widgets/good_card_checkbox.dart';
import '../../widgets/scanned_item_card.dart';
import '../../widgets/unique_codes_bottom_sheet.dart';

class PickUpGoodsScanPage extends StatefulWidget {
  const PickUpGoodsScanPage({super.key});

  @override
  State<PickUpGoodsScanPage> createState() => _PickUpGoodsScanPageState();
}

class _PickUpGoodsScanPageState extends State<PickUpGoodsScanPage>
    with UHFMethodHandlerMixin {
  late final AuthCubit _authCubit;
  late final InventoryCubit _inventoryCubit;
  final _selectedCodes = <String, Set<String>>{};

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
      () => _inventoryCubit.fetchPreviewPickUpGoods(uhfResults: uhfResults);

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
                            Text(
                              'Total Koli Terscan',
                              style: paragraphSmall[medium].copyWith(
                                color: light,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${uhfResults.length}',
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
            title: const Text('Ambil di Gudang'),
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

                  setState(() {
                    if (value) {
                      for (final good in _inventoryCubit.previewGoods) {
                        _selectedCodes[good.receiptNumber] =
                            good.uniqueCodes.toSet();
                      }
                    } else {
                      _selectedCodes.clear();
                    }
                  });
                },
                title: Text(
                  'Semua',
                  style: label[medium].copyWith(color: primary),
                ),
                value: _inventoryCubit.previewGoods.every((good) =>
                        (_selectedCodes[good.receiptNumber]?.length ?? 0) ==
                        good.uniqueCodes.length) &&
                    _inventoryCubit.previewGoods.isNotEmpty,
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
                  builder: (context) => ActionConfirmationBottomSheet(
                    onPressed: () {
                      if (_selectedCodes.isEmpty) {
                        const message = 'Pilih barang yang akan diambil';
                        return TopSnackbar.dangerSnackbar(message: message);
                      }
                      context.push(
                        pickUpGoodsConfirmationRoute,
                        extra: _selectedCodes,
                      );
                    },
                    message: 'Apakah anda yakin akan mengambil barang ini?',
                  ),
                ),
                isScanning: isInventoryRunning,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _buildList() {
    if (uhfResults.isEmpty) {
      return SliverFillRemaining(
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
          current is FetchPreviewGoodsShipments || current is UHFAction,
      builder: (context, state) {
        if (state is FetchPreviewGoodsShipmentsLoading) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        }

        if (state is FetchPreviewGoodsShipmentsLoaded) {
          return SliverPadding(
            padding: const EdgeInsets.only(bottom: 80),
            sliver: SliverList.separated(
              itemBuilder: (context, index) {
                final good = state.goods[index];

                return GoodCardCheckbox(
                  onChanged: (value) {
                    if (value == null) return;

                    setState(() => value
                        ? _selectedCodes[good.receiptNumber] =
                            good.uniqueCodes.toSet()
                        : _selectedCodes.remove(good.receiptNumber));
                  },
                  onTap: () => showModalBottomSheet(
                    builder: (context) => UniqueCodesBottomSheet(
                      onSelected: (selectedCodes) {
                        context.pop();
                        setState(() => selectedCodes.isEmpty
                            ? _selectedCodes.remove(good.receiptNumber)
                            : _selectedCodes[good.receiptNumber] =
                                selectedCodes.toSet());
                      },
                      goodName: good.name,
                      selectedCodes:
                          _selectedCodes[good.receiptNumber]?.toList() ?? [],
                      uniqueCodes: good.uniqueCodes,
                    ),
                    context: context,
                  ),
                  good: good,
                  isActive: _selectedCodes.containsKey(good.receiptNumber),
                  selectedCodesCount:
                      _selectedCodes[good.receiptNumber]?.length ?? 0,
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemCount: state.goods.length,
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
