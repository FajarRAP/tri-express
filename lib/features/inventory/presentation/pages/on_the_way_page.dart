import 'package:flutter/material.dart';

import '../../../../core/themes/colors.dart';
import '../../../../core/widgets/badges/success_badge.dart';
import '../../../../core/widgets/base_card.dart';
import '../../../../core/widgets/buttons/outline_primary_button.dart';
import '../../../../core/widgets/notification_icon_button.dart';

class OnTheWayPage extends StatelessWidget {
  const OnTheWayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('On The Way'),
        actions: <Widget>[
          const NotificationIconButton(),
          const SizedBox(width: 16),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: <Color>[
                  primary,
                  primaryGradientEnd,
                ],
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Dalam Pengiriman ke \$Warehouse Location',
                  style: const TextStyle(
                    color: light,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Number',
                  style: const TextStyle(
                    color: light,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          BaseCard(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '\$From - \$To',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const SuccessBadge(label: 'Selesai'),
                  ],
                ),
                const SizedBox(height: 10),
                GridView.count(
                  childAspectRatio: 2.5 / 1,
                  crossAxisCount: 2,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                    _InfoColumn(
                      title: 'Batch',
                      value: 'Batch Name',
                    ),
                    _InfoColumn(
                      title: 'Jalur',
                      value: 'Path Name',
                    ),
                    _InfoColumn(
                      title: 'Total Koli',
                      value: 'Number',
                    ),
                    _InfoColumn(
                      title: 'Tanggal Dikirim',
                      value: 'Send At',
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: OutlinePrimaryButton(
                    onPressed: () {},
                    child: const Text('Detail'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  const _InfoColumn({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(
            color: gray,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '\$$value',
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
