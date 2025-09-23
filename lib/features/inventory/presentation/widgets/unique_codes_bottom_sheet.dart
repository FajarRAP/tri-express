import 'package:flutter/material.dart';

import '../../../../core/fonts/fonts.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/option_chip.dart';

class UniqueCodesBottomSheet extends StatefulWidget {
  const UniqueCodesBottomSheet({
    super.key,
    required this.onSelected,
    required this.goodName,
    this.selectedCodes = const [],
    required this.uniqueCodes,
  });

  final void Function(List<String> selectedCodes) onSelected;
  final String goodName;
  final List<String> selectedCodes;
  final List<String> uniqueCodes;

  @override
  State<UniqueCodesBottomSheet> createState() => _UniqueCodesBottomSheetState();
}

class _UniqueCodesBottomSheetState extends State<UniqueCodesBottomSheet> {
  final _selectedCodes = <String>{};

  @override
  void initState() {
    super.initState();
    _selectedCodes.addAll(widget.selectedCodes);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: lightBlue,
                ),
                height: 70,
                width: 70,
                child: const Icon(
                  Icons.inventory,
                  color: primary,
                ),
              ),
              const SizedBox(width: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    widget.goodName,
                    style: paragraphSmall[bold],
                  ),
                  Text(
                    '${widget.uniqueCodes.length} Koli',
                    style: label[regular],
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Nomor Resi',
            style: paragraphSmall[medium],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                final firstIndex = index * 2;
                final secondIndex = firstIndex + 1;
                final isOdd = secondIndex >= widget.uniqueCodes.length;

                return Row(
                  children: <Widget>[
                    Expanded(
                      child: OptionChip(
                        onSelected: (value) => _onSelected(value, firstIndex),
                        isActive: _selectedCodes
                            .contains(widget.uniqueCodes[firstIndex]),
                        text: widget.uniqueCodes[firstIndex],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: isOdd
                          ? const SizedBox()
                          : OptionChip(
                              onSelected: (value) =>
                                  _onSelected(value, secondIndex),
                              isActive: _selectedCodes
                                  .contains(widget.uniqueCodes[secondIndex]),
                              text: widget.uniqueCodes[secondIndex],
                            ),
                    ),
                  ],
                );
              },
              itemCount: (widget.uniqueCodes.length / 2).ceil(),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
            ),
          ),
          PrimaryButton(
            onPressed: () => widget.onSelected(_selectedCodes.toList()),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _onSelected(bool value, int index) =>
      setState(() => _isContainCode(index)
          ? _selectedCodes.remove(widget.uniqueCodes[index])
          : _selectedCodes.add(widget.uniqueCodes[index]));

  bool _isContainCode(int index) =>
      _selectedCodes.contains(widget.uniqueCodes[index]);
}
