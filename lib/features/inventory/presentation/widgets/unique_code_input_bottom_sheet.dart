import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/buttons/outline_primary_button.dart';
import '../../../../core/widgets/buttons/primary_button.dart';

class UniqueCodeInputBottomSheet extends StatefulWidget {
  const UniqueCodeInputBottomSheet({
    super.key,
    this.onPressed,
  });

  final void Function(String value)? onPressed;

  @override
  State<UniqueCodeInputBottomSheet> createState() =>
      _UniqueCodeInputBottomSheetState();
}

class _UniqueCodeInputBottomSheetState
    extends State<UniqueCodeInputBottomSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          24, 0, 24, MediaQuery.viewInsetsOf(context).bottom + 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            autofocus: true,
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Kode Koli',
            ),
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 24),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinePrimaryButton(
                  onPressed: context.pop,
                  child: const Text('Batal'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: PrimaryButton(
                  onPressed: widget.onPressed == null
                      ? null
                      : () => widget.onPressed!(_controller.text),
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
