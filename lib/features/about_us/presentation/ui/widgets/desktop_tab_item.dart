part of '../pages/about_us_page.dart';

class _DesktopTabItem extends StatefulWidget {
  final String label, iconUrl, selectedDesc;
  final bool isSelected;
  final Color primaryColor, secondaryColor;
  final VoidCallback onTap;
  const _DesktopTabItem({
    required this.label,
    required this.iconUrl,
    required this.selectedDesc,
    required this.isSelected,
    required this.onTap,
    required this.primaryColor,
    required this.secondaryColor,
  });
  @override
  State<_DesktopTabItem> createState() => _DesktopTabItemState();
}

class _DesktopTabItemState extends State<_DesktopTabItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    // ✅ FIX: icon uses primaryColor on secondary background when not selected,
    // so the real uploaded image shows through. Only apply white tint when selected.
    final Color iconBg = widget.isSelected
        ? widget.primaryColor
        : widget.secondaryColor;
    final Color hoverBg = _hoverTint(widget.primaryColor);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? _kSurface
                : (_hovered ? hoverBg : _kSurface),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 42.r,
                    height: 42.r,
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: widget.iconUrl.isNotEmpty
                          ? _netImg(
                        url: widget.iconUrl,
                        width: 24.sp,
                        height: 24.sp,
                        fit: BoxFit.contain,
                        // ✅ FIX: colorFilter only when selected (white overlay)
                        // When not selected, render the real image colors
                        colorFilter: widget.isSelected
                            ? const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn)
                            : null,
                      )
                          : Icon(
                        Icons.image_outlined,
                        size: 20.sp,
                        color: widget.isSelected
                            ? Colors.white
                            : widget.primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Flexible(
                    child: Text(
                      widget.label,
                      style: StyleText.fontSize18Weight500.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: widget.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              // ✅ FIX: selectedDesc is '' for Values tab so this block
              // never renders for Values → no extra padding
              if (widget.isSelected && widget.selectedDesc.isNotEmpty) ...[
                SizedBox(height: 10.h),
                Text(
                  widget.selectedDesc,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: StyleText.fontSize13Weight400.copyWith(
                    fontSize: 11.sp,
                    height: 1.65,
                    color: AppColors.secondaryBlack,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Desktop Right Panel
// ══════════════════════════════════════════════════════════════════════════════
