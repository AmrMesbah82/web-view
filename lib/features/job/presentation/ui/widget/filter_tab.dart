part of '../pages/job_page.dart';

class _FilterTab extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _FilterTab(
      {required this.label, required this.isSelected, required this.onTap});

  @override
  State<_FilterTab> createState() => _FilterTabState();
}

class _FilterTabState extends State<_FilterTab> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final Color hoverBg = Color.lerp(Colors.white, _kGreen, 0.10)!;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: EdgeInsets.only(right: 4.w),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? _kGreen
                : (_hovered ? hoverBg : Colors.transparent),
            borderRadius: BorderRadius.circular(7.r),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: widget.isSelected
                  ? Colors.white
                  : (_hovered ? _kGreen : Colors.black54),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Job Card ─────────────────────────────────────────────────────────────────
