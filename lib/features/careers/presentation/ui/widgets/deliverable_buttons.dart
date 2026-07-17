part of '../pages/careers_page.dart';

class _DeliverableButtons extends StatefulWidget {
  final List<String> deliverables;
  final Color primary;
  final bool isRtl;
  final bool isExpanded;
  final VoidCallback onTap;

  const _DeliverableButtons({
    required this.deliverables,
    required this.primary,
    required this.isRtl,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  State<_DeliverableButtons> createState() => _DeliverableButtonsState();
}

class _DeliverableButtonsState extends State<_DeliverableButtons> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 6.w,
          runSpacing: 6.h,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              _t('Deliverables:', 'المخرجات:', widget.isRtl),
              style: StyleText.fontSize12Weight600.copyWith(
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            ...List.generate(widget.deliverables.length, (index) {
              return GestureDetector(
                onTap: () => setState(() {
                  _selectedIndex =
                  _selectedIndex == index ? null : index;
                }),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    widget.deliverables[index],
                    style: StyleText.fontSize11Weight400.copyWith(
                      fontSize: 10.sp,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// DESKTOP BODY
// ═══════════════════════════════════════════════════════════════════════════════
