import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/core/domain/entities/dropdown_entity.dart';
import '../../../features/core/presentation/cubit/core_cubit.dart';
import '../dropdown_modal_item.dart';
import '../dropdown_search_modal.dart';

class DriverDropdown extends StatefulWidget {
  const DriverDropdown({
    super.key,
    required this.onTap,
  });

  final void Function(DropdownEntity driver) onTap;

  @override
  State<DriverDropdown> createState() => _DriverDropdownState();
}

class _DriverDropdownState extends State<DriverDropdown> {
  late final CoreCubit _coreCubit;

  @override
  void initState() {
    super.initState();
    _coreCubit = context.read<CoreCubit>()..fetchDriverDropdown();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearchModal(
      search: _coreCubit.searchDropdown,
      title: 'Kurir Gudang',
      child: Expanded(
        child: BlocBuilder<CoreCubit, CoreState>(
          bloc: _coreCubit,
          buildWhen: (previous, current) => current is FetchDropdown,
          builder: (context, state) {
            if (state is FetchDropdownLoading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            if (state is FetchDropdownLoaded) {
              if (state.filteredItems.isEmpty) {
                return const Center(
                  child: Text('Data tidak ditemukan'),
                );
              }

              return ListView.separated(
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => widget.onTap(state.filteredItems[index]),
                  child: DropdownModalItem(
                    child: Text(state.filteredItems[index].value),
                  ),
                ),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemCount: state.filteredItems.length,
                padding: const EdgeInsets.symmetric(vertical: 6),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
