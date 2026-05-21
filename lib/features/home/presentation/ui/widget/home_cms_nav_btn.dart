part of '../pages/home_page.dart';

// ── CMS nav button ────────────────────────────────────────────────────────────

class _CmsNavBtn extends StatefulWidget {
  final String label;
  final String route;
  final Color  primary;
  final bool   mobile;
  final bool   isRtl;

  const _CmsNavBtn({
    required this.label,
    required this.route,
    required this.primary,
    this.mobile = false,
    this.isRtl  = false,
  });

  @override
  State<_CmsNavBtn> createState() => _CmsNavBtnState();
}

class _CmsNavBtnState extends State<_CmsNavBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.cairo(
      fontSize:   13.sp,
      fontWeight: AppFontWeights.semiBold,
      color:      _hovered ? Colors.white : widget.primary,
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.route.isNotEmpty
            ? () => context.go(widget.route)
            : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve:    Curves.easeInOut,
          height:   48.h,
          padding:  EdgeInsets.symmetric(
              horizontal: widget.mobile ? 16.w : 22.w),
          decoration: BoxDecoration(
            color: _hovered
                ? widget.primary.withOpacity(.3)
                : Colors.white,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(child: Text(widget.label, style: textStyle)),
        ),
      ),
    );
  }
}
