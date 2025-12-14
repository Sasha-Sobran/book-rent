import 'package:flutter/material.dart';
import 'package:library_kursach/core/theme/theme.dart';

class MultiFilterSelector<T> extends StatefulWidget {
  const MultiFilterSelector({
    super.key,
    required this.label,
    required this.items,
    required this.selectedIds,
    required this.resetTick,
    required this.display,
    required this.onSelect,
    required this.emptyText,
    this.showLabel = true,
    this.placeholder,
  });

  final String label;
  final List<T> items;
  final List<int> selectedIds;
  final int resetTick;
  final String Function(T item) display;
  final void Function(List<int> ids) onSelect;
  final String emptyText;
  final bool showLabel;
  final String? placeholder;

  @override
  State<MultiFilterSelector<T>> createState() => _MultiFilterSelectorState<T>();
}

class _MultiFilterSelectorState<T> extends State<MultiFilterSelector<T>> {
  @override
  Widget build(BuildContext context) {
    final filtered = widget.items;

    final selectedSet = widget.selectedIds.toSet();
    final selectedLabels = widget.items.where((i) {
      final id = _tryGetId(i);
      return id != null && selectedSet.contains(id);
    }).map(widget.display).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabel) ...[
          Text(widget.label, style: AppTextStyles.caption),
          const SizedBox(height: 8),
        ],
        Row(
          children: [
            SizedBox(
              height: 48,
              width: 160,
              child: ElevatedButton.icon(
                onPressed: filtered.isEmpty && widget.selectedIds.isEmpty
                    ? null
                    : () async {
                        final chosen = await showModalBottomSheet<Set<int>>(
                          context: context,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          builder: (ctx) {
                            final tempSelected = widget.selectedIds.toSet();
                            return StatefulBuilder(
                              builder: (ctx, setModal) => Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.clear),
                                    title: const Text('Без фільтра'),
                                    onTap: () => Navigator.of(ctx).pop(<int>{}),
                                  ),
                                  const Divider(height: 1),
                                  Expanded(
                                    child: ListView.separated(
                                      padding: const EdgeInsets.all(12),
                                      itemCount: filtered.length,
                                      separatorBuilder: (_, __) => const Divider(height: 1),
                                      itemBuilder: (_, index) {
                                        final item = filtered[index];
                                        final id = _tryGetId(item);
                                        final selected = id != null && tempSelected.contains(id);
                                        return CheckboxListTile(
                                          value: selected,
                                          onChanged: (value) {
                                            if (id == null) return;
                                            setModal(() {
                                              if (tempSelected.contains(id)) {
                                                tempSelected.remove(id);
                                              } else {
                                                tempSelected.add(id);
                                              }
                                            });
                                          },
                                          title: Text(widget.display(item)),
                                        );
                                      },
                                    ),
                                  ),
                                  const Divider(height: 1),
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () => Navigator.of(ctx).pop(<int>{}),
                                          child: const Text('Скинути'),
                                        ),
                                        const SizedBox(width: 8),
                                        ElevatedButton(
                                          onPressed: () => Navigator.of(ctx).pop(tempSelected),
                                          style: AppButtons.primary(),
                                          child: const Text('Готово'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                        widget.onSelect(chosen?.toList() ?? const []);
                      },
                icon: const Icon(Icons.arrow_drop_down),
                label: Text(
                  selectedLabels.isNotEmpty ? selectedLabels.join(', ') : (widget.placeholder ?? 'Обрати'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
                style: AppButtons.secondary,
              ),
            ),
          ],
        ),
        if (widget.items.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(widget.emptyText, style: AppTextStyles.caption),
          ),
      ],
    );
  }

  int? _tryGetId(T item) {
    final value = (item as dynamic);
    try {
      return value.id as int?;
    } catch (_) {
      return null;
    }
  }
}


