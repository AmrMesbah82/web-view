part of '../pages/job_page.dart';

class _ViewJobBtn extends StatefulWidget {
  final String jobId;
  final String label;
  final Color primary;
  const _ViewJobBtn(
      {required this.jobId, required this.label, required this.primary});

  @override
  State<_ViewJobBtn> createState() => _ViewJobBtnState();
}

class _ViewJobBtnState extends State<_ViewJobBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.go('/jobs/${widget.jobId}'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: _hovered
                ? Color.lerp(widget.primary, Colors.black, 0.15)!
                : widget.primary,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            widget.label,
            style: StyleText.fontSize14Weight400.copyWith(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ),
    );
  }
}
