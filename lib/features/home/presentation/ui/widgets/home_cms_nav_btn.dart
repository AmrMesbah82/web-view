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
      child: Semantics(
        button: true,
        label: widget.label,
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
          // BUG-135: white text on a 30 % tint was 1.54:1 — the hover state is
          // now the solid brand colour (white on #008037 ≈ 5:1).
          decoration: BoxDecoration(
            color: _hovered
                ? widget.primary
                : Colors.white,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(child: Text(widget.label, style: textStyle)),
        ),
      ),
      ),
    );
  }
}
