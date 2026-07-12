part of '../pages/about_us_page.dart';

class _MobileTopTabItem extends StatefulWidget {
  final int index;
  final String label;
  final String svgAsset;

  /// CMS navigation-label icon URL (from the admin app). When non-empty it
  /// takes priority over [svgAsset].
  final String iconUrl;
  final bool isSelected;
  final Color primaryColor, secondaryColor;
  final VoidCallback onTap;
  const _MobileTopTabItem({
    this.index = 0,
    required this.label,
    required this.svgAsset,
    this.iconUrl = '',
    required this.isSelected,
    required this.primaryColor,
    required this.secondaryColor,
    required this.onTap,
  });
  @override
  State<_MobileTopTabItem> createState() => _MobileTopTabItemState();
}

class _MobileTopTabItemState extends State<_MobileTopTabItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bool sel = widget.isSelected;
    final Color hoverBg = _hoverTint(widget.primaryColor);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.only(right: 8.w),
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: sel ? Colors.transparent : (_hovered ? hoverBg : Colors.transparent),
            borderRadius: BorderRadius.circular(8.r),
            border: Border(
              bottom: BorderSide(
                color: sel ? widget.primaryColor : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 48.sp,
                height: 48.sp,
                decoration: BoxDecoration(
                  color: sel ? widget.primaryColor : widget.secondaryColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: _topTabIcon(
                    iconUrl: widget.iconUrl,
                    fallback: _kTopTabFallbackIcons[
                        widget.index.clamp(0, _kTopTabFallbackIcons.length - 1)],
                    color: sel ? Colors.white : widget.primaryColor,
                    size: 26.sp,
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                widget.label,
                style: StyleText.fontSize20Weight600.copyWith(
                  color: sel
                      ? widget.primaryColor
                      : (_hovered ? widget.primaryColor : AppColors.secondaryBlack),
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
// Mobile About Us Content
// ══════════════════════════════════════════════════════════════════════════════
