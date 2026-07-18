part of '../pages/about_us_page.dart';

class _TabletTabItem extends StatefulWidget {
  final String label, iconUrl;
  final bool isSelected;
  final Color primaryColor, secondaryColor;
  final VoidCallback onTap;
  const _TabletTabItem({
    required this.label,
    required this.iconUrl,
    required this.isSelected,
    required this.onTap,
    required this.primaryColor,
    required this.secondaryColor,
  });
  @override
  State<_TabletTabItem> createState() => _TabletTabItemState();
}

class _TabletTabItemState extends State<_TabletTabItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final Color hoverBg = _hoverTint(widget.primaryColor);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? widget.primaryColor
                : (_hovered ? hoverBg : _kSurface),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: widget.isSelected
                  ? widget.primaryColor
                  : (_hovered
                  ? widget.primaryColor.withOpacity(0.3)
                  : _kDivider),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.iconUrl.isNotEmpty)
              // ✅ FIX: white filter only when selected
                _netImg(
                  url: widget.iconUrl,
                  width: 16.sp,
                  height: 16.sp,
                  fit: BoxFit.contain,
                  colorFilter: widget.isSelected
                      ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
                      : null,
                )
              else
                Icon(
                  Icons.image_outlined,
                  size: 16.sp,
                  color: widget.isSelected ? Colors.white : widget.primaryColor,
                ),
              SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  widget.label,
                  style: StyleText.fontSize12Weight600.copyWith(
                    fontFamily: 'Cairo',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: widget.isSelected
                        ? Colors.white
                        : widget.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Tablet Content Panel
// ══════════════════════════════════════════════════════════════════════════════
