import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/fonts/fonts.dart';
import '../../../../core/routes/router.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/decorated_icon_button.dart';
import '../../../../core/widgets/primary_gradient_card.dart';
import '../widgets/batch_card_item.dart';
import '../widgets/shipment_receipt_numbers_bottom_sheet.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

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
                              'Jumlah Koli di Gudang',
                              style: paragraphMedium[bold].copyWith(
                                color: light,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '\$Number',
                              style: heading5[bold].copyWith(
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
                            decoration: InputDecoration(
                              hintText: 'Cari resi atau invoice',
                              prefixIcon: const Icon(Icons.search_outlined),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        DecoratedIconButton(
                          onTap: () {},
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
            title: const Text('Inventory Gudang'),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList.separated(
              itemBuilder: (context, index) => BatchCardItem(
                onTap: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => ShipmentReceiptNumbersBottomSheet(
                    onSelected: (selectedReceiptNumbers) => context.push(
                        '$itemDetailRoute/${selectedReceiptNumbers.first}'),
                    batch: batch,
                  ),
                ),
                batch: batch,
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemCount: null,
            ),
          ),
        ],
      ),
    );
  }
}
