import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/routes/router.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/widgets/base_card.dart';
import '../../domain/entity/batch_entity.dart';

class BatchCardItem extends StatefulWidget {
  const BatchCardItem({
    super.key,
    required this.batch,
    this.action,
    this.isCheckboxOpen = false,
  });

  final BatchEntity batch;
  final Widget? action;
  final bool isCheckboxOpen;

  @override
  State<BatchCardItem> createState() => _BatchCardItemState();
}

class _BatchCardItemState extends State<BatchCardItem> {
  final bgColor = primary.withValues(alpha: .05);
  final activeColor = primary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!widget.isCheckboxOpen) return;
        setState(() => widget.batch.isChecked = !widget.batch.isChecked);
      },
      child: BaseCard(
        backgroundColor: widget.isCheckboxOpen
            ? (widget.batch.isChecked ? bgColor : null)
            : null,
        borderColor: widget.isCheckboxOpen
            ? (widget.batch.isChecked ? activeColor : null)
            : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Checkbox
            AnimatedContainer(
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 200),
              width: widget.isCheckboxOpen ? (24 + 8) : 0,
              child: ClipRect(
                child: Row(
                  children: <Widget>[
                    Checkbox(
                      onChanged: (value) {
                        if (value == null) return;

                        setState(() => widget.batch.isChecked = value);
                      },
                      activeColor: activeColor,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: widget.batch.isChecked,
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
            // Batch Information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.batch.batch,
                              style: const TextStyle(
                                color: black,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${widget.batch.origin} → ${widget.batch.destination}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      widget.action ?? const SizedBox.shrink(),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () => context.push(
                      '$onTheWayRoute$batchDetailRoute/${widget.batch.id}',
                      extra: widget.batch.batch,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.calendar_today,
                          color: Colors.grey.shade600,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('dd MMMM yyyy')
                              .format(widget.batch.sendAt.toLocal()),
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
