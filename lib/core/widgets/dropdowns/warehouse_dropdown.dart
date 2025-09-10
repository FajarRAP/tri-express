import 'package:flutter/material.dart';

import '../dropdown_modal_item.dart';
import '../dropdown_search_modal.dart';

class WarehouseDropdown extends StatelessWidget {
  const WarehouseDropdown({
    super.key,
    this.onTap,
  });

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return DropdownSearchModal(
      search: (keyword) {},
      title: 'Gudang Asal',
      child: Expanded(
        child: ListView.separated(
          itemBuilder: (context, index) => GestureDetector(
            onTap: onTap,
            child: DropdownModalItem(child: const Text('Lorem 1')),
          ),
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemCount: 10,
          padding: const EdgeInsets.symmetric(vertical: 6),
        ),
      ),
    );
  }
}
