import 'package:flutter/material.dart';

import '../../../../core/fonts/fonts.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/top_snackbar.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/option_chip.dart';
import '../../domain/entities/batch_entity.dart';
import '../../domain/entities/good_entity.dart';

class ShipmentReceiptNumbersBottomSheet extends StatefulWidget {
  const ShipmentReceiptNumbersBottomSheet({
    super.key,
    required this.onSelected,
    required this.batch,
  });

  final BatchEntity batch;
  final void Function(List<GoodEntity> selectedGood) onSelected;

  @override
  State<ShipmentReceiptNumbersBottomSheet> createState() =>
      _ShipmentReceiptNumbersBottomSheetState();
}

class _ShipmentReceiptNumbersBottomSheetState
    extends State<ShipmentReceiptNumbersBottomSheet> {
  final _selectedGood = <GoodEntity>{};
  var _index = -1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                    '${widget.batch.goods.length} Nomor Resi',
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 20,
                childAspectRatio: 4,
              ),
              itemBuilder: (context, goodsIndex) => OptionChip(
                onSelected: (value) {
                  setState(() => _index = goodsIndex);
                  _selectedGood
                    ..clear()
                    ..add(widget.batch.goods[_index]);
                },
                isActive: goodsIndex == _index,
                text: widget.batch.goods[goodsIndex].receiptNumber,
              ),
              itemCount: widget.batch.goods.length,
              physics: const NeverScrollableScrollPhysics(),
            ),
          ),
          PrimaryButton(
            onPressed: () {
              if (_selectedGood.isEmpty) {
                const message = 'Pilih nomor resi terlebih dahulu';
                return TopSnackbar.dangerSnackbar(message: message);
              }

              widget.onSelected(_selectedGood.toList());
            },
            child: const Text('Lihat Detail'),
          ),
        ],
      ),
    );
  }
}
