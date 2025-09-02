import 'package:flutter/material.dart';

import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/widgets/base_card.dart';
import '../../../../../core/widgets/decorated_icon_button.dart';
import '../../../../../core/widgets/notification_icon_button.dart';

class PrepareGoodsAddItemPage extends StatelessWidget {
  const PrepareGoodsAddItemPage({
    super.key,
    required this.batchName,
  });

  final String batchName;

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
            expandedHeight: kToolbarHeight + kSpaceBarHeight,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.all(16),
                child: Row(
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
                      // onTap: () => context.push(filterPrepareGoodsRoute),
                      icon: const Icon(Icons.qr_code_scanner_outlined),
                    ),
                  ],
                ),
              ),
            ),
            floating: true,
            snap: true,
            pinned: true,
            title: Text(batchName),
          ),
          // When items empty
          if (false)
            const SliverFillRemaining(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 48),
                child: Center(
                  child: Text(
                    'Klik tombol “Scan” untuk mulai memasukkan barang ke dalam batch pengiriman ini.',
                    style: TextStyle(color: grayTertiary),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              sliver: SliverList.separated(
                itemBuilder: (context, index) => BaseCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'INV.25072',
                            style: const TextStyle(
                              color: black,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'CN/TRI/Yulie',
                            style: const TextStyle(
                              color: grayTertiary,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.shopping_bag_outlined,
                                color: grayTertiary,
                              ),
                              Text(
                                '10/10 Jumlah koli',
                                style: const TextStyle(
                                  color: grayTertiary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: primary),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 48,
                        width: 48,
                        child: Text(
                          '10',
                          style: const TextStyle(
                            color: primary,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
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
              foregroundColor: primary,
              heroTag: 'save',
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: primary),
              ),
              tooltip: 'Simpan',
              child: Icon(Icons.save),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
