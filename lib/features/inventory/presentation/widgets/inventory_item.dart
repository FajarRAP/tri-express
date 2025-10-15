import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/fonts/fonts.dart';
import '../../../../core/routes/router.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/base_card.dart';
import '../../domain/entities/lost_good_entity.dart';
import 'info_tile.dart';

class InventoryItem extends StatelessWidget {
  const InventoryItem({
    super.key,
    required this.lostGood,
  });

  final LostGoodEntity lostGood;

  @override
  Widget build(BuildContext context) {
    const maxLength = 4;
    final length = lostGood.uniqueCodes.length;

    return GestureDetector(
      onTap: () => context.pushNamed(
        inventoryDetailRoute,
        extra: lostGood,
      ),
      child: BaseCard(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: primary50,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset(
                    boxSvgPath,
                    colorFilter: const ColorFilter.mode(
                      primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  lostGood.name,
                  style: label[medium].copyWith(
                    color: black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: InfoTile(
                    title: 'Nomor Invoice',
                    value: lostGood.invoiceNumber,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: InfoTile(
                    title: 'Nomor Resi',
                    value: lostGood.receiptNumber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: InfoTile(
                    title: 'Gudang Asal',
                    value: lostGood.origin.name,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: InfoTile(
                    title: 'Gudang Tujuan',
                    value: lostGood.destination.name,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: determineBadge(
                    lostGood.status ?? -1,
                    lostGood.statusLabel ?? '-',
                  ),
                ),
                const Flexible(child: SizedBox()),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Daftar Koli',
                  style: TextStyle(
                    color: black,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (lostGood.uniqueCodes.length < lostGood.totalItem)
                  Text(
                    '${lostGood.uniqueCodes.length}/${lostGood.totalItem} Koli',
                    style: const TextStyle(
                      color: black,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                else
                  Text(
                    '${lostGood.uniqueCodes.length} Koli',
                    style: const TextStyle(
                      color: black,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  )
              ],
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,
                spacing: 10,
                runSpacing: 10,
                children: List.generate(
                  length < maxLength ? length : maxLength,
                  (index) => _UniqueCodeBadge(
                    uniqueCode: lostGood.uniqueCodes[index],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _UniqueCodeBadge extends StatelessWidget {
  const _UniqueCodeBadge({required this.uniqueCode});

  final String uniqueCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: primary50,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 12,
      ),
      child: Text(
        uniqueCode,
        style: const TextStyle(
          color: black,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
