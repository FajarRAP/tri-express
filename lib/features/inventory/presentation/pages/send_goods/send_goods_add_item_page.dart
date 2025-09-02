import 'package:flutter/material.dart';

import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/widgets/decorated_icon_button.dart';
import '../../../../../core/widgets/notification_icon_button.dart';
import '../../../../../core/widgets/primary_gradient_card.dart';
import '../../widgets/batch_card_quantity_item.dart';

class SendGoodsAddItemPage extends StatefulWidget {
  const SendGoodsAddItemPage({super.key});

  @override
  State<SendGoodsAddItemPage> createState() => _SendGoodsAddItemPageState();
}

class _SendGoodsAddItemPageState extends State<SendGoodsAddItemPage> {
  var _isCheckboxOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            actions: const <Widget>[
              NotificationIconButton(),
              SizedBox(width: 16),
            ],
            expandedHeight: kToolbarHeight + kSpaceBarHeight + 128,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Pengiriman ke Gudang Yogyakarta',
                      style: const TextStyle(
                        color: black,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryGradientCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Siap Kirim',
                              style: const TextStyle(
                                color: light,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '0',
                              style: const TextStyle(
                                color: light,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Cari resi atau invoice',
                              prefixIcon: const Icon(Icons.search_outlined),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        DecoratedIconButton(
                          icon: const Icon(Icons.qr_code_scanner_outlined),
                        ),
                        const SizedBox(width: 10),
                        DecoratedIconButton(
                          onTap: () => setState(
                              () => _isCheckboxOpen = !_isCheckboxOpen),
                          icon: const Icon(Icons.checklist_rtl_outlined),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            floating: true,
            snap: true,
            pinned: true,
            title: const Text('Kirim Barang'),
          ),
          if (false)
            const SliverFillRemaining(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 48),
                child: Center(
                  child: Text(
                    'Belum tersedia barang. Cek menu “Persiapan” untuk lanjut kirim.',
                    style: TextStyle(color: grayTertiary),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList.separated(
                itemBuilder: (context, index) => BatchCardQuantityItem(
                  batch: batch,
                  isCheckboxOpen: _isCheckboxOpen,
                ),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
              ),
            ),
        ],
      ),
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: gray),
          ),
          color: light,
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton.small(
              onPressed: () {},
              backgroundColor: light,
              elevation: 1,
              foregroundColor: danger,
              heroTag: 'scan_again',
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: danger),
              ),
              tooltip: 'Scan Ulang',
              child: Icon(Icons.restore),
            ),
            const SizedBox(width: 16),
            FloatingActionButton.small(
              // onPressed: _uhfMethodHandler.invokeHandleInventory,
              onPressed: null,
              backgroundColor: primary,
              elevation: 1,
              foregroundColor: light,
              heroTag: 'start_stop_scan',
              tooltip: false ? 'Berhenti Scan' : 'Mulai Scan',
              child:
                  false ? const Icon(Icons.stop) : const Icon(Icons.play_arrow),
            ),
            const SizedBox(width: 16),
            FloatingActionButton.small(
              onPressed: () {},
              backgroundColor: light,
              elevation: 1,
              foregroundColor: primary,
              heroTag: 'save',
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: primary),
              ),
              tooltip: 'Simpan',
              child: Icon(Icons.send_outlined),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
