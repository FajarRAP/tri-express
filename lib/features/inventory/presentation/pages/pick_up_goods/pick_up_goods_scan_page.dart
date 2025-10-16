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
import '../../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../domain/entities/good_entity.dart';
import '../../cubit/pick_up_cubit.dart';
import '../../cubit/scanner_cubit.dart';
import '../../widgets/good_card_checkbox.dart';
import '../../widgets/scanned_item_card.dart';
import '../../widgets/unique_code_action_bottom_sheet.dart';
import '../../widgets/unique_codes_bottom_sheet.dart';

class PickUpGoodsScanPage extends StatefulWidget {
  const PickUpGoodsScanPage({super.key});

  @override
  State<PickUpGoodsScanPage> createState() => _PickUpGoodsScanPageState();
}

class _PickUpGoodsScanPageState extends State<PickUpGoodsScanPage>
    with UHFMethodHandlerMixin {
  late final AuthCubit _authCubit;
  late final PickUpCubit _pickUpCubit;
  late final ScannerCubit _scannerCubit;
  final _selectedCodes = <String, Set<String>>{};

  @override
  void initState() {
    super.initState();
    _authCubit = context.read<AuthCubit>();
    _pickUpCubit = context.read<PickUpCubit>()
      ..clearGoods()
      ..resetState();
    _scannerCubit = context.read<ScannerCubit>();
    initUHFMethodHandler(platform);
  }

  @override
  ScannerCubit get scannerCubit => _scannerCubit;

  @override
  void Function() get onInventoryStop => () => _pickUpCubit
      .fetchPreviewPickUpGoods(uhfResults: _scannerCubit.state.uhfResults);

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
                        Expanded(
                          child: TextField(
                            onChanged: _pickUpCubit.searchGoods,
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
        child: BlocBuilder<PickUpCubit, ReusableState>(
          buildWhen: (previous, current) => current is FetchPreviewGoods,
          builder: (context, state) {
            final allGoods =
                state is FetchPreviewGoodsLoaded ? state.data : <GoodEntity>[];
            final goods = state is FetchPreviewGoodsLoaded
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
                      value: allGoods.every((good) =>
                              (_selectedCodes[good.receiptNumber]?.length ??
                                  0) ==
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
                          _pickUpCubit.clearGoods();
                          onReset();
                        },
                        onScan: onScan,
                        onSave: () => showModalBottomSheet(
                          context: context,
                          builder: (context) => ActionConfirmationBottomSheet(
                            onPressed: () {
                              if (_selectedCodes.isEmpty) {
                                const message =
                                    'Pilih barang yang akan diambil';
                                return TopSnackbar.dangerSnackbar(
                                    message: message);
                              }
                              context.pushNamed(
                                pickUpGoodsConfirmationRoute,
                                extra: _selectedCodes,
                              );
                            },
                            message:
                                'Apakah anda yakin akan mengambil barang ini?',
                          ),
                        ),
                        onSync: () {
                          if (scannerState.uhfResults.isEmpty) {
                            return TopSnackbar.dangerSnackbar(
                              message: 'Belum ada barang yang discan',
                            );
                          }

                          _scannerCubit.updateInventoryStatus(false);
                          _pickUpCubit.fetchPreviewPickUpGoods(
                              uhfResults: scannerState.uhfResults);
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

        return BlocBuilder<PickUpCubit, ReusableState>(
          buildWhen: (previous, current) => current is FetchPreviewGoods,
          builder: (context, state) {
            if (state is FetchPreviewGoodsLoading) {
              return const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              );
            }

            if (state is FetchPreviewGoodsLoaded) {
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
                          ? _selectedCodes[goods[index].receiptNumber] =
                              goods[index].uniqueCodes.toSet()
                          : _selectedCodes.remove(goods[index].receiptNumber));
                    },
                    onTap: () => showModalBottomSheet(
                      builder: (context) => UniqueCodesBottomSheet(
                        onSelected: (selectedCodes) {
                          context.pop();
                          setState(() => selectedCodes.isEmpty
                              ? _selectedCodes
                                  .remove(goods[index].receiptNumber)
                              : _selectedCodes[goods[index].receiptNumber] =
                                  selectedCodes.toSet());
                        },
                        goodName: goods[index].name,
                        selectedCodes:
                            _selectedCodes[goods[index].receiptNumber]
                                    ?.toList() ??
                                [],
                        uniqueCodes: goods[index].uniqueCodes,
                      ),
                      context: context,
                    ),
                    good: goods[index],
                    isActive:
                        _selectedCodes.containsKey(goods[index].receiptNumber),
                    selectedCodesCount:
                        _selectedCodes[goods[index].receiptNumber]?.length ?? 0,
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemCount: goods.length,
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

        return BlocBuilder<PickUpCubit, ReusableState>(
          buildWhen: (previous, current) => current is FetchPreviewGoods,
          builder: (context, state) {
            final (String title, String value) = switch (state) {
              FetchPreviewGoodsLoading() => ('Memuat', '-'),
              FetchPreviewGoodsLoaded s => ('Total Barang', '${s.data.length}'),
              _ => ('Mulai scan untuk melihat pengiriman', '-'),
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
