part of '../pages/contact_us_page.dart';

class _SearchableDropdown extends StatefulWidget {
  final String  hint;
  final String? value;
  final List<Map<String, String>> items;
  final ValueChanged<String?> onChanged;
  final bool  isRtl, isMobile, hasError;
  final Color primaryColor;

  const _SearchableDropdown({
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.isRtl,
    required this.isMobile,
    required this.primaryColor,
    this.hasError = false,
  });

  @override
  State<_SearchableDropdown> createState() => _SearchableDropdownState();
}

class _SearchableDropdownState extends State<_SearchableDropdown> {
  final _searchCtrl = TextEditingController();
  final _focusNode  = FocusNode();
  OverlayEntry? _overlayEntry;
  final _layerLink = LayerLink();
  List<Map<String, String>> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  String _resolveDisplayLabel() {
    final key = widget.value ?? '';
    if (key.isEmpty) return '';
    final match = widget.items.firstWhere(
          (e) => e['key'] == key,
      orElse: () => {'value': key},
    );
    return match['value'] ?? key;
  }

  void _showOverlay() {
    _removeOverlay();
    _filteredItems = widget.items;
    _searchCtrl.clear();

    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _removeOverlay,
              child: const SizedBox.expand(),
            ),
          ),
          Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              offset: Offset(0, size.height),
              showWhenUnlinked: false,
              child: Material(
                elevation: 0,
                borderRadius: BorderRadius.circular(4.r),
                color: AppColors.background,
                child: StatefulBuilder(
                  builder: (context, setInnerState) {
                    return Container(
                      constraints: BoxConstraints(
                        maxHeight: widget.isMobile ? 220 : 225.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: custom.CustomTextField(
                              controller: _searchCtrl,
                              focusNode:  _focusNode,
                              hint: widget.isRtl ? 'بحث...' : 'Search...',
                              height: 34,
                              primaryColor: widget.primaryColor,
                              fillColor: AppColors.background,
                              prefixIcon: const Icon(Icons.search, size: 18),
                              valueStyle: StyleText.fontSize12Weight400
                                  .copyWith(color: AppColors.text),
                              hintStyle: StyleText.fontSize12Weight400
                                  .copyWith(color: Colors.grey),
                              onChanged: (query) {
                                setInnerState(() {
                                  if (query.isEmpty) {
                                    _filteredItems = widget.items;
                                  } else {
                                    final q = query.toLowerCase();
                                    _filteredItems = widget.items
                                        .where((item) =>
                                        (item['value'] ?? '')
                                            .toLowerCase()
                                            .contains(q))
                                        .toList();
                                  }
                                });
                              },
                            ),
                          ),
                          Flexible(
                            child: ScrollbarTheme(
                              data: ScrollbarThemeData(
                                thumbVisibility:
                                WidgetStateProperty.all(false),
                                trackVisibility:
                                WidgetStateProperty.all(false),
                                thickness:
                                WidgetStateProperty.all(0),
                                radius: Radius.zero,
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: _filteredItems.length,
                                itemBuilder: (_, i) {
                                  final item = _filteredItems[i];
                                  final selected =
                                      item['key'] == widget.value;
                                  return InkWell(
                                    onTap: () {
                                      widget.onChanged(item['key']);
                                      _removeOverlay();
                                    },
                                    hoverColor: AppColors.primary
                                        .withOpacity(0.1),
                                    child: Container(
                                      height: 32.h,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8.w),
                                      alignment: AlignmentDirectional
                                          .centerStart,
                                      color: selected
                                          ? widget.primaryColor
                                          .withOpacity(0.08)
                                          : null,
                                      child: Text(
                                        item['value'] ?? '',
                                        style: StyleText
                                            .fontSize12Weight400
                                            .copyWith(
                                          color: selected
                                              ? widget.primaryColor
                                              : AppColors.text,
                                          fontWeight: selected
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                        ),
                                        overflow:
                                        TextOverflow.ellipsis,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  Widget build(BuildContext context) {
    final displayLabel = _resolveDisplayLabel();

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _showOverlay,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            height: 32.h,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            decoration: BoxDecoration(
              color: widget.hasError
                  ? Colors.white
                  : const Color(0xFFF1F2ED),
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(
                color: widget.hasError
                    ? Colors.red
                    : Colors.transparent,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    displayLabel.isEmpty ? widget.hint : displayLabel,
                    style: StyleText.fontSize12Weight400.copyWith(
                      color: displayLabel.isEmpty
                          ? AppColors.secondaryBlack
                          : AppColors.text,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 16.sp,
                  color: AppColors.secondaryBlack,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Phone Field ──────────────────────────────────────────────────────────────
