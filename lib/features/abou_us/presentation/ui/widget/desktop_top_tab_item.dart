part of '../pages/about_us_page.dart';

class _DesktopTopTabItem extends StatefulWidget {
  final int index;
  final String label;
  final String svgAsset;
  final bool isSelected;
  final Color primaryColor, secondaryColor;
  final VoidCallback onTap;
  const _DesktopTopTabItem({
    required this.index,
    required this.label,
    required this.svgAsset,
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
                  child: SvgPicture.asset(
                    widget.svgAsset,
                    width: 24.sp,
                    height: 24.sp,
                    fit: BoxFit.contain,
                    colorFilter: ColorFilter.mode(
                      sel ? Colors.white : widget.primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                widget.label,
                style: TextStyle(
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
