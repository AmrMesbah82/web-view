part of '../pages/about_us_page.dart';

class _DesktopTopTabItem extends StatefulWidget {
  final int index;
  final String label;
  final String svgAsset;

  /// CMS navigation-label icon URL (from the admin app). When non-empty it
  /// takes priority over [svgAsset].
  final String iconUrl;
  final bool isSelected;
  final Color primaryColor, secondaryColor;
  final VoidCallback onTap;
  const _DesktopTopTabItem({
    required this.index,
    required this.label,
    required this.svgAsset,
    this.iconUrl = '',
    required this.isSelected,
    required this.primaryColor,
    required this.secondaryColor,
    required this.onTap,
  });
  @override
  State<_DesktopTopTabItem> createState() => _DesktopTopTabItemState();
}

class _DesktopTopTabItemState extends State<_DesktopTopTabItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bool sel = widget.isSelected;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.only(right: 8.w),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 48.r,
                height: 48.r,
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
                    size: 24.sp,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                widget.label,
                style: StyleText.fontSize14Weight400.copyWith(
                  fontSize: 13.sp,
                  fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                  color: sel ? widget.primaryColor : AppColors.secondaryBlack,
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
// Desktop Tab Item (left panel — Vision / Mission / Values)
// ══════════════════════════════════════════════════════════════════════════════
