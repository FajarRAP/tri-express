import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/fonts/fonts.dart';
import '../../../../../core/routes/router.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/utils/states.dart';
import '../../../../../core/utils/top_snackbar.dart';
import '../../../../../core/utils/uhf_utils.dart';
import '../../../../../core/widgets/action_confirmation_bottom_sheet.dart';
import '../../../../../core/widgets/decorated_icon_button.dart';
import '../../../../../core/widgets/floating_action_button_bar.dart';
import '../../../../../core/widgets/primary_gradient_card.dart';
import '../../../../core/domain/entities/dropdown_entity.dart';
import '../../../domain/entities/good_entity.dart';
import '../../cubit/prepare_cubit.dart';
import '../../cubit/scanner_cubit.dart';
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
  late final PrepareCubit _prepareCubit;
  late final ScannerCubit _scannerCubit;
  final _selectedCodes = <String, Set<String>>{};

  @override
  void initState() {
    super.initState();
    _prepareCubit = context.read<PrepareCubit>()
      ..clearGoods()
      ..resetState();
    _scannerCubit = context.read<ScannerCubit>();
    initUHFMethodHandler(platform);
  }

  @override
  ScannerCubit get scannerCubit => _scannerCubit;

  @override
  void Function() get onInventoryStop => () => _prepareCubit
      .fetchPreviewPrepareShipments(uhfresults: _scannerCubit.state.uhfResults);

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
                            _buildTotalUnits(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            onChanged: _prepareCubit.searchGoods,
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
                                if (_scannerCubit.state.uhfResults
                                    .any((e) => e.epcId == value)) {
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
        child: BlocBuilder<PrepareCubit, ReusableState<List>>(
          buildWhen: (previous, current) => current is FetchPreviewShipments,
          builder: (context, state) {
            final allGoods = state is FetchPreviewShipmentsLoaded
                ? state.data
                : <GoodEntity>[];
            final goods = state is FetchPreviewShipmentsLoaded
                ? state.filteredGoods
                : <GoodEntity>[];

            return Row(
              children: <Widget>[
                if (goods.isNotEmpty)
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
                BlocBuilder<ScannerCubit, ScannerState>(
                  builder: (context, scannerState) {
                    return Expanded(
                      child: FloatingActionButtonBar(
                        onReset: () {
                          _selectedCodes.clear();
                          _prepareCubit.clearGoods();
                          onReset();
                        },
                        onScan: onScan,
                        onSave: () => showModalBottomSheet(
                          context: context,
                          builder: (context) =>
                              BlocConsumer<PrepareCubit, ReusableState<List>>(
                            listener: (context, state) {
                              if (state is ActionSuccess<List>) {
                                TopSnackbar.successSnackbar(
                                    message: state.message);
                                context.goNamed(prepareGoodsRoute);
                              }

                              if (state is ActionFailure<List>) {
                                TopSnackbar.dangerSnackbar(
                                    message: state.failure.message);
                              }
                            },
                            builder: (context, state) {
                              final onPressed = switch (state) {
                                ActionInProgress() => null,
                                _ => () => _prepareCubit.createPrepareShipments(
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
                        onSync: () {
                          if (scannerState.uhfResults.isEmpty) {
                            return TopSnackbar.dangerSnackbar(
                              message: 'Belum ada barang yang discan',
                            );
                          }

                          _scannerCubit.updateInventoryStatus(false);
                          _prepareCubit.fetchPreviewPrepareShipments(
                              uhfresults: scannerState.uhfResults);
                        },
                        fabParams: ('Siapkan', boxSvgPath),
                        isScanning: scannerState.isFromUHFReader,
                      ),
                    );
                  },
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
    return BlocBuilder<ScannerCubit, ScannerState>(
      builder: (context, scannerState) {
        if (scannerState.uhfResults.isEmpty) {
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

        if (scannerState.isFromQRScanner || scannerState.isFromUHFReader) {
          return SliverPadding(
            padding: const EdgeInsets.only(bottom: 96),
            sliver: SliverList.builder(
              itemBuilder: (context, index) =>
                  ScannedItemCard(item: scannerState.uhfResults[index]),
              itemCount: scannerState.uhfResults.length,
            ),
          );
        }

        return BlocBuilder<PrepareCubit, ReusableState<List>>(
          buildWhen: (previous, current) => current is FetchPreviewShipments,
          builder: (context, state) {
            if (state is FetchPreviewShipmentsLoading) {
              return const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              );
            }

            if (state is FetchPreviewShipmentsLoaded) {
              final goods = state.filteredGoods;

              if (goods.isEmpty) {
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
                padding: const EdgeInsets.only(bottom: 96),
                sliver: SliverList.separated(
                  itemBuilder: (context, index) => GoodCardCheckbox(
                    onChanged: (value) {
                      if (value == null) return;

                      setState(() => value
                          ? _selectedCodes[goods[index].id] =
                              goods[index].uniqueCodes.toSet()
                          : _selectedCodes.remove(goods[index].id));
                    },
                    onTap: () => showModalBottomSheet(
                      context: context,
                      builder: (context) => UniqueCodesBottomSheet(
                        onSelected: (selectedCodes) {
                          context.pop();
                          setState(() => selectedCodes.isEmpty
                              ? _selectedCodes.remove(goods[index].id)
                              : _selectedCodes[goods[index].id] =
                                  selectedCodes.toSet());
                        },
                        goodName: goods[index].name,
                        selectedCodes:
                            _selectedCodes[goods[index].id]?.toList() ?? [],
                        uniqueCodes: goods[index].uniqueCodes,
                      ),
                    ),
                    good: goods[index],
                    isActive: _selectedCodes.containsKey(goods[index].id),
                    selectedCodesCount:
                        _selectedCodes[goods[index].id]?.length ?? 0,
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemCount: goods.length,
                ),
              );
            }

            if (state is FetchPreviewShipmentsError) {
              return SliverFillRemaining(
                child: Center(
                  child: Text(
                    state.failure.message,
                    style: label[medium].copyWith(color: primaryGradientEnd),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            return const SliverToBoxAdapter();
          },
        );
      },
    );
  }

  Widget _buildTotalUnits() {
    final style = paragraphSmall[medium].copyWith(color: light);

    return BlocBuilder<ScannerCubit, ScannerState>(
      builder: (context, scannerState) {
        if (scannerState.isFromQRScanner || scannerState.isFromUHFReader) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Koli Berhasil Dipindai', style: style),
              const SizedBox(height: 8),
              Text('${scannerState.uhfResults.length}', style: style),
            ],
          );
        }

        return BlocBuilder<PrepareCubit, ReusableState<List>>(
          builder: (context, state) {
            final (String title, String value) = switch (state) {
              FetchPreviewShipmentsLoading() => ('Memuat', '-'),
              FetchPreviewShipmentsLoaded s => (
                  'Total Barang',
                  '${s.data.length}'
                ),
              _ => ('Mulai scan untuk melihat barang', '-'),
            };

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: style),
                const SizedBox(height: 8),
                Text(value, style: style),
              ],
            );
          },
        );
      },
    );
  }
}
