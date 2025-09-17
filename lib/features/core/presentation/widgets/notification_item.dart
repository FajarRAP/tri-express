import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/fonts/fonts.dart';
import '../../../../core/routes/router.dart';
import '../../../../core/themes/colors.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('$itemDetailRoute/INV.2507231447604'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'INV.2507231447604',
            style: label[regular].copyWith(color: gray),
          ),
          RichText(
            text: TextSpan(
              style: paragraphSmall[regular].copyWith(color: black),
              text: 'Paket dengan kode ',
              children: <InlineSpan>[
                TextSpan(
                  style: paragraphSmall[bold].copyWith(color: black),
                  text: 'cn/mn/sto',
                ),
                const TextSpan(
                  text: ' dijadwalkan tiba di Gudang hari ini.',
                ),
                TextSpan(
                  style: paragraphSmall[regular].copyWith(color: gray),
                  text: ' 1 menit yang lalu',
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
