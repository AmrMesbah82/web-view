part of '../pages/about_us_page.dart';

class _MobileTopTabItem extends StatefulWidget {
  final String label;
  final String svgAsset;
  final bool isSelected;
  final Color primaryColor, secondaryColor;
  final VoidCallback onTap;
  const _MobileTopTabItem({
    required this.label,
    required this.svgAsset,
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
                  child: SvgPicture.asset(
                    widget.svgAsset,
                    width: 26.sp,
                    height: 26.sp,
                    fit: BoxFit.contain,
                    colorFilter: ColorFilter.mode(
                      sel ? Colors.white : widget.primaryColor,
                      BlendMode.srcIn,
                    ),
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
