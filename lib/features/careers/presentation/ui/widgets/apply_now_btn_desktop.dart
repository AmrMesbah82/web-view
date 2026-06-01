part of '../pages/careers_page.dart';

class _ApplyNowBtnDesktop extends StatefulWidget {
  final String label;
  final Color primary;
  final bool isTablet;
  final bool isRtl;
  const _ApplyNowBtnDesktop({
    required this.label,
    required this.primary,
    this.isTablet = false,
    required this.isRtl,
  });

  @override
  State<_ApplyNowBtnDesktop> createState() => _ApplyNowBtnDesktopState();
}

class _ApplyNowBtnDesktopState extends State<_ApplyNowBtnDesktop> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => _hovered = true),
    onExit: (_) => setState(() => _hovered = false),
    child: GestureDetector(
      onTap: () => context.go('/jobs'),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: widget.isTablet ? 18.w : 22.w,
          vertical: widget.isTablet ? 8.h : 9.h,
        ),
        decoration: BoxDecoration(
          color: _hovered
              ? Color.alphaBlend(
              Colors.black.withOpacity(0.15), widget.primary)
              : widget.primary,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          widget.label,
          style: StyleText.fontSize14Weight600.copyWith(
            fontSize: widget.isTablet ? 11.sp : 13.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}
