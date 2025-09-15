import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/core/domain/entities/dropdown_entity.dart';
import '../../../features/core/presentation/cubit/core_cubit.dart';
import '../dropdown_modal.dart';
import '../dropdown_modal_item.dart';

class TransportModeDropdown extends StatefulWidget {
  const TransportModeDropdown({
    super.key,
    required this.onTap,
  });

  final void Function(DropdownEntity transportMode) onTap;

  @override
  State<TransportModeDropdown> createState() => _TransportModeDropdownState();
}

class _TransportModeDropdownState extends State<TransportModeDropdown> {
  late final CoreCubit _coreCubit;

  @override
  void initState() {
    super.initState();
    _coreCubit = context.read<CoreCubit>()..fetchTransportModeDropdown();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownModal(
      title: 'Jalur',
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
