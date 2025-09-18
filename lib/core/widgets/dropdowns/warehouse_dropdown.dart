import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/core/domain/entities/dropdown_entity.dart';
import '../../../features/core/presentation/cubit/core_cubit.dart';
import '../dropdown_modal.dart';
import '../dropdown_modal_item.dart';

class WarehouseDropdown extends StatefulWidget {
  const WarehouseDropdown({
    super.key,
    required this.onTap,
    this.titleSuffix = '',
  });

  final void Function(DropdownEntity warehouse) onTap;
  final String titleSuffix;

  @override
  State<WarehouseDropdown> createState() => _WarehouseDropdownState();
}

class _WarehouseDropdownState extends State<WarehouseDropdown> {
  late final CoreCubit _coreCubit;

  @override
  void initState() {
    super.initState();
    _coreCubit = context.read<CoreCubit>()..fetchWarehouseDropdown();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownModal(
      title: 'Gudang ${widget.titleSuffix}'.trim(),
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
              return ListView.separated(
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => widget.onTap(state.items[index]),
                  child: DropdownModalItem(
                    child: Text(state.items[index].value),
                  ),
                ),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemCount: state.items.length,
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
