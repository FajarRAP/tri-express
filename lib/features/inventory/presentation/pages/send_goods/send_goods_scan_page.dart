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
import '../../../../../core/widgets/notification_icon_button.dart';
import '../../../../../core/widgets/primary_gradient_card.dart';
import '../../../../core/domain/entities/dropdown_entity.dart';
import '../../../domain/entities/batch_entity.dart';
import '../../cubit/delivery_cubit.dart';
import '../../cubit/scanner_cubit.dart';
import '../../widgets/batch_card_checkbox.dart';
import '../../widgets/scanned_item_card.dart';
import '../../widgets/unique_code_action_bottom_sheet.dart';

class SendGoodsScanPage extends StatefulWidget {
  const SendGoodsScanPage({
    super.key,
    required this.driver,
    required this.nextWarehouse,
    required this.deliveredAt,
  });

  final DropdownEntity driver;
  final DropdownEntity nextWarehouse;
  final DateTime deliveredAt;

  @override
  State<SendGoodsScanPage> createState() => _SendGoodsScanPageState();
}

class _SendGoodsScanPageState extends State<SendGoodsScanPage>
    with UHFMethodHandlerMixinV2 {
  late final DeliveryCubit _deliveryCubit;
  late final ScannerCubit _scannerCubit;
  final _selectedBatches = <BatchEntity>{};

  @override
  void initState() {
    super.initState();
    _deliveryCubit = context.read<DeliveryCubit>()
      ..clearBatches()
      ..resetState();
    _scannerCubit = context.read<ScannerCubit>();
    initUHFMethodHandler(platform);
  }

  @override
  ScannerCubit get scannerCubit => _scannerCubit;

  @override
  void Function() get onInventoryStop =>
      () => _deliveryCubit.fetchPreviewDeliveryShipments(
          nextWarehouse: widget.nextWarehouse,
          uhfresults: _scannerCubit.state.uhfResults);

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
                        child: BlocBuilder<ScannerCubit, ScannerState>(
                          builder: (context, scannerState) {
                            if (scannerState.isFromQRScanner ||
                                scannerState.isFromUHFReader) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const Text(
                                    'Koli Berhasil Discan',
                                    style: const TextStyle(
                                      color: light,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '${scannerState.uhfResults.length}',
                                    style: const TextStyle(
                                      color: light,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              );
                            }

                            return BlocBuilder<DeliveryCubit,
                                ReusableState<List<BatchEntity>>>(
                              buildWhen: (previous, current) =>
                                  current is FetchPreviewShipments,
                              builder: (context, state) {
                                final count = switch (state) {
                                  FetchPreviewShipmentsLoaded() =>
                                    state.allBatches.length,
                                  _ => 0,
                                };

                                return Column(
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
                                    Text(
                                      '$count',
                                      style: const TextStyle(
                                        color: light,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            onChanged: _deliveryCubit.searchBatches,
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
        child: BlocBuilder<DeliveryCubit, ReusableState<List<BatchEntity>>>(
          buildWhen: (previous, current) => current is FetchPreviewShipments,
          builder: (context, state) {
            final batches = state is FetchPreviewShipmentsLoaded
                ? state.data
                : <BatchEntity>[];

            return Row(
              children: <Widget>[
                if (batches.isNotEmpty)
                  Expanded(
                    child: CheckboxListTile.adaptive(
                      onChanged: (value) {
                        if (value == null) return;

                        setState(() => value
                            ? _selectedBatches.addAll(batches)
                            : _selectedBatches.clear());
                      },
                      title: Text(
                        'Semua',
                        style: label[medium].copyWith(color: primary),
                      ),
                      value: _selectedBatches.length == batches.length &&
                          batches.isNotEmpty,
                      side: const BorderSide(color: primary),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                BlocBuilder<ScannerCubit, ScannerState>(
                  builder: (context, scannerState) {
                    return Expanded(
                      child: FloatingActionButtonBar(
                        onReset: () {
                          _selectedBatches.clear();
                          _deliveryCubit.clearBatches();
                          onReset();
                        },
                        onScan: onScan,
                        onSave: () => showModalBottomSheet(
                          builder: (context) => BlocConsumer<DeliveryCubit,
                              ReusableState<List<BatchEntity>>>(
                            listener: (context, state) {
                              if (state is ActionSuccess<List<BatchEntity>>) {
                                TopSnackbar.successSnackbar(
                                    message: state.message);
                                context.goNamed(sendGoodsRoute);
                              }

                              if (state is ActionFailure<List<BatchEntity>>) {
                                TopSnackbar.dangerSnackbar(
                                    message: state.failure.message);
                              }
                            },
                            builder: (context, state) {
                              final onPressed = switch (state) {
                                ActionInProgress() => null,
                                _ => () =>
                                    _deliveryCubit.createDeliveryShipments(
                                      nextWarehouse: widget.nextWarehouse,
                                      driver: widget.driver,
                                      batches: _selectedBatches,
                                      deliveredAt: widget.deliveredAt,
                                    ),
                              };

                              return ActionConfirmationBottomSheet(
                                onPressed: onPressed,
                                message:
                                    'Apakah anda yakin akan mengirim barang ini?',
                              );
                            },
                          ),
                          context: context,
                        ),
                        onSync: () {
                          if (scannerState.uhfResults.isEmpty) {
                            return TopSnackbar.dangerSnackbar(
                              message: 'Belum ada barang yang discan',
                            );
                          }

                          _scannerCubit.updateInventoryStatus(false);
                          _deliveryCubit.fetchPreviewDeliveryShipments(
                            nextWarehouse: widget.nextWarehouse,
                            uhfresults: scannerState.uhfResults,
                          );
                        },
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
                'Belum tersedia barang. Cek menu “Persiapan” untuk lanjut kirim.',
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

        return BlocBuilder<DeliveryCubit, ReusableState<List<BatchEntity>>>(
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
              if (state.filteredBatches.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'Tidak ada data yang sesuai.',
                      style: label[medium].copyWith(color: primaryGradientEnd),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.only(bottom: 96),
                sliver: SliverList.separated(
                  itemBuilder: (context, index) => BatchCardCheckbox(
                    onChanged: (value) {
                      if (value == null) return;

                      setState(() => value
                          ? _selectedBatches.add(state.filteredBatches[index])
                          : _selectedBatches
                              .remove(state.filteredBatches[index]));
                    },
                    onTap: () => context.pushNamed(
                      receiptNumbersRoute,
                      extra: {
                        'batch': state.filteredBatches[index],
                        'routeDetailName': sendGoodsDetailRoute,
                      },
                    ),
                    isActive:
                        _selectedBatches.contains(state.filteredBatches[index]),
                    batch: state.filteredBatches[index],
                    quantity: _renderQuantity(state.filteredBatches[index]),
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemCount: state.filteredBatches.length,
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

  Widget _renderQuantity(BatchEntity batch) {
    if (batch.totalAllUnits < batch.preparedUnits) {
      return RichText(
        text: TextSpan(
          children: <InlineSpan>[
            TextSpan(
              text: '${batch.totalAllUnits}',
              style: label[regular].copyWith(color: black),
            ),
            TextSpan(
              text: '/${batch.preparedUnits} Koli',
              style: label[bold].copyWith(color: black),
            ),
          ],
        ),
      );
    }

    return Text(
      '${batch.totalAllUnits} Koli',
      style: label[bold].copyWith(color: black),
    );
  }
}
