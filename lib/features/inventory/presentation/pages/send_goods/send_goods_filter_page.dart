import 'package:flutter/material.dart';

import '../../../../../core/utils/constants.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';
import '../../../../../core/widgets/notification_icon_button.dart';

class SendGoodsFilterPage extends StatelessWidget {
  const SendGoodsFilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const <Widget>[
          NotificationIconButton(),
          SizedBox(width: 16),
        ],
        title: const Text('Kirim Barang'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            DropdownButtonFormField(
              onChanged: (value) {},
              decoration: const InputDecoration(
                hintText: 'Pilih gudang tujuan',
                labelText: 'Gudang Tujuan',
              ),
              items: dropdownItems,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField(
              onChanged: (value) {},
              decoration: const InputDecoration(
                hintText: 'Pilih kurir gudang',
                labelText: 'Kurir Gudang',
              ),
              items: dropdownItems,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'DD/MM/YYYY',
                labelText: 'Tanggal Terima',
                suffixIcon: Icon(Icons.calendar_month_outlined),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                onPressed: () {},
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
