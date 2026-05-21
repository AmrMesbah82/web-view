part of '../pages/careers_page.dart';

class _DesktopDeliverableButtons extends StatelessWidget {
  final List<String> deliverables;
  final Color primary;
  final bool isRtl;
  final double fontSize;
  final int? selectedIndex;
  final ValueChanged<int> onSelectIndex;

  const _DesktopDeliverableButtons({
    required this.deliverables,
    required this.primary,
    required this.isRtl,
    required this.fontSize,
    required this.selectedIndex,
    required this.onSelectIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6.w,
      runSpacing: 6.h,
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          _t('Deliverables:', 'المخرجات:', isRtl),
          style: StyleText.fontSize11Weight600.copyWith(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        ...List.generate(deliverables.length, (index) {
          return GestureDetector(
            onTap: () => onSelectIndex(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                  horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                deliverables[index],
                style: StyleText.fontSize11Weight400.copyWith(
                  fontSize: fontSize,
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

// ─── Desktop helper text widgets ─────────────────────────────────────────────
