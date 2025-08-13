import 'package:flutter/material.dart';

import '../themes/colors.dart';
import '../widgets/notification_icon_button.dart';
import '../widgets/primary_icon_rectangle.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              const CircleAvatar(radius: 24),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'User Name',
                    style: const TextStyle(
                      color: black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Icon(
                        Icons.location_pin,
                        color: grayTertiary,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Warehouse Location',
                        style: const TextStyle(
                          color: grayTertiary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            const NotificationIconButton(),
            const SizedBox(width: 16),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: <Widget>[
            const SizedBox(height: 24),
            Row(
              children: <Widget>[
                Expanded(
                  child: const _DataCard(
                    icon: Icons.local_shipping_outlined,
                    label: 'On the way',
                    number: 100,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: const _DataCard(
                    icon: Icons.inventory_2_outlined,
                    label: 'Koli diterima',
                    number: 30,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: const _DataCard(
                    icon: Icons.send_outlined,
                    label: 'Koli terkirim',
                    number: 150,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Silakan Tentukan Apa yang Ingin Anda Lakukan',
              style: TextStyle(
                color: black,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: <Widget>[
                _ActionCard(
                  icon: Icons.inventory_2_outlined,
                  title: 'Terima Barang',
                ),
                _ActionCard(
                  icon: Icons.inventory_2_outlined,
                  title: 'Persiapan Barang',
                ),
                _ActionCard(
                  icon: Icons.inventory_2_outlined,
                  title: 'Kirim Barang',
                ),
                _ActionCard(
                  icon: Icons.inventory_2_outlined,
                  title: 'Serahkan ke Kurir',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    this.onTap,
    required this.icon,
    required this.title,
  });

  final void Function()? onTap;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: graySecondary),
          borderRadius: BorderRadius.circular(30),
          color: light,
        ),
        padding: const EdgeInsets.all(20),
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                color: black,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            PrimaryIconRectangle(icon: icon),
          ],
        ),
      ),
    );
  }
}

class _DataCard extends StatelessWidget {
  const _DataCard({
    required this.number,
    required this.icon,
    required this.label,
  });

  final int number;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: lightBlue),
        borderRadius: BorderRadius.circular(14),
        color: light,
      ),
      height: 80,
      padding: const EdgeInsets.all(14),
      child: Column(
        children: <Widget>[
          Text(
            '$number',
            style: TextStyle(
              color: black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: grayTertiary,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Row(
          //   children: <Widget>[
          //     Row(
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: <Widget>[
          //         Icon(
          //           icon,
          //           color: grayTertiary,
          //           size: 16,
          //         ),
          //         const SizedBox(width: 6),
          //         Text(
          //           label,
          //           style: TextStyle(
          //             color: grayTertiary,
          //             fontSize: 14,
          //             fontWeight: FontWeight.w400,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
