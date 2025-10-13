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
import '../../../../../core/widgets/primary_gradient_card.dart';
import '../../../../../core/widgets/floating_action_button_bar.dart';
import '../../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../../core/domain/entities/dropdown_entity.dart';
import '../../../domain/entities/batch_entity.dart';
import '../../cubit/receive_cubit.dart';
import '../../cubit/scanner_cubit.dart';
import '../../widgets/batch_card_item.dart';
import '../../widgets/scanned_item_card.dart';
import '../../widgets/unique_code_action_bottom_sheet.dart';

class ReceiveGoodsScanPage extends StatefulWidget {
  const ReceiveGoodsScanPage({
    super.key,
    required this.origin,
    required this.receivedAt,
  });

  final DropdownEntity origin;
  final DateTime receivedAt;

  @override
  State<ReceiveGoodsScanPage> createState() => _ReceiveGoodsScanPageState();
}

class _ReceiveGoodsScanPageState extends State<ReceiveGoodsScanPage>
    with UHFMethodHandlerMixin {
  late final AuthCubit _authCubit;
  late final ReceiveCubit _receiveCubit;
  late final ScannerCubit _scannerCubit;

  @override
  void initState() {
    super.initState();
    _authCubit = context.read<AuthCubit>();
    _receiveCubit = context.read<ReceiveCubit>()
      ..clearBatches()
      ..resetState();
    _scannerCubit = context.read<ScannerCubit>();
    initUHFMethodHandler(platform);
  }

  @override
  ScannerCubit get scannerCubit => _scannerCubit;

  @override
  void Function() get onInventoryStop =>
      () => _receiveCubit.fetchPreviewReceiveShipments(
          origin: widget.origin, uhfresults: _scannerCubit.state.uhfResults);

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
                            onChanged: _receiveCubit.searchBatches,
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
        child: BlocBuilder<ScannerCubit, ScannerState>(
          builder: (context, scannerState) {
            return SizedBox(
              width: double.infinity,
              child: FloatingActionButtonBar(
                onReset: () {
                  _receiveCubit.clearBatches();
                  onReset();
                },
                onScan: onScan,
                onSave: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => BlocConsumer<ReceiveCubit,
                      ReusableState<List<BatchEntity>>>(
                    listener: (context, state) {
                      if (state is ActionSuccess<List<BatchEntity>>) {
                        TopSnackbar.successSnackbar(message: state.message);
                        context.goNamed(receiveGoodsRoute);
                      }

                      if (state is ActionFailure<List<BatchEntity>>) {
                        TopSnackbar.dangerSnackbar(
                            message: state.failure.message);
                      }
                    },
                    builder: (context, state) {
                      final onPressed = switch (state) {
                        ActionInProgress() => null,
                        _ => () => _receiveCubit.createReceiveShipments(
                            uhfresults: scannerState.uhfResults,
                            receivedAt: widget.receivedAt),
                      };

                      return ActionConfirmationBottomSheet(
                        onPressed: onPressed,
                        message: 'Apakah anda yakin akan menyimpan barang ini?',
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
                  _receiveCubit.fetchPreviewReceiveShipments(
                    origin: widget.origin,
                    uhfresults: scannerState.uhfResults,
                  );
                },
                isScanning: scannerState.isFromUHFReader,
              ),
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

        if (scannerState.isFromQRScanner || scannerState.isFromUHFReader) {
          return SliverPadding(
            padding: const EdgeInsets.only(bottom: 80),
            sliver: SliverList.builder(
              itemBuilder: (context, index) =>
                  ScannedItemCard(item: scannerState.uhfResults[index]),
              itemCount: scannerState.uhfResults.length,
            ),
          );
        }

        return BlocBuilder<ReceiveCubit, ReusableState<List<BatchEntity>>>(
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
                padding: const EdgeInsets.only(bottom: 80),
                sliver: SliverList.separated(
                  itemBuilder: (context, index) => BatchCardItem(
                    onTap: () => context.pushNamed(
                      receiptNumbersRoute,
                      extra: {
                        'batch': state.data[index],
                        'routeDetailName': receiveGoodsDetailRoute,
                      },
                    ),
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

        return BlocBuilder<ReceiveCubit, ReusableState<List<BatchEntity>>>(
          builder: (context, state) {
            final (String title, String value) = switch (state) {
              FetchPreviewShipmentsLoading() => ('Memuat', '-'),
              FetchPreviewShipmentsLoaded s => (
                  'Total Pengiriman',
                  '${s.allBatches.length}'
                ),
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

  Widget _renderQuantity(BatchEntity batch) {
    if (batch.receivedUnits < batch.deliveredUnits) {
      return RichText(
        text: TextSpan(
          children: <InlineSpan>[
            TextSpan(
              text: '${batch.totalAllUnits}',
              style: label[regular].copyWith(color: black),
            ),
            TextSpan(
              text: '/${batch.deliveredUnits - batch.receivedUnits} Koli',
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
