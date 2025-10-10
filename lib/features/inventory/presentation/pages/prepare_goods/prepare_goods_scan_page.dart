import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/fonts/fonts.dart';
import '../../../../../core/routes/router.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/utils/top_snackbar.dart';
import '../../../../../core/utils/uhf_utils.dart';
import '../../../../../core/widgets/action_confirmation_bottom_sheet.dart';
import '../../../../../core/widgets/decorated_icon_button.dart';
import '../../../../../core/widgets/floating_action_button_bar.dart';
import '../../../../../core/widgets/primary_gradient_card.dart';
import '../../../../core/domain/entities/dropdown_entity.dart';
import '../../../domain/entities/good_entity.dart';
import '../../cubit/inventory_cubit.dart';
import '../../widgets/good_card_checkbox.dart';
import '../../widgets/scanned_item_card.dart';
import '../../widgets/unique_code_action_bottom_sheet.dart';
import '../../widgets/unique_codes_bottom_sheet.dart';

class PrepareGoodsScanPage extends StatefulWidget {
  const PrepareGoodsScanPage({
    super.key,
    required this.shippedAt,
    required this.estimatedAt,
    required this.nextWarehouse,
    required this.transportMode,
    required this.batchName,
  });

  final DateTime shippedAt;
  final DateTime estimatedAt;
  final DropdownEntity nextWarehouse;
  final DropdownEntity transportMode;
  final String batchName;

  @override
  State<PrepareGoodsScanPage> createState() => _PrepareGoodsScanPageState();
}

class _PrepareGoodsScanPageState extends State<PrepareGoodsScanPage>
    with UHFMethodHandlerMixin {
  late final InventoryCubit _inventoryCubit;
  final _selectedCodes = <String, Set<String>>{};

  @override
  void initState() {
    super.initState();
    _inventoryCubit = context.read<InventoryCubit>();
    initUHFMethodHandler(platform);
  }

  @override
  InventoryCubit get inventoryCubit => _inventoryCubit;

  @override
  void Function() get onInventoryStop => () =>
      _inventoryCubit.fetchPreviewPrepareShipments(uhfresults: uhfResults);

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
                              'Batch ${widget.batchName}',
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
                        Expanded(
                          child: TextField(
                            onChanged: _inventoryCubit.searchGoods,
                            decoration: const InputDecoration(
                              hintText: 'Cari resi atau invoice',
                              prefixIcon: const Icon(Icons.search_outlined),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        DecoratedIconButton(
                          onTap: () => showModalBottomSheet(
                            context: context,
                            builder: (context) => UniqueCodeActionBottomSheet(
                              onResult: (value) {
                                if (uhfResults.any((e) => e.epcId == value)) {
                                  return TopSnackbar.dangerSnackbar(
                                      message: 'Kode sudah discan');
                                }
                                onQRScan(value);
                                TopSnackbar.successSnackbar(
                                    message: 'Berhasil ditambahkan');
                              },
                            ),
                          ),
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
            title: const Text('Persiapan Barang'),
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
        child: BlocConsumer<InventoryCubit, InventoryState>(
          buildWhen: (previous, current) =>
              current is FetchPreviewGoodsShipmentsLoaded ||
              current is QRCodeScan,
          listener: (context, state) {
            if (state is FetchPreviewGoodsShipmentsError) {
              TopSnackbar.dangerSnackbar(message: state.message);
            }
          },
          builder: (context, state) {
            final allGoods = state is FetchPreviewGoodsShipmentsLoaded
                ? state.allGoods
                : <GoodEntity>[];
            final goods = state is FetchPreviewGoodsShipmentsLoaded
                ? state.goods
                : <GoodEntity>[];

            return Row(
              children: <Widget>[
                if (goods.isNotEmpty && state is! QRCodeScan)
                  Expanded(
                    child: CheckboxListTile.adaptive(
                      onChanged: (value) {
                        if (value == null) return;

                        setState(() {
                          if (value) {
                            for (final good in allGoods) {
                              _selectedCodes[good.id] =
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
                      value: allGoods.every((good) =>
                              (_selectedCodes[good.id]?.length ?? 0) ==
                              good.uniqueCodes.length) &&
                          allGoods.isNotEmpty,
                      side: const BorderSide(color: primary),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                Expanded(
                  child: FloatingActionButtonBar(
                    onReset: () {
                      _selectedCodes.clear();
                      _inventoryCubit.clearPreviewedData();
                      onReset();
                    },
                    onScan: onScan,
                    onSave: () => showModalBottomSheet(
                      context: context,
                      builder: (context) =>
                          BlocConsumer<InventoryCubit, InventoryState>(
                        listener: (context, state) {
                          if (state is CreateShipmentsLoaded) {
                            TopSnackbar.successSnackbar(message: state.message);
                            context.goNamed(prepareGoodsRoute);
                          }

                          if (state is CreateShipmentsError) {
                            TopSnackbar.dangerSnackbar(message: state.message);
                          }
                        },
                        builder: (context, state) {
                          final onPressed = switch (state) {
                            CreateShipmentsLoading() => null,
                            _ => () => _inventoryCubit.createPrepareShipments(
                                shippedAt: widget.shippedAt,
                                estimatedAt: widget.estimatedAt,
                                nextWarehouse: widget.nextWarehouse,
                                transportMode: widget.transportMode,
                                batchName: widget.batchName,
                                selectedCodes: _selectedCodes),
                          };

                          return ActionConfirmationBottomSheet(
                            onPressed: onPressed,
                            message:
                                'Apakah anda yakin akan menyimpan barang ini?',
                          );
                        },
                      ),
                    ),
                    onSync: () => _inventoryCubit.fetchPreviewPrepareShipments(
                        uhfresults: uhfResults),
                    isScanning: isInventoryRunning,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _buildList() {
    if (uhfResults.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Text(
            'Belum ada item di gudang, klik pada icon scan untuk menerima item dengan RFID',
            style: label[medium].copyWith(color: primaryGradientEnd),
            textAlign: TextAlign.center,
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
          if (state.goods.isEmpty) {
            return SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(
                  'Barang tidak ditemukan, silahkan cek nama barang atau nomor resi',
                  style: label[medium].copyWith(color: primaryGradientEnd),
                  textAlign: TextAlign.center,
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
                      ? _selectedCodes[state.goods[index].id] =
                          state.goods[index].uniqueCodes.toSet()
                      : _selectedCodes.remove(state.goods[index].id));
                },
                onTap: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => UniqueCodesBottomSheet(
                    onSelected: (selectedCodes) {
                      context.pop();
                      setState(() => selectedCodes.isEmpty
                          ? _selectedCodes.remove(state.goods[index].id)
                          : _selectedCodes[state.goods[index].id] =
                              selectedCodes.toSet());
                    },
                    goodName: state.goods[index].name,
                    selectedCodes:
                        _selectedCodes[state.goods[index].id]?.toList() ?? [],
                    uniqueCodes: state.goods[index].uniqueCodes,
                  ),
                ),
                good: state.goods[index],
                isActive: _selectedCodes.containsKey(state.goods[index].id),
                selectedCodesCount:
                    _selectedCodes[state.goods[index].id]?.length ?? 0,
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemCount: state.goods.length,
            ),
          );
        }

        if (state is OnUHFScan || state is QRCodeScan) {
          return SliverPadding(
            padding: const EdgeInsets.only(bottom: 80),
            sliver: SliverList.builder(
              itemBuilder: (context, index) =>
                  ScannedItemCard(item: uhfResults[index]),
              itemCount: uhfResults.length,
            ),
          );
        }

        return const SliverToBoxAdapter();
      },
    );
  }
}
