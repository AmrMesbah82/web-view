part of '../pages/careers_page.dart';

class _MobileStatsSection extends StatelessWidget {
  final Color primary;
  final bool isRtl;
  final List<CareerStatItem> statistics;
  const _MobileStatsSection({
    required this.primary,
    required this.isRtl,
    required this.statistics,
  });

  @override
  Widget build(BuildContext context) {
    if (statistics.isEmpty) return const SizedBox.shrink();
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: statistics
            .map(
              (s) => Padding(
            padding: EdgeInsets.only(bottom: 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isRtl ? s.title.ar : s.title.en,
                  style: StyleText.fontSize28Weight600.copyWith(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: primary,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  isRtl ? s.shortDescription.ar : s.shortDescription.en,
                  style: StyleText.fontSize13Weight400.copyWith(
                    fontSize: 13.sp,
                    height: 1.5,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        )
            .toList(),
      ),
    );
  }
}
