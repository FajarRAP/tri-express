import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/fonts/fonts.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/option_chip.dart';
import '../../domain/entities/batch_entity.dart';
import '../cubit/inventory_cubit.dart';

class ShipmentReceiptNumbersBottomSheet extends StatefulWidget {
  const ShipmentReceiptNumbersBottomSheet({
    super.key,
    required this.onSelected,
    required this.batch,
  });

  final BatchEntity batch;
  final void Function(List<String> selectedReceiptNumbers) onSelected;

  @override
  State<ShipmentReceiptNumbersBottomSheet> createState() =>
      _ShipmentReceiptNumbersBottomSheetState();
}

class _ShipmentReceiptNumbersBottomSheetState
    extends State<ShipmentReceiptNumbersBottomSheet> {
  late final InventoryCubit _inventoryCubit;
  final _selectedReceiptNumbers = <String>{};
  var _index = -1;

  @override
  void initState() {
    super.initState();
    _inventoryCubit = context.read<InventoryCubit>()
      ..fetchShipmentReceiptNumbers();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryCubit, InventoryState>(
      bloc: _inventoryCubit,
      builder: (context, state) {
        if (state is FetchShipmentReceiptNumbersLoading) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        if (state is FetchShipmentReceiptNumbersLoaded) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: lightBlue,
                      ),
                      height: 70,
                      width: 70,
                      child: const Icon(
                        Icons.inventory,
                        color: primary,
                      ),
                    ),
                    const SizedBox(width: 32),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          widget.batch.name,
                          style: paragraphSmall[bold],
                        ),
                        Text(
                          '${widget.batch.goods.length} Koli',
                          style: label[regular],
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Nomor Resi',
                  style: paragraphSmall[medium],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 20,
                      childAspectRatio: 4,
                    ),
                    itemBuilder: (context, goodsIndex) => OptionChip(
                      onSelected: (value) {
                        setState(() => _index = goodsIndex);
                        _selectedReceiptNumbers
                          ..clear()
                          ..add(widget.batch.goods[_index].receiptNumber);
                      },
                      isActive: goodsIndex == _index,
                      text: widget.batch.goods[goodsIndex].receiptNumber,
                    ),
                    itemCount: widget.batch.goods.length,
                  ),
                ),
                PrimaryButton(
                  onPressed: () {
                    if (_selectedReceiptNumbers.isEmpty) {
                      const message = 'Pilih nomor resi terlebih dahulu';
                      return TopSnackbar.dangerSnackbar(message: message);
                    }

                    widget.onSelected(_selectedReceiptNumbers.toList());
                  },
                  child: const Text('Lihat Detail'),
                ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
