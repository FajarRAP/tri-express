import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routes/router.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';
import '../../../../../core/widgets/dropdowns/warehouse_dropdown.dart';
import '../../../../../core/widgets/notification_icon_button.dart';

class SendGoodsFilterPage extends StatefulWidget {
  const SendGoodsFilterPage({super.key});

  @override
  State<SendGoodsFilterPage> createState() => _SendGoodsFilterPageState();
}

class _SendGoodsFilterPageState extends State<SendGoodsFilterPage> {
  late final TextEditingController _courierController;
  late final TextEditingController _warehouseController;

  @override
  void initState() {
    super.initState();
    _courierController = TextEditingController();
    _warehouseController = TextEditingController();
  }

  @override
  void dispose() {
    _courierController.dispose();
    _warehouseController.dispose();
    super.dispose();
  }

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
            TextFormField(
              onTap: () => showModalBottomSheet(
                context: context,
                builder: (context) => WarehouseDropdown(onTap: context.pop),
              ),
              controller: _warehouseController,
              decoration: const InputDecoration(
                labelText: 'Pilih Gudang Asal',
                hintText: 'Pilih Gudang Asal',
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              onTap: () => showModalBottomSheet(
                context: context,
                builder: (context) => WarehouseDropdown(onTap: context.pop),
              ),
              controller: _warehouseController,
              decoration: const InputDecoration(
                labelText: 'Pilih Kurir Gudang',
                hintText: 'Pilih Kurir Gudang',
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'DD MM YYYY',
                labelText: 'Tanggal Kirim',
                suffixIcon: Icon(Icons.calendar_month_outlined),
              ),
              initialValue: DateTime.now().toDDMMMMYYYY,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                onPressed: () => context.push(sendGoodsScanRoute),
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
