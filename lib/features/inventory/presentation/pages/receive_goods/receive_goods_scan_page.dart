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
import '../../../../../core/widgets/primary_gradient_card.dart';
import '../../../../../core/widgets/triple_floating_action_buttons.dart';
import '../../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../../core/domain/entities/uhf_result_entity.dart';
import '../../widgets/batch_card_item.dart';
import '../../widgets/shipment_receipt_numbers_bottom_sheet.dart';

class ReceiveGoodsScanPage extends StatefulWidget {
  const ReceiveGoodsScanPage({super.key});

  @override
  State<ReceiveGoodsScanPage> createState() => _ReceiveGoodsScanPageState();
}

class _ReceiveGoodsScanPageState extends State<ReceiveGoodsScanPage> {
  late final AuthCubit _authCubit;
  late final UHFMethodHandler _uhfMethodHandler;

  final _tagInfos = <UHFResultEntity>[];
  var _isInventoryRunning = false;

  @override
  void initState() {
    super.initState();
    _authCubit = context.read<AuthCubit>();
    _uhfMethodHandler = const UHFMethodHandler(platform);
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
                              'Barang di ${_authCubit.user.warehouse?.name}',
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
                              '${_tagInfos.length}',
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
        child: TripleFloatingActionButtons(
          onReset: () => setState(_tagInfos.clear),
          onSave: () => showModalBottomSheet(
            context: context,
            builder: (context) => ActionConfirmationBottomSheet(
              onPressed: () => context
                ..go(menuRoute)
                ..push(receiveGoodsRoute),
              message: 'Apakah anda yakin akan menyimpan barang ini?',
            ),
          ),
          isScanning: _isInventoryRunning,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildList() {
    if (_tagInfos.isEmpty) {
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

    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 80),
      sliver: SliverList.separated(
        // itemBuilder: (context, index) => Text(_tagInfos[index].epcId),
        itemBuilder: (context, index) => BatchCardItem(
          onTap: () => showModalBottomSheet(
            context: context,
            builder: (context) => ShipmentReceiptNumbersBottomSheet(
              onSelected: (selectedReceiptNumbers) => context
                  .push('$itemDetailRoute/${selectedReceiptNumbers.first}'),
              batch: batch,
            ),
          ),
          batch: batch,
        ),
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemCount: _tagInfos.length,
      ),
    );
  }
}
